import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:file_sharing/core/services/discovery_service.dart';
import 'package:file_sharing/features/client/domain/use_cases/discover_servers_use_case.dart';
import 'package:file_sharing/features/client/domain/use_cases/ping_server_use_case.dart';
import 'package:file_sharing/features/client/presentation/bloc/discovery_bloc/discovery_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDiscoverServers extends Mock implements DiscoverServersUseCase {}

class _MockPingServer extends Mock implements PingServerUseCase {}

void main() {
  const server = DiscoveredServer(
    name: 'alexs-MacBook-Air.local File Sharing',
    host: 'alexs-MacBook-Air.local.',
    port: 8080,
  );

  late _MockDiscoverServers discover;
  late _MockPingServer ping;
  late StreamController<List<DiscoveredServer>> servers;
  late int pingCount;

  setUp(() {
    discover = _MockDiscoverServers();
    ping = _MockPingServer();
    servers = StreamController<List<DiscoveredServer>>.broadcast();

    when(() => discover.servers).thenAnswer((_) => servers.stream);
    when(discover.start).thenAnswer((_) async {});
    when(discover.stop).thenAnswer((_) async {});
    pingCount = 0;
    when(() => ping(host: any(named: 'host'), port: any(named: 'port')))
        .thenAnswer((_) async {
      pingCount++;
      return const Left(null);
    });
  });

  tearDown(() => servers.close());

  DiscoveryBloc build() => DiscoveryBloc(
        discoverServersUseCase: discover,
        pingServerUseCase: ping,
      );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'a removed server is not re-added when mDNS advertises it again',
    build: build,
    act: (bloc) async {
      bloc.add(const DiscoveryEvent.start());
      // Let _start attach its stream listener before mDNS emits, or the
      // emission is dropped and no probe ever runs.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      servers.add([server]);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bloc.add(const DiscoveryEvent.removeServer(server));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // mDNS still has the service cached and re-emits it. The row must NOT
      // come back: the user dismissed it.
      servers.add([server]);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (bloc) {
      expect(
        bloc.state.allServers,
        isEmpty,
        reason: 'a dismissed server must stay dismissed',
      );
      expect(bloc.state.dismissedIds, contains(server.id));
    },
  );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'an explicit rescan clears dismissals and shows the server again',
    build: build,
    act: (bloc) async {
      bloc.add(const DiscoveryEvent.start());
      // Let _start attach its stream listener before mDNS emits, or the
      // emission is dropped and no probe ever runs.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      servers.add([server]);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bloc.add(const DiscoveryEvent.removeServer(server));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      bloc.add(const DiscoveryEvent.rescan());
      servers.add([server]);
      await Future<void>.delayed(const Duration(milliseconds: 50));
    },
    verify: (bloc) {
      expect(bloc.state.dismissedIds, isEmpty);
      expect(bloc.state.allServers, [server]);
    },
  );

  blocTest<DiscoveryBloc, DiscoveryState>(
    'a removed server stops being probed',
    build: build,
    act: (bloc) async {
      bloc.add(const DiscoveryEvent.start());
      // Let _start attach its stream listener before mDNS emits, or the
      // emission is dropped and no probe ever runs.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      servers.add([server]);
      // Long enough for the discovery emission AND its follow-up probe to
      // complete: the probe is dispatched as a separate event.
      await Future<void>.delayed(const Duration(milliseconds: 300));

      bloc.add(const DiscoveryEvent.removeServer(server));
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Count via the stub itself: verify() consumes recorded calls, so it
      // cannot be used to compare before/after within one test.
      final before = pingCount;
      expect(before, greaterThan(0), reason: 'the server was probed while listed');

      // Any further poll must not reach the dismissed server.
      bloc.add(const DiscoveryEvent.refreshReachability());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(
        pingCount,
        before,
        reason: 'a dismissed server must never be pinged again',
      );
    },
    verify: (bloc) {
      expect(bloc.state.reachability, isEmpty);
    },
  );
}
