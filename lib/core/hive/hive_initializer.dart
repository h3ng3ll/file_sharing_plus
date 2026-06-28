import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../features/client/domain/models/transfer_record.dart';
import '../../features/server/domain/models/shared_folder.dart';
import '../di/injection.dart';
import 'hive_registrar.g.dart';

/// Box that persists the transfer history.
const String transferHistoryBoxName = 'transfer_history';

/// Box that persists the server's selected shared folder.
const String sharedFolderBoxName = 'shared_folder';

/// Initializes Hive, registers the generated adapters, opens the app boxes and
/// registers them in [getIt].
///
/// Must run before [initDependencies] so feature repositories can resolve their
/// boxes.
Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapters();

  final historyBox = await Hive.openBox<TransferRecord>(
    transferHistoryBoxName,
  );
  getIt.registerSingleton<Box<TransferRecord>>(historyBox);

  final sharedFolderBox = await Hive.openBox<SharedFolder>(
    sharedFolderBoxName,
  );
  getIt.registerSingleton<Box<SharedFolder>>(sharedFolderBox);
}
