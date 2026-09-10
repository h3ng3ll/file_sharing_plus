import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../../domain/models/connected_device.dart';
import '../../../bloc/server_bloc/server_bloc.dart';

/// Lists devices that have connected to the server.
class ConnectedDevicesList extends StatelessWidget {
  const ConnectedDevicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        return SectionCard(
          title: 'Connected Devices (${state.devices.length})',
          child: state.devices.isEmpty
              ? Text(
                  'No devices connected yet',
                  style: AppTextStyle.regular14.value.copyWith(
                    color: AppColors.textSecondary.value,
                  ),
                )
              : Column(
                  children: state.devices
                      .map((device) => _DeviceTile(device: device))
                      .toList(),
                ),
        );
      },
    );
  }
}

/// A single connected-device row.
class _DeviceTile extends StatelessWidget {
  final ConnectedDevice device;

  const _DeviceTile({required this.device});

  @override
  Widget build(BuildContext context) {
    // Only an open event stream proves the device is still there; anything
    // else is a device that was seen recently and may already have left.
    final isLive = device.hasOpenEventStream;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.phone_iphone,
        color: isLive ? AppColors.accent.value : AppColors.textSecondary.value,
      ),
      title: Text(
        device.address,
        style: AppTextStyle.regular14.value,
      ),
      subtitle: Text(
        isLive
            ? 'Connected · ${device.requestCount} requests'
            : 'Idle · ${device.requestCount} requests',
        style: AppTextStyle.regular12.value.copyWith(
          color: AppColors.textSecondary.value,
        ),
      ),
    );
  }
}
