import 'package:get_it/get_it.dart';

import '../../../core/services/discovery_service.dart';
import '../../../core/services/network_info_service.dart';
import '../data/repositories/http_server_repository.dart';
import '../domain/repositories/i_server_repository.dart';
import '../domain/use_cases/select_folder_use_case.dart';
import '../domain/use_cases/server_session_use_case.dart';
import '../domain/use_cases/start_server_use_case.dart';
import '../domain/use_cases/stop_server_use_case.dart';
import '../presentation/bloc/server_bloc/server_bloc.dart';

/// Registers the macOS server feature's dependencies.
void initServerFeature(GetIt getIt) {
  getIt.registerLazySingleton<IServerRepository>(
    () => HttpServerRepository(),
  );

  getIt.registerFactory(
    () => StartServerUseCase(
      serverRepository: getIt<IServerRepository>(),
      discoveryService: getIt<DiscoveryService>(),
      networkInfoService: getIt<NetworkInfoService>(),
    ),
  );
  getIt.registerFactory(
    () => StopServerUseCase(
      serverRepository: getIt<IServerRepository>(),
      discoveryService: getIt<DiscoveryService>(),
    ),
  );
  getIt.registerFactory(
    () => const SelectFolderUseCase(),
  );
  getIt.registerFactory(
    () => ServerSessionUseCase(
      serverRepository: getIt<IServerRepository>(),
    ),
  );

  getIt.registerFactory<ServerBloc>(
    () => ServerBloc(
      serverSessionUseCase: getIt<ServerSessionUseCase>(),
      startServerUseCase: getIt<StartServerUseCase>(),
      stopServerUseCase: getIt<StopServerUseCase>(),
      selectFolderUseCase: getIt<SelectFolderUseCase>(),
    ),
  );
}
