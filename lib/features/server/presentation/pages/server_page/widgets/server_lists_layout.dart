import 'package:flutter/material.dart';

import 'activity_log_list.dart';
import 'connected_devices_list.dart';
import 'server_controls.dart';
import 'shared_files_list.dart';

/// Arranges the server screen's cards responsively by available width.
///
/// Wide windows show two equal columns that expand to fill the width: the left
/// column holds the Server card with Shared Files beneath it, and the right
/// column holds Connected Devices with the Activity Log beneath it. Narrow
/// windows collapse everything into a single full-width stacked column.
class ServerListsLayout extends StatelessWidget {
  /// Minimum width at which the layout splits into two columns.
  static const double _twoColumnMinWidth = 760.0;

  /// Gap between cards and columns.
  static const double _gap = 24.0;

  const ServerListsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnMinWidth) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ServerControls(),
              SizedBox(height: _gap),
              SharedFilesList(),
              SizedBox(height: _gap),
              ConnectedDevicesList(),
              SizedBox(height: _gap),
              ActivityLogList(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ServerControls(),
                  SizedBox(height: _gap),
                  SharedFilesList(),
                ],
              ),
            ),
            SizedBox(width: _gap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConnectedDevicesList(),
                  SizedBox(height: _gap),
                  ActivityLogList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
