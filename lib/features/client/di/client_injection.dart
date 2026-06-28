import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';

import '../../../core/services/discovery_service.dart';
import '../data/repositories/hive_history_repository.dart';
import '../data/repositories/http_client_repository.dart';
import '../domain/models/transfer_record.dart';
import '../domain/repositories/i_client_repository.dart';
import '../domain/repositories/i_history_repository.dart';
import '../domain/use_cases/delete_file_use_case.dart';
import '../domain/use_cases/discover_servers_use_case.dart';
import '../domain/use_cases/download_file_use_case.dart';
import '../domain/use_cases/list_files_use_case.dart';
import '../domain/use_cases/ping_server_use_case.dart';
import '../domain/use_cases/record_transfer_use_case.dart';
import '../domain/use_cases/upload_file_use_case.dart';
import '../domain/use_cases/watch_files_use_case.dart';
import '../presentation/bloc/browser_bloc/browser_bloc.dart';
import '../presentation/bloc/discovery_bloc/discovery_bloc.dart';
import '../presentation/bloc/history_bloc/history_bloc.dart';

/// Registers the iOS client feature's dependencies.
void initClientFeature(GetIt getIt) {
  getIt.registerLazySingleton<IClientRepository>(
    () => HttpClientRepository(),
  );
  getIt.registerLazySingleton<IHistoryRepository>(
    () => HiveHistoryRepository(
      box: getIt<Box<TransferRecord>>(),
    ),
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
  getIt.registerFactory(
    () => WatchFilesUseCase(
      clientRepository: getIt<IClientRepository>(),
    ),
  );
  getIt.registerFactory(
    () => PingServerUseCase(
      clientRepository: getIt<IClientRepository>(),
    ),
  );
  getIt.registerFactory(
    () => RecordTransferUseCase(
      historyRepository: getIt<IHistoryRepository>(),
    ),
  );
  getIt.registerFactory(
    () => DeleteFileUseCase(
      clientRepository: getIt<IClientRepository>(),
    ),
  );

  getIt.registerFactory<DiscoveryBloc>(
    () => DiscoveryBloc(
      discoverServersUseCase: getIt<DiscoverServersUseCase>(),
      pingServerUseCase: getIt<PingServerUseCase>(),
    ),
  );
  getIt.registerFactory<BrowserBloc>(
    () => BrowserBloc(
      listFilesUseCase: getIt<ListFilesUseCase>(),
      downloadFileUseCase: getIt<DownloadFileUseCase>(),
      uploadFileUseCase: getIt<UploadFileUseCase>(),
      watchFilesUseCase: getIt<WatchFilesUseCase>(),
      recordTransferUseCase: getIt<RecordTransferUseCase>(),
      deleteFileUseCase: getIt<DeleteFileUseCase>(),
    ),
  );
  getIt.registerFactory<HistoryBloc>(
    () => HistoryBloc(
      historyRepository: getIt<IHistoryRepository>(),
    ),
  );
}
