import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/discovery_service.dart';
import '../../../../../core/services/file_share_service.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../domain/models/transfer_progress.dart';
import '../../../domain/models/transfer_record.dart';
import '../../bloc/browser_bloc/browser_bloc.dart';
import 'widgets/browser_body.dart';
import 'widgets/transfer_progress_tile.dart';
import 'widgets/upload_button.dart';

/// iOS file-browser screen for a single connected server.
class FileBrowserPage extends StatefulWidget {
  final DiscoveredServer server;

  const FileBrowserPage({
    super.key,
    required this.server,
  });

  @override
  State<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends State<FileBrowserPage> {
  late final BrowserBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<BrowserBloc>()..add(BrowserEvent.init(widget.server));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _openHistory() {
    // HistoryBloc is provided by the client ShellRoute, so the history screen
    // resolves it from context — no bloc is passed through `extra`.
    context.push(AppRoutes.clientBrowserHistory);
  }

  void _notifyTransfer(TransferRecord record) {
    final isDownload = record.direction == TransferDirection.download;
    final verb = isDownload ? 'Download' : 'Upload';

    if (!record.success) {
      UiMessageService.showError('$verb failed: ${record.fileName}');
      return;
    }

    if (isDownload && record.savedPath != null) {
      // Offer "Save to Files" so the user can place the file where they can
      // find it; the app's own storage is not browsable in the Files app.
      UiMessageService.showSuccess(
        'Downloaded ${record.fileName} — choose where to save',
      );
      FileShareService.saveFile(
        record.savedPath!,
        subject: record.fileName,
      );
    } else {
      UiMessageService.showSuccess('$verb complete: ${record.fileName}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: MultiBlocListener(
        listeners: [
          // File-listing failures.
          BlocListener<BrowserBloc, BrowserState>(
            listenWhen: (p, c) => p.status != c.status && c.isFailure,
            listener: (context, state) =>
                UiMessageService.showError(state.errorMessage),
          ),
          // Per-transfer result, surfaced when a transfer finishes.
          BlocListener<BrowserBloc, BrowserState>(
            listenWhen: (p, c) =>
                c.lastTransfer != null && c.lastTransfer != p.lastTransfer,
            listener: (context, state) => _notifyTransfer(state.lastTransfer!),
          ),
          // One-shot info messages (e.g. a successful delete).
          BlocListener<BrowserBloc, BrowserState>(
            listenWhen: (p, c) =>
                c.infoMessage != null && c.infoMessage != p.infoMessage,
            listener: (context, state) =>
                UiMessageService.showSuccess(state.infoMessage!),
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: widget.server.name,
            actions: [
              IconButton(
                icon: const Icon(Icons.history),
                tooltip: 'Transfer history',
                onPressed: _openHistory,
              ),
            ],
          ),
          body: const Stack(
            children: [
              BrowserBody(),
              TransferProgressTile(),
            ],
          ),
          floatingActionButton: const UploadButton(),
        ),
      ),
    );
  }
}
