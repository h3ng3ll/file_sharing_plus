import 'package:file_sharing/core/models/file_entry/file_entry.dart';
import 'package:file_sharing/core/services/discovery_service.dart';
import 'package:file_sharing/features/client/domain/models/transfer_progress.dart';
import 'package:file_sharing/features/client/domain/models/transfer_record.dart';
import 'package:file_sharing/features/client/presentation/bloc/browser_bloc/browser_bloc.dart';
import 'package:file_sharing/features/client/presentation/bloc/discovery_bloc/discovery_bloc.dart';
import 'package:file_sharing/features/client/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:file_sharing/features/server/domain/models/activity_log_entry.dart';
import 'package:file_sharing/features/server/domain/models/connected_device.dart';
import 'package:file_sharing/features/server/presentation/bloc/server_bloc/server_bloc.dart';

/// Polished, deterministic fake state used to render every screen for marketing
/// screenshots. Timestamps are fixed literals (never `DateTime.now()`) so each
/// capture is byte-reproducible.
abstract final class MarketingData {
  // A stable reference instant for all timestamps.
  static final DateTime _at = DateTime(2026, 6, 28, 14, 30);

  // ---------------------------------------------------------------------------
  // Server (macOS)
  // ---------------------------------------------------------------------------

  static const List<FileEntry> _sharedFiles = [
    FileEntry(name: 'Documents', isDirectory: true),
    FileEntry(name: 'Photos', isDirectory: true),
    FileEntry(name: 'Quarterly Report.pdf', isDirectory: false, size: 2457600),
    FileEntry(name: 'Keynote.pptx', isDirectory: false, size: 18874368),
    FileEntry(name: 'budget-2026.xlsx', isDirectory: false, size: 1048576),
    FileEntry(name: 'logo.png', isDirectory: false, size: 524288),
  ];

  static List<ConnectedDevice> get _devices => [
        ConnectedDevice(
          address: '192.168.1.50',
          lastSeen: _at,
          requestCount: 12,
        ),
        ConnectedDevice(
          address: '192.168.1.75',
          lastSeen: _at.subtract(const Duration(minutes: 3)),
          requestCount: 5,
        ),
      ];

  static List<ActivityLogEntry> get _activityLog => [
        ActivityLogEntry(
          type: ActivityType.download,
          message: "192.168.1.50 downloaded 'Quarterly Report.pdf'",
          timestamp: _at,
        ),
        ActivityLogEntry(
          type: ActivityType.upload,
          message: "192.168.1.75 uploaded 'meeting-notes.txt'",
          timestamp: _at.subtract(const Duration(minutes: 1)),
        ),
        ActivityLogEntry(
          type: ActivityType.connection,
          message: '192.168.1.75 connected',
          timestamp: _at.subtract(const Duration(minutes: 2)),
        ),
        ActivityLogEntry(
          type: ActivityType.delete,
          message: "192.168.1.50 deleted 'draft.tmp'",
          timestamp: _at.subtract(const Duration(minutes: 4)),
        ),
        ActivityLogEntry(
          type: ActivityType.download,
          message: "192.168.1.50 downloaded 'logo.png'",
          timestamp: _at.subtract(const Duration(minutes: 6)),
        ),
        ActivityLogEntry(
          type: ActivityType.connection,
          message: '192.168.1.50 connected',
          timestamp: _at.subtract(const Duration(minutes: 8)),
        ),
        ActivityLogEntry(
          type: ActivityType.serverStarted,
          message: 'Server started on port 8080',
          timestamp: _at.subtract(const Duration(minutes: 10)),
        ),
      ];

  /// Server up and running with files, devices and a busy activity log.
  static ServerState get serverRunning => ServerState(
        status: ServerStatus.running,
        port: 8080,
        ipAddress: '192.168.1.42',
        sharedFolder: '/Users/alex/Shared',
        files: _sharedFiles,
        devices: _devices,
        log: _activityLog,
      );

  /// First-launch / idle: nothing selected, server stopped.
  static const ServerState serverStoppedEmpty = ServerState();

  /// A previously selected folder that no longer exists on disk.
  static ServerState get serverFolderMissing => ServerState(
        sharedFolder: '/Users/alex/Removed Drive/Shared',
        sharedFolderMissing: true,
        log: [
          ActivityLogEntry(
            type: ActivityType.serverStopped,
            message: 'Server stopped',
            timestamp: _at,
          ),
        ],
      );

  // ---------------------------------------------------------------------------
  // Client — discovery
  // ---------------------------------------------------------------------------

  static const DiscoveredServer macBookPro = DiscoveredServer(
    name: "Alex's MacBook Pro",
    host: '192.168.1.42',
    port: 8080,
  );

  static const List<DiscoveredServer> _discovered = [
    macBookPro,
    DiscoveredServer(
      name: 'Studio iMac',
      host: '192.168.1.18',
      port: 8080,
    ),
  ];

  static const List<DiscoveredServer> _manual = [
    DiscoveredServer(
      name: '192.168.1.99',
      host: '192.168.1.99',
      port: 8080,
      isManual: true,
    ),
  ];

  /// Several Macs found on the network, including one added manually.
  static const DiscoveryState discoveryPopulated = DiscoveryState(
    status: DiscoveryStatus.discovering,
    discovered: _discovered,
    manual: _manual,
  );

  /// Actively searching, nothing found yet.
  static const DiscoveryState discoveryEmpty = DiscoveryState(
    status: DiscoveryStatus.discovering,
  );

  // ---------------------------------------------------------------------------
  // Client — file browser
  // ---------------------------------------------------------------------------

  static const List<FileEntry> _browserFiles = [
    FileEntry(name: 'Photos', isDirectory: true),
    FileEntry(name: 'Projects', isDirectory: true),
    FileEntry(name: 'vacation.mp4', isDirectory: false, size: 163577856),
    FileEntry(name: 'presentation.pdf', isDirectory: false, size: 3145728),
    FileEntry(name: 'family.jpg', isDirectory: false, size: 2621440),
    FileEntry(name: 'song.mp3', isDirectory: false, size: 5242880),
    FileEntry(name: 'notes.txt', isDirectory: false, size: 4096),
    FileEntry(name: 'archive.zip', isDirectory: false, size: 41943040),
  ];

  /// Browsing a populated folder on the connected server.
  static const BrowserState browserPopulated = BrowserState(
    status: BrowserStatus.loaded,
    server: macBookPro,
    path: 'Documents',
    files: _browserFiles,
  );

  /// A download in flight at ~45%.
  static const BrowserState browserTransferring = BrowserState(
    status: BrowserStatus.loaded,
    server: macBookPro,
    path: 'Documents',
    files: _browserFiles,
    progress: TransferProgress(
      fileName: 'vacation.mp4',
      direction: TransferDirection.download,
      transferred: 73625088,
      total: 163577856,
    ),
  );

  /// An empty folder, showing the empty state.
  static const BrowserState browserEmptyFolder = BrowserState(
    status: BrowserStatus.loaded,
    server: macBookPro,
    path: 'Documents/Empty',
    files: [],
  );

  // ---------------------------------------------------------------------------
  // Client — transfer history
  // ---------------------------------------------------------------------------

  static List<TransferRecord> get _historyRecords => [
        TransferRecord(
          fileName: 'presentation.pdf',
          direction: TransferDirection.download,
          success: true,
          timestamp: _at,
          savedPath: '/var/mobile/Containers/Data/presentation.pdf',
        ),
        TransferRecord(
          fileName: 'meeting-notes.txt',
          direction: TransferDirection.upload,
          success: true,
          timestamp: _at.subtract(const Duration(minutes: 4)),
        ),
        TransferRecord(
          fileName: 'family.jpg',
          direction: TransferDirection.download,
          success: true,
          timestamp: _at.subtract(const Duration(minutes: 12)),
          savedPath: '/var/mobile/Containers/Data/family.jpg',
        ),
        TransferRecord(
          fileName: 'huge-video.mov',
          direction: TransferDirection.download,
          success: false,
          timestamp: _at.subtract(const Duration(minutes: 20)),
        ),
        TransferRecord(
          fileName: 'logo.png',
          direction: TransferDirection.upload,
          success: true,
          timestamp: _at.subtract(const Duration(hours: 1)),
        ),
        TransferRecord(
          fileName: 'budget-2026.xlsx',
          direction: TransferDirection.download,
          success: true,
          timestamp: _at.subtract(const Duration(hours: 2)),
          savedPath: '/var/mobile/Containers/Data/budget-2026.xlsx',
        ),
      ];

  /// A history with a mix of uploads/downloads and one failure.
  static HistoryState get historyPopulated => HistoryState(
        status: HistoryStatus.loaded,
        records: _historyRecords,
      );

  /// No transfers yet.
  static const HistoryState historyEmpty = HistoryState(
    status: HistoryStatus.loaded,
  );
}
