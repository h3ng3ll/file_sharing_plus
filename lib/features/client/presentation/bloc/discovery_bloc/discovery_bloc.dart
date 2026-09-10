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
    on<_ConsumeSignal>(_consumeSignal);
  }

  Future<void> _start(_Start event, Emitter<DiscoveryState> emit) async {
    emit(state.copyWith(status: DiscoveryStatus.discovering));
    _discoverServersUseCase.servers.listen(
      (servers) => add(DiscoveryEvent.discoveredUpdated(servers)),
    );
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
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: DiscoveryStatus.discovering,
          checkingServer: null,
          // A discovered entry can outlive the server it points at, so this
          // is an expected outcome rather than a discovery failure.
          discovered: state.discovered.where((s) => s != server).toList(),
          manual: state.manual.where((s) => s != server).toList(),
          unreachableMessage:
              '${server.name} is not available now (${server.host}:${server.port})',
        ),
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
