import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/client_bottom_bar.dart';

/// Hosts the iOS client's bottom navigation bar.
///
/// The [navigationShell] renders the active branch (Devices or Settings); the
/// bar is hidden automatically on routes pushed above the shell (e.g. the file
/// browser and transfer history) because those sit on the root navigator.
class ClientShellPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ClientShellPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClientBottomBar(navigationShell: navigationShell),
    );
  }
}
