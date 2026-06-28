import 'package:bloc_test/bloc_test.dart';
import 'package:file_sharing/features/client/presentation/bloc/browser_bloc/browser_bloc.dart';
import 'package:file_sharing/features/client/presentation/bloc/discovery_bloc/discovery_bloc.dart';
import 'package:file_sharing/features/client/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:file_sharing/features/server/presentation/bloc/server_bloc/server_bloc.dart';

/// Fake blocs for the screenshot harness.
///
/// Each is a [MockBloc] seeded via [whenListen] to emit a single fixed state and
/// ignore every dispatched event, so the real pages render the desired marketing
/// state without any networking, discovery or Hive access. `add(...)` and
/// `close()` are safe no-ops on a mock.

class FakeServerBloc extends MockBloc<ServerEvent, ServerState>
    implements ServerBloc {}

class FakeDiscoveryBloc extends MockBloc<DiscoveryEvent, DiscoveryState>
    implements DiscoveryBloc {}

class FakeBrowserBloc extends MockBloc<BrowserEvent, BrowserState>
    implements BrowserBloc {}

class FakeHistoryBloc extends MockBloc<HistoryEvent, HistoryState>
    implements HistoryBloc {}

FakeServerBloc seededServerBloc(ServerState state) {
  final bloc = FakeServerBloc();
  whenListen(bloc, Stream<ServerState>.value(state), initialState: state);
  return bloc;
}

FakeDiscoveryBloc seededDiscoveryBloc(DiscoveryState state) {
  final bloc = FakeDiscoveryBloc();
  whenListen(bloc, Stream<DiscoveryState>.value(state), initialState: state);
  return bloc;
}

FakeBrowserBloc seededBrowserBloc(BrowserState state) {
  final bloc = FakeBrowserBloc();
  whenListen(bloc, Stream<BrowserState>.value(state), initialState: state);
  return bloc;
}

FakeHistoryBloc seededHistoryBloc(HistoryState state) {
  final bloc = FakeHistoryBloc();
  whenListen(bloc, Stream<HistoryState>.value(state), initialState: state);
  return bloc;
}
