import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'activity_log_list.dart';
import 'connected_devices_list.dart';
import 'server_controls.dart';
import 'shared_files_list.dart';

/// Arranges the server screen's cards into two columns on wide windows.
///
/// On wide (TABLET+) windows: the left column holds the Server card with the
/// Shared Files list beneath it, and the right column holds Connected Devices
/// with the Activity Log beneath it, top-aligned next to the Server card. On
/// narrow windows everything collapses into a single full-width stacked column.
class ServerListsLayout extends StatelessWidget {
  /// Fixed width of each column on wide windows.
  static const double _columnWidth = 420.0;

  /// Gap between cards and columns.
  static const double _gap = 24.0;

  const ServerListsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    const leftChildren = <Widget>[
      ServerControls(),
      SizedBox(height: _gap),
      SharedFilesList(),
    ];
    const rightChildren = <Widget>[
      ConnectedDevicesList(),
      SizedBox(height: _gap),
      ActivityLogList(),
    ];

    if (!isWide) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...leftChildren,
          SizedBox(height: _gap),
          ...rightChildren,
        ],
      );
    }

    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _columnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: leftChildren,
          ),
        ),
        SizedBox(width: _gap),
        SizedBox(
          width: _columnWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rightChildren,
          ),
        ),
      ],
    );
  }
}
