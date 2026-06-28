import 'package:get_it/get_it.dart';

import '../../features/client/di/client_injection.dart';
import '../../features/server/di/server_injection.dart';
import '../services/discovery_service.dart';
import '../services/network_info_service.dart';

/// Global service locator.
final getIt = GetIt.instance;

/// Registers all application dependencies.
///
/// Shared core services are registered first, then each feature wires its own
/// repositories, use cases and blocs.
Future<void> initDependencies() async {
  // Core services.
  getIt.registerLazySingleton(() => NetworkInfoService());
  getIt.registerLazySingleton(() => DiscoveryService());

  // Features.
  initServerFeature(getIt);
  initClientFeature(getIt);
}
