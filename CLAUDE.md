# File Sharing — Project Guide

Local Wi‑Fi file transfer between a **Mac (server)** and an **iPhone (client)** from a
single Flutter codebase. Communication happens entirely over the LAN using
`dart:io` HTTP + WebSockets and Bonjour/mDNS discovery — **no cloud, no Internet,
no FTP, no accounts**.

The role is chosen automatically by platform in
`lib/core/routes/init_router/init_router.dart`:
`Platform.isMacOS` → **server UI**; every other platform (iOS) → **client UI**.

---

## Architecture

Clean Architecture. Shared infrastructure in `lib/core/`; each feature under
`lib/features/<feature>/` is split into `data / domain / presentation / di`.

**Dependency rule:** `presentation → domain ← data`. The domain layer (models,
repository *interfaces*, use cases, failures) depends on nothing concrete;
`data` implements the interfaces; `presentation` (BLoC + widgets) depends on
domain only. All networking and storage is hidden behind repository interfaces,
so transports are replaceable.

```
lib/
├── main.dart                         # init Hive → DI → Bloc.observer → runApp; desktop min window size
├── core/
│   ├── bloc/app_observer.dart        # logs bloc transitions/errors
│   ├── di/injection.dart             # get_it: core services + initServerFeature/initClientFeature
│   ├── failures/failure.dart         # base Failure
│   ├── hive/
│   │   ├── hive_initializer.dart     # opens boxes, registers them in get_it (runs before DI)
│   │   └── hive_adapters.dart        # @GenerateAdapters([...]) — central adapter registration
│   ├── models/file_entry/            # FileEntry — wire model shared by server & client
│   ├── resources/                    # app_colors, app_text_style, app_theme (enum-based)
│   ├── routes/init_router/           # GoRouter + AppRoutes constants
│   ├── services/                     # discovery, network_info, ui_message, file_share
│   ├── utils/extensions/             # go_router_x (goBack), int_size_x (readableSize)
│   └── widgets/                      # CustomAppBar, SectionCard, PrimaryBtn, ProgressBar, HorizontalPadding
└── features/
    ├── server/   (macOS)             # HttpServer, shared folder, settings/port, activity log, devices
    ├── client/   (iOS)               # discovery, file browser, transfers, live watch, history
    ├── settings/                     # port field (server) + legal links; shared settings screen
    └── legal/                        # privacy policy & terms (markdown from assets/data/)
```

Key files to know:
- Server: `features/server/data/repositories/http_server_repository.dart`,
  `presentation/bloc/server_bloc/`, use cases under `domain/use_cases/`,
  `di/server_injection.dart`.
- Client: `features/client/data/repositories/http_client_repository.dart`,
  blocs `discovery_bloc/`, `browser_bloc/`, `history_bloc/`, use cases under
  `domain/use_cases/`, `di/client_injection.dart`.

---

## State management & DI

- **BLoC** (`bloc` / `flutter_bloc`). Events and states are **freezed** sealed
  classes. Each state carries a `Status` enum (`initial/loading/loaded/failure`,
  `stopped/starting/running/failure`, …) plus a state **extension** exposing
  intent getters (`isLoading`, `isRunning`, `isFailure`, `hasSharedFolder`, …).
  UI checks state via these getters, never `status == …` inline.
- Long‑lived streams are consumed with `emit.forEach`. Repositories are reached
  **only through use cases**, never directly from a bloc.
- **DI:** `get_it` (`core/di/injection.dart`). Each feature exposes
  `initServerFeature(getIt)` / `initClientFeature(getIt)`. Repositories &
  long‑lived services → `registerLazySingleton`; use cases & blocs →
  `registerFactory`. No `getIt` alias.
- **Errors:** use cases return `dartz` `Either<Success, Failure>`
  (Left = success, Right = `Failure`). Blocs `fold` the result into state.

---

## Networking

Server uses `dart:io HttpServer`; client uses `dio`. **All file I/O is
streamed** — never buffer a whole file (downloads pipe `File.openRead()`;
uploads stream the multipart body to `File.openWrite()` via
`data/parsing/multipart_parser.dart`). Large files work.

### HTTP API (server: `http_server_repository.dart`)

| Method | Path | Notes |
|--------|------|-------|
| `GET` | `/ping` | `{status, name}` — reachability + host name |
| `GET` | `/files?path=<rel>` | JSON `{files:[{name,isDirectory,size}]}` |
| `GET` | `/download?path=<rel>` | streamed file; RFC 5987 `Content-Disposition` for non‑ASCII names |
| `POST` | `/upload` | `multipart/form-data`, streamed to disk |
| `DELETE` | `/delete?path=<rel>` | files only (directories rejected) |
| `GET` | `/events` | WebSocket; client sends `{type:watch,path}`, server pushes `{type:files,path,files:[…]}` on every change |

**Convention:** the file path travels as a **query parameter** (`?path=`), not
in the URL path. dio/`dart:io` encode it once correctly; the server reads
`request.uri.queryParameters['path']`. (Hand‑encoding it into the path segment
double‑encodes non‑ASCII names — do not reintroduce that.)

Client methods mirror the API in `i_client_repository.dart`: `ping`,
`listFiles`, `downloadFile` (→ `Stream<TransferProgress>`), `uploadFile`
(→ progress stream), `deleteFile`, `watchFiles` (→ `FolderWatch`).

### Discovery
`core/services/discovery_service.dart` wraps `nsd` (Bonjour/mDNS). The server
advertises `_filesharing._tcp`; the client browses it and also supports a
**manual IP:port fallback** (`manual_add_dialog.dart`). The watched/advertised
service type must match `NSBonjourServices` in iOS `Info.plist`.

### Live folder sync
While browsing, the client holds a WebSocket to `/events`. The server runs a
debounced `Directory.watch` and re‑pushes the listing on any change (upload,
delete, Finder edit, folder re‑selection), so the iPhone list updates with no
manual refresh.

---

## Persistence (Hive)

`hive_ce` / `hive_ce_flutter`. Adapters are declared centrally via
`@GenerateAdapters` in `core/hive/hive_adapters.dart` and generated into
`hive_adapters.g.dart` + `hive_registrar.g.dart`. Boxes are opened and
registered in get_it by `hive_initializer.dart`, which runs **before**
`initDependencies()` in `main.dart`.

| Box | Model | Feature |
|-----|-------|---------|
| `transfer_history` | `TransferRecord` | client — transfer history (survives restarts) |
| `shared_folder` | `SharedFolder` | server — last selected folder, restored on launch |
| `server_settings` | `ServerSettings` | server — sharing port |

Box‑backed repositories take the opened `Box<T>` via constructor injection and
implement a domain interface (e.g. `HiveHistoryRepository : IHistoryRepository`,
`HiveSharedFolderRepository`, `HiveServerSettingsRepository`).

Restored state is validated: if a saved shared folder no longer exists, the UI
flags it as missing and **Start Server** is blocked with an error until a valid
folder is chosen.

---

## Navigation rules (mandatory)

Enforced; see `.claude/rules/navigation_rules.md`.

1. **Always go_router** — `context.push/go/pop`, routes centralized in
   `init_router.dart` via `AppRoutes` constants. **Never** `Navigator.push`,
   `Navigator.of(context).push`, or `MaterialPageRoute`/`CupertinoPageRoute` for
   route navigation. (`showDialog`/`showModalBottomSheet` for real dialogs/sheets
   is fine — that is not route navigation.)
2. **Never pass a BLoC (or any live object) through `extra`.** Share a bloc by
   providing it above the route subtree with a `ShellRoute` + `BlocProvider`, or
   resolve it from `getIt`. `extra` is for plain data only (e.g. a
   `DiscoveredServer` value object).

Routing shape today: a `ShellRoute` scopes one `ServerBloc` to the desktop
server + settings pages; the iOS client uses a `StatefulShellRoute.indexedStack`
(bottom nav: Devices / Settings), and the file browser + history are pushed on
the root navigator under a `ShellRoute` that provides `HistoryBloc`.

---

## UI conventions

- **One public widget per file.** No private `_buildX()` methods — extract a
  private sub‑widget *class* instead (e.g. `_FileTile`, `_LogTile`, `_InfoRow`).
- **Colors and text only via the enums** `AppColors.<name>.value` /
  `AppTextStyle.<name>.value`. No raw `Color`/`TextStyle` literals in widgets.
- Reuse core widgets: `CustomAppBar`, `SectionCard`, `PrimaryBtn`
  (`AutoSizeText` inside), `HorizontalPadding`, `ProgressBar`.
- Responsive layout via `responsive_framework` + `LayoutBuilder`
  (e.g. the server screen reflows between one and two columns).
- User feedback via `UiMessageService` (a global `ScaffoldMessenger` SnackBar —
  cross‑platform, works on macOS + iOS) fired from `BlocListener`s on status
  transitions. `fluttertoast` is **not** used (no macOS support).
- Downloaded files are offered to the user via the native share / "Save to
  Files" sheet (`file_share_service.dart`, `share_plus`), since the app's own
  storage is not browsable in the iOS Files app.
- Markdown (legal/info) rendered with `gpt_markdown` from `assets/data/`.

---

## Platform configuration

- **macOS (server):** entitlements grant `network.server`, `network.client`,
  and `files.user-selected.read-write`. `window_manager` enforces a minimum
  window size (420×600) so the responsive layout never overflows.
- **iOS (client):** `Info.plist` declares `NSLocalNetworkUsageDescription` and
  `NSBonjourServices` = `_filesharing._tcp` (required for mDNS + local network
  on iOS 14+).

---

## Build, codegen & test

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json + hive adapters
flutter analyze                                             # must be clean
flutter test                                               # all green
flutter run -d macos                                       # server
flutter run -d <ios-device>                                # client (real device for mDNS)
```

Regenerate code after touching any freezed model/bloc state, a `*.fromJson`
model, or the `@GenerateAdapters` list.

**Tests** (`test/`):
- `http_transfer_test.dart` — in‑process integration: boots the real
  `HttpServerRepository` on a loopback port and drives the real
  `HttpClientRepository`. `flutter_test` stubs HTTP, so the test opts back into a
  real socket via the `_withRealHttp` `HttpOverrides` zone. Covers ping, list,
  streamed download, multipart upload, delete (incl. directory rejection), and
  non‑ASCII filenames, plus the WebSocket live‑push.
- `hive_history_repository_test.dart`, `hive_shared_folder_repository_test.dart`
  — Hive persistence (save/read, overwrite, survive box reopen, clear) using a
  temp Hive dir + `Hive.registerAdapters()`.

---

## Coding conventions

- Null safety; SOLID; small, reusable widgets; document public APIs.
- Lints: trailing commas, single quotes, `.0` on doubles.
- freezed models use the entity name with **no `Model` suffix**.
- Keep business logic out of widgets; widgets read state, dispatch events.

---

## Future perspectives

The layering was chosen so these slot in without restructuring.

**Security (current known limitations — the app is LAN‑trusted only today):**
- No authentication and no transport encryption; the server binds to
  `0.0.0.0`. Add a **pairing PIN / token** (a request header checked in
  `http_server_repository` + sent by `http_client_repository`), **TLS**
  (`https`/`wss`), bind to the chosen LAN interface, and **upload size caps /
  rate limiting**. These land in the data layer + a small settings field; UI and
  blocs are unaffected.

**Transfers:** resume / chunked transfers, parallel & multi‑file, background
transfers, integrity hashes — extend the transfer use cases + `TransferProgress`.

**UX:** file previews / thumbnails, search / sort / filter, multi‑select,
folder upload (zip) — new widgets + browser bloc events; the `/files` contract
already carries enough metadata to start.

**Platform reach:** Android / Windows / Linux roles (most code is
platform‑neutral; only entitlements/Info.plist and the role switch are
platform‑specific), and a manual role picker.

**Data & polish:** richer history (sizes, durations, throughput) on the existing
Hive `TransferRecord`, more server settings, and full i18n via
`flutter_localizations`.
