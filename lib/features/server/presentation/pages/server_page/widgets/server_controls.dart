import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/widgets/btn/app_btn.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../bloc/server_bloc/server_bloc.dart';

/// Start/stop controls plus the server's address and shared folder.
class ServerControls extends StatelessWidget {
  const ServerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        final bloc = context.read<ServerBloc>();
        return SectionCard(
          title: 'Server',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StatusRow(state: state),
              const SizedBox(height: 12.0),
              _InfoRow(
                label: 'Address',
                value: state.isRunning && state.ipAddress != null
                    ? '${state.ipAddress}:${state.port}'
                    : '—',
              ),
              _InfoRow(
                label: 'Shared folder',
                value: state.sharedFolder == null
                    ? 'Not selected'
                    : state.sharedFolderMissing
                        ? '${state.sharedFolder} (missing — choose a new folder)'
                        : state.sharedFolder!,
                isError: state.sharedFolderMissing,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: PrimaryBtn(
                      text: state.isRunning ? 'Stop Server' : 'Start Server',
                      icon: state.isRunning ? Icons.stop : Icons.play_arrow,
                      color: state.isRunning ? AppColors.danger.value : null,
                      onPressed: state.isStarting
                          ? null
                          : () => bloc.add(
                                state.isRunning
                                    ? const ServerEvent.stopServer()
                                    : const ServerEvent.startServer(),
                              ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: PrimaryBtn(
                      text: 'Shared Folder',
                      icon: Icons.folder_open,
                      color: AppColors.accent.value,
                      onPressed: () =>
                          bloc.add(const ServerEvent.selectFolder()),
                    ),
                  ),
                ],
              ),
              if (state.isFailure) ...[
                const SizedBox(height: 12.0),
                Text(
                  state.errorMessage,
                  style: AppTextStyle.regular12.value.copyWith(
                    color: AppColors.danger.value,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatusRow extends StatelessWidget {
  final ServerState state;

  const _StatusRow({required this.state});

  @override
  Widget build(BuildContext context) {
    final color = state.isRunning
        ? AppColors.accent.value
        : state.isStarting
            ? AppColors.warning.value
            : AppColors.disabled.value;
    final label = state.isRunning
        ? 'Running'
        : state.isStarting
            ? 'Starting…'
            : 'Stopped';

    return Row(
      children: [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          label,
          style: AppTextStyle.medium14.value.copyWith(
            color: AppColors.textPrimary.value,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isError;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.0,
            child: Text(
              label,
              style: AppTextStyle.regular14.value.copyWith(
                color: AppColors.textSecondary.value,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.medium14.value.copyWith(
                color: isError
                    ? AppColors.danger.value
                    : AppColors.textPrimary.value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
