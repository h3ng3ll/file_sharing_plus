import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../bloc/server_bloc/server_bloc.dart';
import 'widgets/server_lists_layout.dart';

/// macOS server screen.
class ServerPage extends StatefulWidget {
  const ServerPage({super.key});

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  late final ServerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<ServerBloc>()..add(const ServerEvent.init());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<ServerBloc, ServerState>(
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
        child: const Scaffold(
          appBar: CustomAppBar(title: 'File Sharing — Server'),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: HorizontalPadding(
              child: ServerListsLayout(),
            ),
          ),
        ),
      ),
    );
  }
}
