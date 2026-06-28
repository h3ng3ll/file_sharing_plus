import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/widgets/section_card.dart';
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
                      .map(
                        (device) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.phone_iphone,
                            color: AppColors.accent.value,
                          ),
                          title: Text(
                            device.address,
                            style: AppTextStyle.regular14.value,
                          ),
                          subtitle: Text(
                            '${device.requestCount} requests',
                            style: AppTextStyle.regular12.value.copyWith(
                              color: AppColors.textSecondary.value,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }
}
