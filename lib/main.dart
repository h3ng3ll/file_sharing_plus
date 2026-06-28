import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:window_manager/window_manager.dart';

import 'core/bloc/app_observer.dart';
import 'core/di/injection.dart';
import 'core/hive/hive_initializer.dart';
import 'core/resources/app_theme.dart';
import 'core/routes/init_router/init_router.dart';
import 'core/services/ui_message_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce a minimum window size on desktop so the layout never overflows
  // when the window is shrunk. Not applicable on mobile.
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    // Fits one column (Server card + single-column Shared Files) at its minimum
    // width; the layout collapses to a single stacked column at this size.
    await windowManager.setMinimumSize(const Size(420.0, 600.0));
  }

  await initHive();
  await initDependencies();
  Bloc.observer = const AppObserver();
  runApp(const MyApp());
}

/// Root application widget.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = initRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'File Sharing',
      theme: AppThemeData.light,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: UiMessageService.messengerKey,
      routerConfig: _router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 900, name: TABLET),
          Breakpoint(start: 900, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
