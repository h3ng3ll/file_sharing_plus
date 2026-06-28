import 'package:hive_ce/hive.dart';

import '../../domain/models/server_settings.dart';
import '../../domain/repositories/i_server_settings_repository.dart';

/// Hive-backed [IServerSettingsRepository].
///
/// Stores a single record under [_key], overwritten whenever a setting changes.
/// The opened box is injected, so the repository owns no Hive setup/teardown.
class HiveServerSettingsRepository implements IServerSettingsRepository {
  final Box<ServerSettings> _box;

  HiveServerSettingsRepository({required Box<ServerSettings> box}) : _box = box;

  static const String _key = 'current';

  @override
  int? readPort() => _box.get(_key)?.port;

  @override
  Future<void> savePort(int port) =>
      _box.put(_key, ServerSettings(port: port));
}
