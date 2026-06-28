import 'package:get_it/get_it.dart';

import '../../../core/services/discovery_service.dart';
import '../data/repositories/http_client_repository.dart';
import '../domain/repositories/i_client_repository.dart';
import '../domain/use_cases/discover_servers_use_case.dart';
import '../domain/use_cases/download_file_use_case.dart';
import '../domain/use_cases/list_files_use_case.dart';
import '../domain/use_cases/upload_file_use_case.dart';
import '../presentation/bloc/browser_bloc/browser_bloc.dart';
import '../presentation/bloc/discovery_bloc/discovery_bloc.dart';

/// Registers the iOS client feature's dependencies.
void initClientFeature(GetIt getIt) {
  getIt.registerLazySingleton<IClientRepository>(
    () => HttpClientRepository(),
  );

  getIt.registerFactory(
    () => DiscoverServersUseCase(
      discoveryService: getIt<DiscoveryService>(),
    ),
  );
  getIt.registerFactory(
    () => ListFilesUseCase(
      clientRepository: getIt<IClientRepository>(),
    ),
  );
  getIt.registerFactory(
    () => DownloadFileUseCase(
      clientRepository: getIt<IClientRepository>(),
    ),
  );
  getIt.registerFactory(
    () => UploadFileUseCase(
      clientRepository: getIt<IClientRepository>(),
    ),
  );

  getIt.registerFactory<DiscoveryBloc>(
    () => DiscoveryBloc(
      discoverServersUseCase: getIt<DiscoverServersUseCase>(),
      clientRepository: getIt<IClientRepository>(),
    ),
  );
  getIt.registerFactory<BrowserBloc>(
    () => BrowserBloc(
      listFilesUseCase: getIt<ListFilesUseCase>(),
      downloadFileUseCase: getIt<DownloadFileUseCase>(),
      uploadFileUseCase: getIt<UploadFileUseCase>(),
    ),
  );
}
