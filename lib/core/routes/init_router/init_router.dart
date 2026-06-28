import 'dart:io';

import 'package:go_router/go_router.dart';

import '../../../features/client/presentation/pages/device_list_page/device_list_page.dart';
import '../../../features/client/presentation/pages/file_browser_page/file_browser_page.dart';
import '../../../features/client/presentation/pages/info_page/info_page.dart';
import '../../../features/server/presentation/pages/server_page/server_page.dart';
import '../../services/discovery_service.dart';

/// Route paths used across the app.
abstract final class AppRoutes {
  static const String server = '/server';
  static const String client = '/client';
  static const String clientBrowser = '/client/browser';
  static const String clientInfo = '/client/info';
}

/// Builds the application router.
///
/// The initial route is chosen by platform: macOS runs the server UI, every
/// other platform (iOS) runs the client UI.
GoRouter initRouter() {
  return GoRouter(
    initialLocation: Platform.isMacOS ? AppRoutes.server : AppRoutes.client,
    routes: [
      GoRoute(
        path: AppRoutes.server,
        builder: (context, state) => const ServerPage(),
      ),
      GoRoute(
        path: AppRoutes.client,
        builder: (context, state) => const DeviceListPage(),
        routes: [
          GoRoute(
            path: 'browser',
            builder: (context, state) => FileBrowserPage(
              server: state.extra as DiscoveredServer,
            ),
          ),
          GoRoute(
            path: 'info',
            builder: (context, state) => const InfoPage(),
          ),
        ],
      ),
    ],
  );
}
