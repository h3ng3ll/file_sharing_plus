import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/services/discovery_service.dart';
import '../../../core/services/network_info_service.dart';
import '../data/repositories/hive_server_settings_repository.dart';
import '../data/repositories/hive_shared_folder_repository.dart';
import '../data/repositories/http_server_repository.dart';
import '../domain/models/server_settings.dart';
import '../domain/models/shared_folder.dart';
import '../domain/repositories/i_server_repository.dart';
import '../domain/repositories/i_server_settings_repository.dart';
import '../domain/repositories/i_shared_folder_repository.dart';
import '../domain/use_cases/persist_port_use_case.dart';
import '../domain/use_cases/persist_shared_folder_use_case.dart';
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
  getIt.registerLazySingleton<ISharedFolderRepository>(
    () => HiveSharedFolderRepository(
      box: getIt<Box<SharedFolder>>(),
    ),
  );
  getIt.registerLazySingleton<IServerSettingsRepository>(
    () => HiveServerSettingsRepository(
      box: getIt<Box<ServerSettings>>(),
    ),
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
  getIt.registerFactory(
    () => PersistSharedFolderUseCase(
      sharedFolderRepository: getIt<ISharedFolderRepository>(),
    ),
  );
  getIt.registerFactory(
    () => PersistPortUseCase(
      serverSettingsRepository: getIt<IServerSettingsRepository>(),
    ),
  );

  getIt.registerFactory<ServerBloc>(
    () => ServerBloc(
      serverSessionUseCase: getIt<ServerSessionUseCase>(),
      startServerUseCase: getIt<StartServerUseCase>(),
      stopServerUseCase: getIt<StopServerUseCase>(),
      selectFolderUseCase: getIt<SelectFolderUseCase>(),
      persistSharedFolderUseCase: getIt<PersistSharedFolderUseCase>(),
      persistPortUseCase: getIt<PersistPortUseCase>(),
    ),
  );
}
