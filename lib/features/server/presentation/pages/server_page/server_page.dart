import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../bloc/server_bloc/server_bloc.dart';
import 'widgets/server_lists_layout.dart';

/// macOS server screen.
///
/// The [ServerBloc] is provided by the desktop shell route, so the pushed
/// settings page shares the same instance.
class ServerPage extends StatelessWidget {
  const ServerPage({super.key});

  void _openSettings(BuildContext context) {
    context.push(AppRoutes.settings);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerBloc, ServerState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.isFailure) {
          UiMessageService.showError(state.errorMessage);
        } else if (state.isRunning) {
          UiMessageService.showSuccess('Server started');
        } else if (state.isStopped) {
          UiMessageService.showSuccess('Server stopped');
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'File Sharing — Server',
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () => _openSettings(context),
            ),
          ],
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: HorizontalPadding(
            child: ServerListsLayout(),
          ),
        ),
      ),
    );
  }
}
