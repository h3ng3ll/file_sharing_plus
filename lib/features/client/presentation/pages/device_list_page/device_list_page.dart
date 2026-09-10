import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/injection.dart';
import '../../../../../core/routes/init_router/init_router.dart';
import '../../../../../core/services/discovery_service.dart';
import '../../../../../core/services/ui_message_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../bloc/discovery_bloc/discovery_bloc.dart';
import 'widgets/device_list_view.dart';
import 'widgets/manual_add_dialog.dart';

/// iOS device-list screen: shows discovered Macs and allows manual entry.
class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  late final DiscoveryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<DiscoveryBloc>()..add(const DiscoveryEvent.start());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _openManualAdd() async {
    final entry = await showDialog<ManualEntry>(
      context: context,
      builder: (_) => const ManualAddDialog(),
    );
    if (entry != null) {
      _bloc.add(
        DiscoveryEvent.addManual(host: entry.host, port: entry.port),
      );
    }
  }

  /// Asks the bloc to confirm the server is still reachable.
  ///
  /// Navigation happens only once the ping succeeds — a discovered entry keeps
  /// the port mDNS resolved for it, so it goes stale as soon as the Mac's
  /// server stops or restarts on a different port.
  void _onTapServer(DiscoveredServer server) {
    _bloc.add(DiscoveryEvent.openServer(server));
  }

  void _onSignal(BuildContext context, DiscoveryState state) {
    final unreachable = state.unreachableMessage;
    final verified = state.verifiedServer;

    if (unreachable != null) {
      UiMessageService.showError(unreachable);
    } else if (verified != null) {
      context.push(AppRoutes.clientBrowser, extra: verified);
    }

    _bloc.add(const DiscoveryEvent.consumeSignal());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<DiscoveryBloc, DiscoveryState>(
            listenWhen: (p, c) => p.status != c.status && c.isFailure,
            listener: (context, state) =>
                UiMessageService.showError(state.errorMessage),
          ),
          // One-shot result of a tapped server's reachability check.
          BlocListener<DiscoveryBloc, DiscoveryState>(
            listenWhen: (p, c) =>
                c.verifiedServer != null || c.unreachableMessage != null,
            listener: _onSignal,
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Available Devices',
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'How to use',
              onPressed: () => context.push(AppRoutes.clientInfo),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add manually',
              onPressed: _openManualAdd,
            ),
          ],
        ),
          body: DeviceListView(onTapServer: _onTapServer),
        ),
      ),
    );
  }
}
