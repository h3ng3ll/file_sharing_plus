import 'dart:async';

import 'package:nsd/nsd.dart' as nsd;

/// A server found on the local network (or added manually).
class DiscoveredServer {
  final String name;
  final String host;
  final int port;

  /// Whether the entry was typed in by the user rather than discovered via
  /// mDNS. Manual entries are the fallback when Bonjour discovery is blocked
  /// by the network.
  final bool isManual;

  const DiscoveredServer({
    required this.name,
    required this.host,
    required this.port,
    this.isManual = false,
  });

  /// Stable identity used to dedupe discovered/manual entries.
  String get id => '$host:$port';

  @override
  bool operator ==(Object other) =>
      other is DiscoveredServer && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Wraps the `nsd` plugin to advertise (server) and browse (client) the
/// file-sharing Bonjour service.
///
/// The service type must match `NSBonjourServices` in the iOS `Info.plist`.
class DiscoveryService {
  /// Bonjour/mDNS service type advertised and browsed by the app.
  static const String serviceType = '_filesharing._tcp';

  nsd.Registration? _registration;
  nsd.Discovery? _discovery;
  final _serversController =
      StreamController<List<DiscoveredServer>>.broadcast();

  /// Emits the current set of discovered servers whenever it changes.
  Stream<List<DiscoveredServer>> get servers => _serversController.stream;

  /// Advertises a server with [name] reachable on [port]. Called on macOS.
  Future<void> registerServer({
    required String name,
    required int port,
  }) async {
    await unregisterServer();
    _registration = await nsd.register(
      nsd.Service(
        name: name,
        type: serviceType,
        port: port,
      ),
    );
  }

  /// Stops advertising the server.
  Future<void> unregisterServer() async {
    final registration = _registration;
    if (registration != null) {
      await nsd.unregister(registration);
      _registration = null;
    }
  }

  /// Starts browsing for servers. Called on iOS. Results arrive on [servers].
  Future<void> startDiscovery() async {
    await stopDiscovery();
    final discovery = await nsd.startDiscovery(
      serviceType,
      autoResolve: true,
    );
    discovery.addListener(() => _emit(discovery));
    _discovery = discovery;
    _emit(discovery);
  }

  /// Stops browsing for servers.
  Future<void> stopDiscovery() async {
    final discovery = _discovery;
    if (discovery != null) {
      await nsd.stopDiscovery(discovery);
      _discovery = null;
    }
  }

  void _emit(nsd.Discovery discovery) {
    final servers = discovery.services
        .where((s) => s.host != null && s.port != null)
        .map(
          (s) => DiscoveredServer(
            name: s.name ?? s.host!,
            host: s.host!,
            port: s.port!,
          ),
        )
        .toList();
    _serversController.add(servers);
  }

  /// Releases all resources.
  Future<void> dispose() async {
    await unregisterServer();
    await stopDiscovery();
    await _serversController.close();
  }
}
