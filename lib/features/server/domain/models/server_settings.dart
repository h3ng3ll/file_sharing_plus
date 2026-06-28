import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'server_settings.freezed.dart';

/// The server's persisted configuration.
///
/// Stored in Hive so the macOS server restores its settings (e.g. the sharing
/// [port]) across restarts. The adapter is generated centrally via
/// `@GenerateAdapters` in `core/hive/hive_adapters.dart`.
@freezed
sealed class ServerSettings extends HiveObject with _$ServerSettings {
  ServerSettings._();

  factory ServerSettings({required int port}) = _ServerSettings;
}
