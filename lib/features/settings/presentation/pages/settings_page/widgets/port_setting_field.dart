import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/services/ui_message_service.dart';
import '../../../../../../core/widgets/btn/app_btn.dart';
import '../../../../../../core/widgets/section_card.dart';
import '../../../../../server/presentation/bloc/server_bloc/server_bloc.dart';

/// Lowest valid port (avoids the privileged 0–1023 range).
const int _minPort = 1024;

/// Highest valid TCP port.
const int _maxPort = 65535;

/// Lets the user change the server's sharing port.
///
/// Reads the current port from [ServerBloc], validates the entry and dispatches
/// [ServerEvent.portChanged]. Editing is disabled while the server is running
/// because the bound port cannot change until the next start.
class PortSettingField extends StatefulWidget {
  const PortSettingField({super.key});

  @override
  State<PortSettingField> createState() => _PortSettingFieldState();
}

class _PortSettingFieldState extends State<PortSettingField> {
  final TextEditingController _controller = TextEditingController();
  int? _lastSyncedPort;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Keeps the field in sync with the bloc's port when it isn't being edited.
  void _syncController(int port) {
    if (_lastSyncedPort == port) return;
    _lastSyncedPort = port;
    _controller.text = port.toString();
  }

  void _onSave(BuildContext context) {
    final port = int.tryParse(_controller.text.trim());
    if (port == null || port < _minPort || port > _maxPort) {
      UiMessageService.showError(
        'Enter a port between $_minPort and $_maxPort',
      );
      return;
    }
    context.read<ServerBloc>().add(ServerEvent.portChanged(port));
    UiMessageService.showSuccess('Port set to $port');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerBloc, ServerState>(
      builder: (context, state) {
        _syncController(state.port);
        final locked = state.isRunning || state.isStarting;
        return SectionCard(
          title: 'Sharing port',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                enabled: !locked,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Port',
                  border: const OutlineInputBorder(),
                  helperText: locked
                      ? 'Stop the server to change the port'
                      : 'Allowed range: $_minPort–$_maxPort',
                ),
              ),
              const SizedBox(height: 12.0),
              PrimaryBtn(
                text: 'Save',
                icon: Icons.save,
                onPressed: locked ? null : () => _onSave(context),
              ),
              if (locked) ...[
                const SizedBox(height: 8.0),
                Text(
                  'The server is running on port ${state.port}.',
                  style: AppTextStyle.regular12.value.copyWith(
                    color: AppColors.textSecondary.value,
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
