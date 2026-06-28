import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/services/discovery_service.dart';
import '../../../domain/repositories/i_client_repository.dart';
import '../../../domain/use_cases/discover_servers_use_case.dart';

part 'discovery_event.dart';
part 'discovery_state.dart';
part 'discovery_bloc.freezed.dart';

/// Drives the iOS device-list screen: mDNS discovery plus manual entries.
class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  final DiscoverServersUseCase _discoverServersUseCase;
  final IClientRepository _clientRepository;

  DiscoveryBloc({
    required DiscoverServersUseCase discoverServersUseCase,
    required IClientRepository clientRepository,
  })  : _discoverServersUseCase = discoverServersUseCase,
        _clientRepository = clientRepository,
        super(const DiscoveryState()) {
    on<_Start>(_start);
    on<_DiscoveredUpdated>(_discoveredUpdated);
    on<_AddManual>(_addManual);
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
    final reachable = await _clientRepository.ping(
      host: event.host,
      port: event.port,
    );
    if (!reachable) {
      emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: 'No server reachable at ${event.host}:${event.port}',
        ),
      );
      return;
    }

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
  }
}
