# Navigation Rules

These rules are mandatory for all navigation and route-scoped state in this project.

## 1. Always navigate with go_router — never the native Navigator

The app uses `go_router` as its single routing system. Pushing routes through the
native `Navigator` creates a parallel navigation stack that go_router does not
know about, breaking deep links, back handling, and redirects.

**Forbidden**
- `Navigator.push(...)`, `Navigator.of(context).push(...)`
- `MaterialPageRoute(...)`, `CupertinoPageRoute(...)` for screen navigation
- Any custom `PageRoute` pushed onto the native stack

**Required**
- `context.push(AppRoutes.x)` / `context.go(AppRoutes.x)` / `context.pop()`
- All routes declared centrally in
  `lib/core/routes/init_router/init_router.dart`, addressed via the
  `AppRoutes` constants.

```dart
// ❌ WRONG
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => const TransferHistoryPage()),
);

// ✅ RIGHT
context.push(AppRoutes.clientBrowserHistory);
```

> `showDialog` / `showModalBottomSheet` for actual dialogs and sheets are fine —
> they are not route navigation.

## 2. Never pass a BLoC/Cubit (or any live object) through `extra`

`GoRouterState.extra` is for plain, route-scoped **data** only. Passing a
`Bloc`/`Cubit` (or other live, non-serializable objects) through it couples the
caller to the callee's internals, breaks on refresh/redirect/deep-link (where
`extra` is null), and leaks lifecycle ownership across the route boundary.

**To share a bloc across routes, do one of:**
1. **Provide it above the route subtree** with a go_router `ShellRoute` +
   `BlocProvider`, so every screen under that shell reads the same instance from
   `context`.
2. **Resolve it from `getIt`** when it is a singleton-scoped dependency.

```dart
// ❌ WRONG — bloc through extra
context.push(AppRoutes.clientBrowserHistory, extra: _bloc);

// ✅ RIGHT — ShellRoute provides HistoryBloc; the screen reads it from context
ShellRoute(
  builder: (context, state, child) => BlocProvider<HistoryBloc>(
    create: (_) => getIt<HistoryBloc>()..add(const HistoryEvent.started()),
    child: child,
  ),
  routes: [ /* browser, browser/history, … */ ],
);
```

`extra` may still carry **plain data** (e.g. a `DiscoveredServer` value object),
but never a bloc, controller, stream, or other live object.

## 3. Centralized routes

- One source of truth: `init_router.dart` + `AppRoutes` string constants.
- No inline/ad-hoc route strings at call sites — reference `AppRoutes.*`.
