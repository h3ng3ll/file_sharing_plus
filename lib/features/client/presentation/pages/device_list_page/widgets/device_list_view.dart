import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/services/discovery_service.dart';
import '../../../bloc/discovery_bloc/discovery_bloc.dart';

/// Renders the list of discovered and manually-added servers.
class DeviceListView extends StatelessWidget {
  final ValueChanged<DiscoveredServer> onTapServer;

  const DeviceListView({
    super.key,
    required this.onTapServer,
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
            return ListTile(
              leading: Icon(
                server.isManual ? Icons.edit_location_alt : Icons.computer,
                color: AppColors.primary.value,
              ),
              title: Text(
                server.name,
                style: AppTextStyle.medium16.value,
              ),
              subtitle: Text(
                '${server.host}:${server.port}',
                style: AppTextStyle.regular12.value.copyWith(
                  color: AppColors.textSecondary.value,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onTapServer(server),
            );
          },
        );
      },
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
