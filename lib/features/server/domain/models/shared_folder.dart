import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'shared_folder.freezed.dart';

/// The server's persisted shared-folder selection.
///
/// Stored in Hive so the macOS server restores the last chosen folder across
/// restarts. The adapter is generated centrally via `@GenerateAdapters` in
/// `core/hive/hive_adapters.dart`.
@freezed
sealed class SharedFolder extends HiveObject with _$SharedFolder {
  SharedFolder._();

  factory SharedFolder({required String path}) = _SharedFolder;
}
