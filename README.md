# News Reader

A clean-architecture Flutter news reader.

## Features

- Mock login via `dummyjson.com/auth/login` (session persists with Hive)
- News feed from `newsdata.io` — infinite scroll + pull-to-refresh
- Search by title / keyword (debounced)
- Bookmarks that persist and work offline
- Light / Dark / System theme (persisted)
- Handles offline, timeout, and empty results gracefully


**Demo credentials:** `emilys` / `emilyspass`

## Folder Structure

```
lib/
├── main.dart
├── core/               # constants, validators, exceptions
├── domain/             # entities + abstract repositories
├── data/               # models, services (API/Hive), repository impls
└── presentation/       # providers, screens, widgets, theme, routes
```

## Architecture

Simple clean architecture with three layers:

- **`domain/`** — pure Dart. `Article` and `User` entities + repository interfaces. Nothing else.
- **`data/`** — talks to Dio and Hive. `*Model` classes handle JSON; `*RepositoryImpl` classes implement the domain interfaces.
- **`presentation/`** — Riverpod providers + screens + widgets. Providers expose state; screens subscribe and render.

Flow: **Screen → Provider → Repository (domain interface) → RepositoryImpl → ApiService / StorageService**

## Packages

| Package | Purpose |
| --- | --- |
| `flutter_riverpod` | State management |
| `go_router` | Navigation |
| `dio` | HTTP client |
| `hive_flutter` | Local persistence (bookmarks, session, cache, theme) |
| `cached_network_image` | Image caching |
| `intl` | Date formatting |

## Assumptions

1. Auth is mocked with dummyjson (which uses usernames, so the email field accepts either).
2. The news API key is provided at build time via `--dart-define`.
3. Bookmarks are local-only — no cloud sync.
4. When the API is unreachable, the last successful first-page response is served from cache with a banner.

## Testing

```bash
flutter test
```

Covers form validation.