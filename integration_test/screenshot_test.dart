import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_sharing/core/di/injection.dart';
import 'package:file_sharing/core/resources/app_theme.dart';
import 'package:file_sharing/core/services/ui_message_service.dart';
import 'package:file_sharing/features/client/presentation/bloc/browser_bloc/browser_bloc.dart';
import 'package:file_sharing/features/client/presentation/bloc/discovery_bloc/discovery_bloc.dart';
import 'package:file_sharing/features/client/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:file_sharing/features/client/presentation/pages/device_list_page/device_list_page.dart';
import 'package:file_sharing/features/client/presentation/pages/file_browser_page/file_browser_page.dart';
import 'package:file_sharing/features/client/presentation/pages/file_browser_page/transfer_history_page/transfer_history_page.dart';
import 'package:file_sharing/features/client/presentation/pages/info_page/info_page.dart';
import 'package:file_sharing/features/legal/presentation/pages/privacy_policy_page/privacy_policy_page.dart';
import 'package:file_sharing/features/legal/presentation/pages/terms_of_use_page/terms_of_use_page.dart';
import 'package:file_sharing/features/server/presentation/bloc/server_bloc/server_bloc.dart';
import 'package:file_sharing/features/server/presentation/pages/server_page/server_page.dart';
import 'package:file_sharing/core/widgets/custom_app_bar.dart';
import 'package:file_sharing/core/widgets/padding/horizontal_padding.dart';
import 'package:file_sharing/features/settings/presentation/pages/settings_page/settings_page.dart';
import 'package:file_sharing/features/settings/presentation/pages/settings_page/widgets/legal_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'fixtures/fake_blocs.dart';
import 'fixtures/marketing_data.dart';

/// Captures one polished, deterministic screenshot per screen for store
/// listings. macOS screens run when launched on `-d macos`; iOS screens run on
/// an iOS simulator. The output bytes are handed to the test driver, which
/// writes them to `screenshots/<platform>/<name>.png`.
///
/// iPad shots are captured on the macOS host too — the same offscreen
/// `RepaintBoundary` path the server screens use, with the surface sized to an
/// iPad logical viewport. No iPad simulator is needed and the result is
/// byte-reproducible.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // The harness never touches real networking, discovery or Hive: every page is
  // driven by a seeded fake bloc registered in get_it (or provided directly).
  // So we deliberately skip initHive()/initDependencies() — that avoids the Hive
  // box file lock and keeps captures hermetic and reproducible.

  /// Key on the RepaintBoundary that wraps the rendered page, used for the
  /// macOS direct-capture path.
  final boundaryKey = GlobalKey();

  /// Wraps [child] in the same app chrome the production app uses (theme,
  /// responsive breakpoints, global SnackBar messenger) so widgets that depend
  /// on them render correctly. A [RepaintBoundary] lets macOS capture the frame
  /// to an image without the integration_test plugin (which has no macOS impl).
  Widget host(Widget child) {
    return MaterialApp(
      theme: AppThemeData.light,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: UiMessageService.messengerKey,
      home: RepaintBoundary(key: boundaryKey, child: child),
      builder: (context, widget) => ResponsiveBreakpoints.builder(
        child: widget!,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 900, name: TABLET),
          Breakpoint(start: 900, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }

  /// Captures the boundary to a PNG and writes it under
  /// `screenshots/<folder>/`. Used on the macOS host, where the
  /// integration_test screenshot channel is unimplemented but the test process
  /// has direct filesystem access.
  Future<void> captureToFile(String folder, String name) async {
    final boundary =
        boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final dir = Directory('screenshots/$folder');
    await dir.create(recursive: true);
    await File('${dir.path}/$name.png').writeAsBytes(
      data!.buffer.asUint8List(),
    );
  }

  /// Pumps [widget], lets async work (markdown load, animations) settle and
  /// captures the frame under [name]. On macOS the page is sized to a desktop
  /// window so the responsive two-column layout shows; iOS uses the simulator's
  /// own screen size.
  Future<void> shoot(
    WidgetTester tester,
    String name,
    Widget widget,
  ) async {
    if (Platform.isMacOS) {
      await tester.binding.setSurfaceSize(const Size(1120.0, 760.0));
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }
    await tester.pumpWidget(host(widget));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    if (Platform.isMacOS) {
      await captureToFile('macos', name);
    } else {
      // iOS: the integration_test plugin captures the device frame; bytes are
      // routed to screenshots/ios by the test driver.
      await binding.takeScreenshot(name);
    }
  }

  /// Pumps [widget] at an iPad logical viewport and captures it offscreen.
  ///
  /// 1024x1366 dp at `pixelRatio: 2.0` yields exactly 2048x2732 px — an App
  /// Store iPad (12.9"/13") portrait size. The landscape variant transposes the
  /// surface to 1366x1024 dp, giving 2732x2048 px. Both run on the macOS host
  /// via the same `RepaintBoundary` path as the server screens, so no iPad
  /// simulator is required.
  Future<void> shootIpad(
    WidgetTester tester,
    String name,
    Widget widget, {
    bool landscape = false,
  }) async {
    await tester.binding.setSurfaceSize(
      landscape ? const Size(1366.0, 1024.0) : const Size(1024.0, 1366.0),
    );
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(host(widget));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    await captureToFile('ipad', name);
  }

  /// Re-registers a factory in get_it so the real page picks up our seeded fake
  /// from its own `getIt<T>()` call in initState.
  void override<T extends Object>(T instance) {
    if (getIt.isRegistered<T>()) getIt.unregister<T>();
    getIt.registerFactory<T>(() => instance);
  }

  // ===========================================================================
  // Server (macOS)
  // ===========================================================================

  group('server (macOS)', () {
    testWidgets('dashboard — running, populated', (tester) async {
      final bloc = seededServerBloc(MarketingData.serverRunning);
      await shoot(
        tester,
        'server-dashboard-running',
        BlocProvider<ServerBloc>.value(value: bloc, child: const ServerPage()),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('dashboard — stopped, empty', (tester) async {
      final bloc = seededServerBloc(MarketingData.serverStoppedEmpty);
      await shoot(
        tester,
        'server-dashboard-stopped',
        BlocProvider<ServerBloc>.value(value: bloc, child: const ServerPage()),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('dashboard — shared folder missing', (tester) async {
      final bloc = seededServerBloc(MarketingData.serverFolderMissing);
      await shoot(
        tester,
        'server-dashboard-folder-missing',
        BlocProvider<ServerBloc>.value(value: bloc, child: const ServerPage()),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('settings — port editable', (tester) async {
      final bloc = seededServerBloc(MarketingData.serverStoppedEmpty);
      await shoot(
        tester,
        'server-settings-port-editable',
        BlocProvider<ServerBloc>.value(value: bloc, child: const SettingsPage()),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('settings — port locked', (tester) async {
      final bloc = seededServerBloc(MarketingData.serverRunning);
      await shoot(
        tester,
        'server-settings-port-locked',
        BlocProvider<ServerBloc>.value(value: bloc, child: const SettingsPage()),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('privacy policy', (tester) async {
      await shoot(tester, 'server-privacy-policy', const PrivacyPolicyPage());
    }, skip: !Platform.isMacOS);

    testWidgets('terms of use', (tester) async {
      await shoot(tester, 'server-terms-of-use', const TermsOfUsePage());
    }, skip: !Platform.isMacOS);
  });

  // ===========================================================================
  // Client (iOS)
  // ===========================================================================

  group('client (iOS)', () {
    testWidgets('device list — populated', (tester) async {
      override<DiscoveryBloc>(
        seededDiscoveryBloc(MarketingData.discoveryPopulated),
      );
      await shoot(tester, 'client-device-list-populated', const DeviceListPage());
    }, skip: Platform.isMacOS);

    testWidgets('device list — searching', (tester) async {
      override<DiscoveryBloc>(seededDiscoveryBloc(MarketingData.discoveryEmpty));
      await shoot(tester, 'client-device-list-searching', const DeviceListPage());
    }, skip: Platform.isMacOS);

    testWidgets('file browser — populated', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserPopulated));
      await shoot(
        tester,
        'client-file-browser-populated',
        const FileBrowserPage(server: MarketingData.macBookPro),
      );
    }, skip: Platform.isMacOS);

    testWidgets('file browser — transfer in progress', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserTransferring));
      await shoot(
        tester,
        'client-file-browser-transferring',
        const FileBrowserPage(server: MarketingData.macBookPro),
      );
    }, skip: Platform.isMacOS);

    testWidgets('file browser — empty folder', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserEmptyFolder));
      await shoot(
        tester,
        'client-file-browser-empty',
        const FileBrowserPage(server: MarketingData.macBookPro),
      );
    }, skip: Platform.isMacOS);

    testWidgets('transfer history — populated', (tester) async {
      final bloc = seededHistoryBloc(MarketingData.historyPopulated);
      await shoot(
        tester,
        'client-transfer-history-populated',
        BlocProvider<HistoryBloc>.value(
          value: bloc,
          child: const TransferHistoryPage(),
        ),
      );
    }, skip: Platform.isMacOS);

    testWidgets('transfer history — empty', (tester) async {
      final bloc = seededHistoryBloc(MarketingData.historyEmpty);
      await shoot(
        tester,
        'client-transfer-history-empty',
        BlocProvider<HistoryBloc>.value(
          value: bloc,
          child: const TransferHistoryPage(),
        ),
      );
    }, skip: Platform.isMacOS);

    testWidgets('info — how to use', (tester) async {
      await shoot(tester, 'client-info', const InfoPage());
    }, skip: Platform.isMacOS);

    testWidgets('settings', (tester) async {
      await shoot(tester, 'client-settings', const SettingsPage());
    }, skip: Platform.isMacOS);

    testWidgets('privacy policy', (tester) async {
      await shoot(tester, 'client-privacy-policy', const PrivacyPolicyPage());
    }, skip: Platform.isMacOS);

    testWidgets('terms of use', (tester) async {
      await shoot(tester, 'client-terms-of-use', const TermsOfUsePage());
    }, skip: Platform.isMacOS);
  });

  // ===========================================================================
  // Client — iPad (captured on the macOS host, offscreen)
  // ===========================================================================
  //
  // iPadOS runs the client role, so these mirror the iOS client set at an iPad
  // viewport. Portrait is 2048x2732 px; the landscape shot is 2732x2048 px.
  // Both are App Store-accepted iPad sizes.

  group('client (iPad)', () {
    testWidgets('device list — populated', (tester) async {
      override<DiscoveryBloc>(
        seededDiscoveryBloc(MarketingData.discoveryPopulated),
      );
      await shootIpad(
        tester,
        'ipad-device-list-populated',
        const DeviceListPage(),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('device list — searching', (tester) async {
      override<DiscoveryBloc>(seededDiscoveryBloc(MarketingData.discoveryEmpty));
      await shootIpad(
        tester,
        'ipad-device-list-searching',
        const DeviceListPage(),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('file browser — populated', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserPopulated));
      await shootIpad(
        tester,
        'ipad-file-browser-populated',
        const FileBrowserPage(server: MarketingData.macBookPro),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('file browser — transfer in progress', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserTransferring));
      await shootIpad(
        tester,
        'ipad-file-browser-transferring',
        const FileBrowserPage(server: MarketingData.macBookPro),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('file browser — empty folder', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserEmptyFolder));
      await shootIpad(
        tester,
        'ipad-file-browser-empty',
        const FileBrowserPage(server: MarketingData.macBookPro),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('file browser — populated, landscape', (tester) async {
      override<BrowserBloc>(seededBrowserBloc(MarketingData.browserPopulated));
      await shootIpad(
        tester,
        'ipad-file-browser-populated-landscape',
        const FileBrowserPage(server: MarketingData.macBookPro),
        landscape: true,
      );
    }, skip: !Platform.isMacOS);

    testWidgets('transfer history — populated', (tester) async {
      final bloc = seededHistoryBloc(MarketingData.historyPopulated);
      await shootIpad(
        tester,
        'ipad-transfer-history-populated',
        BlocProvider<HistoryBloc>.value(
          value: bloc,
          child: const TransferHistoryPage(),
        ),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('transfer history — empty', (tester) async {
      final bloc = seededHistoryBloc(MarketingData.historyEmpty);
      await shootIpad(
        tester,
        'ipad-transfer-history-empty',
        BlocProvider<HistoryBloc>.value(
          value: bloc,
          child: const TransferHistoryPage(),
        ),
      );
    }, skip: !Platform.isMacOS);

    testWidgets('info — how to use', (tester) async {
      await shootIpad(tester, 'ipad-info', const InfoPage());
    }, skip: !Platform.isMacOS);

    testWidgets('settings', (tester) async {
      // `SettingsPage` gates the sharing-port field on `Platform.isMacOS`, so on
      // this macOS host it would render a control a real iPad never shows. The
      // client shape is reproduced here — the same Scaffold and `LegalSection`
      // an iPad builds — so the capture matches what users actually see.
      await shootIpad(tester, 'ipad-settings', const IpadSettingsView());
    }, skip: !Platform.isMacOS);

    testWidgets('privacy policy', (tester) async {
      await shootIpad(tester, 'ipad-privacy-policy', const PrivacyPolicyPage());
    }, skip: !Platform.isMacOS);

    testWidgets('terms of use', (tester) async {
      await shootIpad(tester, 'ipad-terms-of-use', const TermsOfUsePage());
    }, skip: !Platform.isMacOS);
  });
}

/// The client flavour of `SettingsPage`, for iPad captures.
///
/// `SettingsPage` shows the sharing-port field when `Platform.isMacOS`, and the
/// iPad shots are rendered on a macOS host — so reusing it directly would
/// picture a macOS-only control on an iPad screenshot. This mirrors the branch a
/// real iPad takes: the same app bar, scroll view, padding and [LegalSection],
/// with no port field.
class IpadSettingsView extends StatelessWidget {
  const IpadSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: HorizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [LegalSection()],
          ),
        ),
      ),
    );
  }
}
