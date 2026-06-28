import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/services/discovery_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/browser_bloc/browser_bloc.dart';
import 'widgets/browser_body.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(title: widget.server.name),
        body: const BrowserBody(),
        floatingActionButton: const UploadButton(),
      ),
    );
  }
}
