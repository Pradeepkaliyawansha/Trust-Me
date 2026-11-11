# Trust Me (Flutter) – Phase 1: Project Foundation

*Build Trust. Manage Credit. Pay with Confidence.*

## Setup
```bash
flutter create . --org lk.trustme --project-name trust_me --platforms android,ios   # adds android/ and ios/
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json
flutter gen-l10n                                           # localization
flutter run --dart-define-from-file=config/dev.json
```
Android emulator reaches the host API at `10.0.2.2`; for a physical device set
`API_BASE_URL` to your machine's LAN IP in `config/dev.json`.

## Tests
```bash
flutter test
```

## Phase 1 status
Done: structure, Material 3 theme (light/dark), Riverpod, GoRouter with
role-aware redirects, Dio client with refresh-token rotation, secure token
storage, error model, connectivity service, en/si/ta localization, reusable
widgets, login + role home shell, tests, Prisma schema + ER diagram.

Remaining (next phases): OTP + registration (P2), Drift offline + credit/loans
(P3), agreements/signatures (P4), FCM (P5), dashboards (P6), admin (P7),
release (P8), Rent a Car (P9). Backend NestJS modules start in P2.
