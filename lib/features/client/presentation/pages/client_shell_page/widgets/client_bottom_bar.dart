import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/resources/colors/app_colors.dart';

/// Bottom navigation bar for the iOS client shell.
///
/// Switches between the [StatefulNavigationShell] branches (Devices, Settings)
/// and reflects the currently selected branch.
class ClientBottomBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ClientBottomBar({
    super.key,
    required this.navigationShell,
  });

  void _onTapTab(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab returns it to its root route.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _onTapTab,
      backgroundColor: AppColors.surface.value,
      indicatorColor: AppColors.primary.value,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.devices_outlined),
          selectedIcon: Icon(Icons.devices),
          label: 'Devices',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
