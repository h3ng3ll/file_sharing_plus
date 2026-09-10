import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/services/discovery_service.dart';
import '../../../bloc/discovery_bloc/discovery_bloc.dart';

/// Renders the list of discovered and manually-added servers.
class DeviceListView extends StatelessWidget {
  final ValueChanged<DiscoveredServer> onTapServer;
  final ValueChanged<DiscoveredServer> onRemoveServer;

  const DeviceListView({
    super.key,
    required this.onTapServer,
    required this.onRemoveServer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoveryBloc, DiscoveryState>(
      builder: (context, state) {
        final servers = state.allServers;
        if (servers.isEmpty) {
          return _EmptyState(state: state);
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: servers.length,
          separatorBuilder: (_, _) => const Divider(height: 1.0),
          itemBuilder: (context, index) {
            final server = servers[index];
            return Dismissible(
              key: ValueKey(server.id),
              direction: DismissDirection.endToStart,
              background: const _RemoveBackground(),
              onDismissed: (_) => onRemoveServer(server),
              child: _DeviceTile(
                server: server,
                // Scope the spinner to the row actually being checked.
                isChecking: state.isCheckingServer &&
                    state.checkingServer == server,
                reachability: state.reachabilityOf(server),
                onTap: onTapServer,
              ),
            );
          },
        );
      },
    );
  }
}

/// A single server row.
class _DeviceTile extends StatelessWidget {
  final DiscoveredServer server;
  final bool isChecking;
  final ServerReachability reachability;
  final ValueChanged<DiscoveredServer> onTap;

  const _DeviceTile({
    required this.server,
    required this.isChecking,
    required this.reachability,
    required this.onTap,
  });

  /// Dot colour for the current reachability.
  Color get _statusColor => switch (reachability) {
        ServerReachability.online => AppColors.accent.value,
        ServerReachability.offline => AppColors.danger.value,
        _ => AppColors.textSecondary.value,
      };

  String get _statusLabel => switch (reachability) {
        ServerReachability.online => 'Online',
        ServerReachability.offline => 'Offline',
        ServerReachability.checking => 'Checking…',
        ServerReachability.unknown => 'Not checked',
      };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        server.isManual ? Icons.edit_location_alt : Icons.computer,
        // A server that is advertising but not answering reads as offline:
        // mDNS keeps the entry alive after the Mac's server stops.
        color: reachability == ServerReachability.offline
            ? AppColors.textSecondary.value
            : AppColors.primary.value,
      ),
      title: Text(
        server.name,
        style: AppTextStyle.medium16.value,
      ),
      subtitle: Row(
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: _statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6.0),
          Expanded(
            child: Text(
              '$_statusLabel · ${server.host}:${server.port}',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.regular12.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
          ),
        ],
      ),
      trailing: isChecking
          ? const SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            )
          : const Icon(Icons.chevron_right),
      // Ignore further taps while this row's reachability check is in flight.
      onTap: isChecking ? null : () => onTap(server),
    );
  }
}

/// Red slab revealed when a device row is swiped from the right.
class _RemoveBackground extends StatelessWidget {
  const _RemoveBackground();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.danger.value,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(Icons.delete, color: AppColors.white.value),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final DiscoveryState state;

  const _EmptyState({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_find,
              size: 48.0,
              color: AppColors.textSecondary.value,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Searching for Macs on your network…',
              textAlign: TextAlign.center,
              style: AppTextStyle.regular16.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
            if (state.isFailure) ...[
              const SizedBox(height: 12.0),
              Text(
                state.errorMessage,
                textAlign: TextAlign.center,
                style: AppTextStyle.regular12.value.copyWith(
                  color: AppColors.danger.value,
                ),
              ),
            ],
            const SizedBox(height: 12.0),
            Text(
              'Tap + to add a server manually.',
              textAlign: TextAlign.center,
              style: AppTextStyle.regular12.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
