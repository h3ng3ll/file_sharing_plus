import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'core/bloc/app_observer.dart';
import 'core/di/injection.dart';
import 'core/resources/app_theme.dart';
import 'core/routes/init_router/init_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      routerConfig: _router,
    );
  }
}
