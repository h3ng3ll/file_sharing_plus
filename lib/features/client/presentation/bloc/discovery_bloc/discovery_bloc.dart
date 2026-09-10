import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/discovery_service.dart';
import '../../../domain/use_cases/discover_servers_use_case.dart';
import '../../../domain/use_cases/ping_server_use_case.dart';

part 'discovery_event.dart';
part 'discovery_state.dart';
part 'discovery_bloc.freezed.dart';

/// Drives the iOS device-list screen: mDNS discovery plus manual entries.
class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final DiscoverServersUseCase _discoverServersUseCase;
  final PingServerUseCase _pingServerUseCase;

  /// How often listed servers are re-probed.
  ///
  /// mDNS reports nothing when a cached server merely starts or stops
  /// answering, so a status that is only refreshed on list changes goes stale.
  /// Polling is the only way to notice, short of the user tapping refresh.
  static const Duration _kReachabilityPollInterval = Duration(seconds: 5);

  /// Held so the single stream listener is not stacked on every rescan, and is
  /// released with the bloc.
  StreamSubscription<List<DiscoveredServer>>? _serversSubscription;

  /// Drives the periodic reachability re-probe.
  Timer? _reachabilityPoll;

  /// Guards against overlapping probes: an unreachable host blocks on its
  /// connect timeout, which can outlast the poll interval.
  bool _probing = false;

  DiscoveryBloc({
    required DiscoverServersUseCase discoverServersUseCase,
    required PingServerUseCase pingServerUseCase,
  })  : _discoverServersUseCase = discoverServersUseCase,
        _pingServerUseCase = pingServerUseCase,
        super(const DiscoveryState()) {
    on<_Start>(_start);
    on<_DiscoveredUpdated>(_discoveredUpdated);
    on<_AddManual>(_addManual);
    on<_OpenServer>(_openServer);
    on<_RemoveServer>(_removeServer);
    on<_Rescan>(_rescan);
    on<_RefreshReachability>(_refreshReachability);
    on<_ConsumeSignal>(_consumeSignal);
  }

  Future<void> _start(_Start event, Emitter<DiscoveryState> emit) async {
    _serversSubscription ??= _discoverServersUseCase.servers.listen(
      (servers) => add(DiscoveryEvent.discoveredUpdated(servers)),
    );
    _reachabilityPoll ??= Timer.periodic(
      _kReachabilityPollInterval,
      (_) {
        if (!isClosed) add(const DiscoveryEvent.refreshReachability());
      },
    );
    await _scan(emit);
  }

  /// Restarts the mDNS browse so servers that appeared or vanished since the
  /// last scan are re-resolved.
  ///
  /// The stale list is cleared first: entries are only trustworthy as far as
  /// the last resolution, and a rescan re-adds everything still advertising
  /// within a moment. Manual entries survive — the user typed those.
  Future<void> _rescan(_Rescan event, Emitter<DiscoveryState> emit) async {
    emit(
      state.copyWith(
        discovered: const <DiscoveredServer>[],
        // Manual entries survive the rescan, so re-probe them too.
        reachability: const <String, ServerReachability>{},
        // An explicit rescan means "show me everything again".
        dismissedIds: const <String>{},
      ),
    );
    await _scan(emit);
    if (!isClosed) add(const DiscoveryEvent.refreshReachability());
  }

  Future<void> _scan(Emitter<DiscoveryState> emit) async {
    emit(state.copyWith(status: DiscoveryStatus.discovering));
    try {
      await _discoverServersUseCase.start();
    } catch (e) {
      emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _reachabilityPoll?.cancel();
    _reachabilityPoll = null;
    await _serversSubscription?.cancel();
    await _discoverServersUseCase.stop();
    return super.close();
  }

  void _discoveredUpdated(
    _DiscoveredUpdated event,
    Emitter<DiscoveryState> emit,
  ) {
    emit(
      state.copyWith(
        status: DiscoveryStatus.discovering,
        discovered: event.servers,
      ),
    );
    // mDNS keeps advertising a stopped server for a while, so a new listing
    // is a reason to re-probe rather than something to trust.
    add(const DiscoveryEvent.refreshReachability());
  }

  /// Pings every listed server so each row reports online/offline.
  Future<void> _refreshReachability(
    _RefreshReachability event,
    Emitter<DiscoveryState> emit,
  ) async {
    final servers = state.allServers;
    if (servers.isEmpty || _probing) return;
    _probing = true;

    emit(
      state.copyWith(
        reachability: {
          for (final server in servers)
            server.id: state.reachability[server.id] == null
                ? ServerReachability.checking
                : state.reachability[server.id]!,
        },
      ),
    );

    try {
      final results = await Future.wait(
        servers.map(
          (server) async {
            final result = await _pingServerUseCase(
              host: server.host,
              port: server.port,
            );
            return MapEntry(
              server.id,
              result.isLeft()
                  ? ServerReachability.online
                  : ServerReachability.offline,
            );
          },
        ),
      );

      if (isClosed) return;
      // The list can change while the pings are in flight, so keep only
      // results for servers that are still listed.
      final live = state.allServers.map((server) => server.id).toSet();
      emit(
        state.copyWith(
          reachability: Map.fromEntries(
            results.where((entry) => live.contains(entry.key)),
          ),
        ),
      );
    } finally {
      _probing = false;
    }
  }

  Future<void> _addManual(
    _AddManual event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(state.copyWith(status: DiscoveryStatus.validatingManual));
    final result = await _pingServerUseCase(
      host: event.host,
      port: event.port,
    );
    result.fold(
      (_) {
        final server = DiscoveredServer(
          name: '${event.host} (manual)',
          host: event.host,
          port: event.port,
          isManual: true,
        );
        final manual = {...state.manual, server}.toList();
        emit(
          state.copyWith(
            status: DiscoveryStatus.discovering,
            manual: manual,
            reachability: {
              ...state.reachability,
              server.id: ServerReachability.online,
            },
          ),
        );
      },
      (failure) => emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
    );
  }

  Future<void> _openServer(
    _OpenServer event,
    Emitter<DiscoveryState> emit,
  ) async {
    final server = event.server;

    emit(
      state.copyWith(
        status: DiscoveryStatus.checkingServer,
        checkingServer: server,
        verifiedServer: null,
        unreachableMessage: null,
      ),
    );

    final result = await _pingServerUseCase(
      host: server.host,
      port: server.port,
    );

    result.fold(
      (_) => emit(
        state.copyWith(
          status: DiscoveryStatus.discovering,
          checkingServer: null,
          verifiedServer: server,
          reachability: {
            ...state.reachability,
            server.id: ServerReachability.online,
          },
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: DiscoveryStatus.discovering,
          checkingServer: null,
          reachability: {
            ...state.reachability,
            server.id: ServerReachability.offline,
          },
          // The entry is NOT removed here. `discovered` mirrors what mDNS
          // currently advertises, and the plugin only re-emits on change — so
          // dropping a live-but-briefly-unreachable Mac would hide it until
          // the next genuine mDNS change, forcing a manual re-add. Let
          // discovery own that list; the user removes entries explicitly.
          unreachableMessage:
              '${server.name} is not available now (${server.host}:${server.port})',
        ),
      ),
    );
  }

  void _removeServer(_RemoveServer event, Emitter<DiscoveryState> emit) {
    final server = event.server;

    emit(
      state.copyWith(
        discovered: state.discovered.where((s) => s != server).toList(),
        manual: state.manual.where((s) => s != server).toList(),
        // Drop a pending signal that referenced the removed server.
        checkingServer: state.checkingServer == server
            ? null
            : state.checkingServer,
        verifiedServer: state.verifiedServer == server
            ? null
            : state.verifiedServer,
        reachability: {...state.reachability}..remove(server.id),
        // mDNS will re-advertise this service, so remember the dismissal;
        // otherwise the next discovery emission puts the row straight back.
        dismissedIds: {...state.dismissedIds, server.id},
      ),
    );
  }

  void _consumeSignal(_ConsumeSignal event, Emitter<DiscoveryState> emit) {
    emit(
      state.copyWith(
        verifiedServer: null,
        unreachableMessage: null,
      ),
    );
  }
}
