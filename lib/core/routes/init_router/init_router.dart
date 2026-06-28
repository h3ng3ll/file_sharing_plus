import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/client/presentation/bloc/history_bloc/history_bloc.dart';
import '../../../features/client/presentation/pages/device_list_page/device_list_page.dart';
import '../../../features/client/presentation/pages/file_browser_page/file_browser_page.dart';
import '../../../features/client/presentation/pages/file_browser_page/transfer_history_page/transfer_history_page.dart';
import '../../../features/client/presentation/pages/info_page/info_page.dart';
import '../../../features/server/presentation/pages/server_page/server_page.dart';
import '../../di/injection.dart';
import '../../services/discovery_service.dart';

/// Route paths used across the app.
abstract final class AppRoutes {
  static const String server = '/server';
  static const String client = '/client';
  static const String clientBrowser = '/client/browser';
  static const String clientBrowserHistory = '/client/browser/history';
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
          // Shell scopes a single HistoryBloc to the browser + history routes,
          // so both read it from context — no bloc is passed via `extra`.
          ShellRoute(
            builder: (context, state, child) => BlocProvider<HistoryBloc>(
              create: (_) =>
                  getIt<HistoryBloc>()..add(const HistoryEvent.started()),
              child: child,
            ),
            routes: [
              GoRoute(
                path: 'browser',
                builder: (context, state) => FileBrowserPage(
                  // Plain data value object via `extra` — allowed.
                  server: state.extra! as DiscoveredServer,
                ),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const TransferHistoryPage(),
                  ),
                ],
              ),
            ],
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
