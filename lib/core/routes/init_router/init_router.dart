import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/client/presentation/bloc/history_bloc/history_bloc.dart';
import '../../../features/client/presentation/pages/client_shell_page/client_shell_page.dart';
import '../../../features/client/presentation/pages/device_list_page/device_list_page.dart';
import '../../../features/client/presentation/pages/file_browser_page/file_browser_page.dart';
import '../../../features/client/presentation/pages/file_browser_page/transfer_history_page/transfer_history_page.dart';
import '../../../features/client/presentation/pages/info_page/info_page.dart';
import '../../../features/legal/presentation/pages/privacy_policy_page/privacy_policy_page.dart';
import '../../../features/legal/presentation/pages/terms_of_use_page/terms_of_use_page.dart';
import '../../../features/server/presentation/bloc/server_bloc/server_bloc.dart';
import '../../../features/server/presentation/pages/server_page/server_page.dart';
import '../../../features/settings/presentation/pages/settings_page/settings_page.dart';
import '../../di/injection.dart';
import '../../services/discovery_service.dart';

/// Route paths used across the app.
abstract final class AppRoutes {
  static const String server = '/server';
  static const String settings = '/settings';
  static const String client = '/client';
  static const String clientSettings = '/client/settings';
  static const String clientBrowser = '/client/browser';
  static const String clientBrowserHistory = '/client/browser/history';
  static const String clientInfo = '/client/info';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfUse = '/terms-of-use';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Builds the application router.
///
/// The initial route is chosen by platform: macOS runs the server UI, every
/// other platform (iOS) runs the client UI.
GoRouter initRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Platform.isMacOS ? AppRoutes.server : AppRoutes.client,
    routes: [
      // Desktop (macOS) server routes. A ShellRoute scopes a single ServerBloc
      // to the server page and the pushed settings page so both share state.
      ShellRoute(
        builder: (context, state, child) => BlocProvider<ServerBloc>(
          create: (_) => getIt<ServerBloc>()..add(const ServerEvent.init()),
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.server,
            builder: (context, state) => const ServerPage(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      // Mobile (iOS) client routes behind a bottom navigation bar.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ClientShellPage(navigationShell: navigationShell),
        branches: [
          // Tab 1 — Devices, with the browser/history pushed above the shell.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.client,
                builder: (context, state) => const DeviceListPage(),
                routes: [
                  // Pushed on the root navigator so the bottom bar is hidden
                  // while browsing a server's files and history.
                  ShellRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state, child) =>
                        BlocProvider<HistoryBloc>(
                      create: (_) => getIt<HistoryBloc>()
                        ..add(const HistoryEvent.started()),
                      child: child,
                    ),
                    routes: [
                      GoRoute(
                        path: 'browser',
                        builder: (context, state) => FileBrowserPage(
                          server: state.extra! as DiscoveredServer,
                        ),
                        routes: [
                          GoRoute(
                            path: 'history',
                            builder: (context, state) =>
                                const TransferHistoryPage(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'info',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const InfoPage(),
                  ),
                ],
              ),
            ],
          ),
          // Tab 2 — Settings.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.clientSettings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      // Static legal pages, pushed full-screen above either platform's shell.
      GoRoute(
        path: AppRoutes.privacyPolicy,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyPage(),
      ),
      GoRoute(
        path: AppRoutes.termsOfUse,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TermsOfUsePage(),
      ),
    ],
  );
}
