# JustOrder — Full Architecture Migration Plan

A complete audit + migration roadmap to transform the existing codebase into a production-grade Flutter application following MVVM, Cubit, GoRouter, and full localization as defined in `request.md`.

---

## 📋 Codebase Audit Report

### Current Project Snapshot

| Item | Detail |
|---|---|
| **App** | JustOrder — Food ordering for Egypt |
| **Flutter SDK** | ≥ 3.11.5 |
| **Version** | 1.1.2+1 |
| **Backend** | Firebase (Firestore, Messaging) |
| **State mgmt** | Mixed: `flutter_bloc` (Cubit) + `provider` (`ChangeNotifier`) |
| **Navigation** | `onGenerateRoute` + `MaterialPageRoute` (legacy) |
| **Localization** | Dual system: `easy_localization` + `flutter_localizations` / ARB |
| **DI** | None — repositories instantiated inline everywhere |

---

### Architecture Analysis

**Current Architecture:** Loose MVC / partial Cubit, no consistent layering

| Metric | Score | Notes |
|---|---|---|
| **Scalability** | 4/10 | No feature-based folder isolation |
| **Maintainability** | 4/10 | Mixed concerns throughout |
| **Testability** | 2/10 | No DI, concrete repo deps, no abstractions |
| **Consistency** | 3/10 | Two state-management systems coexisting |

**Problems identified:**

- `CartProvider` and `OrderProvider` use `ChangeNotifier`/`provider` — conflicts with Cubit-first approach
- `LoginCubit` owns UI state (`suffixIcon`, `isPassword`) mixed with business state — SRP violation
- Repositories (`CategoryRepository`, `LoginRepository`) are concrete classes instantiated directly in Cubits with `new` — no abstractions, no interfaces
- No DI system — `LoginRepository()` constructed inline in `justorder.dart`'s `BlocProvider`
- `global prefs` declared as `late final SharedPreferences prefs` in `main.dart` — global mutable state
- `DeepLinkListener` wraps the app **twice** (both in `_buildApp()` and inside `_AppView.build()`)
- Two localization systems: `easy_localization` is initialized and applied but never used; actual rendering uses ARB-generated `AppLocalizations`. Both run simultaneously = wasted startup time + confusion.
- Navigation is manual `onGenerateRoute` with untyped `Map<String, dynamic>` argument casting — brittle, crash-prone

---

### Performance Issues

| Issue | Location | Impact |
|---|---|---|
| `common_order_state_widget.dart` is **1,439 lines** — a massive god widget function | `lib/shared/widget/` | FPS, rebuild cost |
| `my_cart_screen.dart` is **34,880 bytes** — monolithic screen widget | `lib/screens/cart/` | Long build method |
| `pay_method_screen.dart` is **28,793 bytes** — same pattern | `lib/screens/payment/` | Long build method |
| `order_summary_screen.dart` is **31,698 bytes** — same pattern | `lib/screens/order/` | Long build method |
| `enter_card_data_screen.dart` is **20,454 bytes** — same pattern | `lib/screens/payment/` | Long build method |
| `login_screen.dart` is **21,622 bytes** — monolithic | `lib/screens/login/` | Long build method |
| `BlocBuilder<LanguageCubit>` wraps entire `MaterialApp` | `justorder.dart` | Full widget tree rebuild on locale change |
| `BlocBuilder<ThemeCubit>` wraps entire `MaterialApp` | `justorder.dart` | Full widget tree rebuild on theme change |
| No `const` constructors on shared widgets | Various | Unnecessary widget allocations |
| `CartProvider`/`OrderProvider` are app-wide — no lazy loading | `main.dart` | Startup overhead |

---

### Clean Code Issues

| Issue | Location |
|---|---|
| `common_order_state_widget.dart` — 1,439-line top-level function | `lib/shared/widget/` |
| Mixed `provider` + `flutter_bloc` in same app | Multiple files |
| `prefs` declared as a global variable | `lib/main.dart` |
| Repositories have no interface/abstract class | `lib/repository/` |
| `category_repository.dart` creates new `FirebaseFirestore.instance` inside methods | `lib/repository/` |
| `login_cubit.dart` contains UI logic (icon state) | `lib/blocs/login_cubit/` |
| `lib/Qr.png` — an asset file inside `lib/` | `lib/` root |
| `lib/Utils/` — uppercase folder name (inconsistent) | `lib/` root |
| Two localization systems initialized simultaneously | `main.dart`, `justorder.dart` |
| `DeepLinkListener` instantiated twice | `main.dart`, `justorder.dart` |
| `AppRouter` — untyped `Map<String,dynamic>` argument passing | `lib/shared/routing/` |
| No `analysis_options.yaml` custom lints beyond defaults | root |
| No `test/` coverage | `test/` |
| `generated/` folder under `lib/` — unclear ownership | `lib/generated/` |

---

### Dependency Issues

| Package | Issue |
|---|---|
| `easy_localization` | Initialized but never actually used for rendering; ARB used instead. Dead dependency |
| `provider` | Only used for `CartProvider` + `OrderProvider`. Can be migrated to Cubit |
| `http` | Both `http` and `dio` present — `http` appears unused once `dio` handles API calls |
| `freezed` / `build_runner` | Only used in 2 cubits so far — should be extended consistently OR removed |

---

## User Review Required

> [!IMPORTANT]
> **Two localization systems** — The app currently initializes `easy_localization` **AND** the generated ARB-based `AppLocalizations`. The ARB system is the correct one (already works). The plan removes `easy_localization` entirely and standardizes on ARB. Confirm this is acceptable.

> [!IMPORTANT]
> **`provider` removal** — `CartProvider` and `OrderProvider` currently use `ChangeNotifier`. The plan migrates both to dedicated `CartCubit` and `OrderCubit`. This is a behavior-compatible change but touches cart/order flows. Confirm.

> [!WARNING]
> **GoRouter migration** — Replacing `onGenerateRoute` with GoRouter changes deep-link handling. The existing `DeepLinkListener` (using `app_links`) will need to be wired into GoRouter's `redirect` / `refresh`. Confirm GoRouter adoption.

> [!NOTE]
> **Incremental approach** — Per `request.md` Working Rules, tasks are done one at a time, each must compile and not break existing functionality. Each task will be submitted for confirmation before the next begins (unless you instruct "proceed automatically").

---

## Open Questions

> [!IMPORTANT]
> 1. Should `get_it` be added as the DI container, or do you prefer a simpler manual DI approach (service locator pattern via a `DI` class)?
> 2. Should `freezed` be applied uniformly to ALL Cubit states going forward, or only where `@freezed` provides clear value (union states)?
> 3. Are there any screens that should NOT be migrated yet (e.g., QR flow, payment gateway screen which uses `flutter_inappwebview`)?

---

## Proposed Migration Tasks

Tasks are ordered by dependency. Each is atomic, compilable, and reversible.

---

### Phase 0 — Foundation (No behavior changes)

#### T001 — Remove `easy_localization`, clean `main.dart`
- Remove `easy_localization` from `pubspec.yaml` and from `main.dart`
- Remove `EasyLocalization` wrapper from `_buildApp()`
- Remove double `DeepLinkListener` wrapping (keep one, inside `_AppView`)
- Move global `prefs` to a `StorageService` class (injectable)

#### T002 — Rename `lib/Utils/` → `lib/utils/` + move `lib/Qr.png` to `assets/images/`
- Lowercase folder rename
- Remove stray PNG from `lib/`

#### T003 — Create `lib/core/` folder structure
```
lib/core/
  config/
  constants/
  errors/
  extensions/
  helpers/
  services/
  network/
  storage/
  theme/
  router/
  di/
  utils/
```
- Move `shared/constant/constants.dart` → `core/constants/`
- Move `shared/style/colors.dart` + `themes.dart` → `core/theme/`
- Move `shared/bloc_observer/` → `core/helpers/`
- Move `Utils/util.dart` → `core/utils/`
- Move `network/dio_helper.dart` → `core/network/`
- Move `services/` → `core/services/`

#### T004 — Dependency Injection setup (`get_it`)
- Add `get_it` to `pubspec.yaml`
- Create `lib/core/di/service_locator.dart`
- Register all repositories, services, cubits (feature-level)
- Replace all inline `LoginRepository()` / `CartProvider()` constructions

---

### Phase 1 — Core Infrastructure

#### T005 — Abstract Repository Interfaces
- Create abstract interfaces: `ILoginRepository`, `ICategoryRepository`, `IItemRepository`, `IOrderRepository`, `IPaymentRepository`, `IUserRepository`
- Place in `features/<feature>/domain/repositories/`
- Existing concrete classes implement the interface
- Update Cubits to depend on interfaces (not concretes)

#### T006 — Network Layer Refactor
- Move `dio_helper.dart` → `core/network/`
- Create `NetworkClient` class (singleton via DI) wrapping Dio
- Add `NetworkInfo` abstraction using `internet_connection_checker`
- Add proper error handling with `Failure` types in `core/errors/`

#### T007 — Storage Service
- Create `StorageService` wrapping `SharedPreferences`
- Move all `SharedPreferences.getInstance()` calls to this service
- Register in DI

#### T008 — Error Handling
- Create `core/errors/failures.dart` with `Failure` sealed class hierarchy:
  - `NetworkFailure`, `ServerFailure`, `CacheFailure`, `AuthFailure`, `UnknownFailure`
- Update repositories to return `Either<Failure, T>` (using `dartz`)

---

### Phase 2 — State Management Cleanup

#### T009 — Migrate `CartProvider` → `CartCubit`
- Create `features/cart/presentation/cubit/cart_cubit.dart` + `cart_state.dart`
- Replicate all `CartProvider` methods as Cubit events
- Remove `CartProvider` + `provider` ChangeNotifier usage for cart
- Update all cart-consuming screens to use `BlocBuilder<CartCubit, CartState>`

#### T010 — Migrate `OrderProvider` → `OrderCubit`
- Create `features/order/presentation/cubit/order_cubit.dart` + `order_state.dart`
- Replicate all `OrderProvider` methods
- Remove `OrderProvider`
- Update all order-consuming screens

#### T011 — Separate UI State from Business State in `LoginCubit`
- Extract `suffixIcon`/`isPassword` into a `LoginUiCubit` (or use `ValueNotifier` locally)
- Keep `LoginCubit` purely for auth state: `LoginInitial`, `LoginLoading`, `LoginSuccess`, `LoginFailure`

#### T012 — Theme & Language Cubit cleanup
- Wrap `MaterialApp` construction so `BlocBuilder<ThemeCubit>` + `BlocBuilder<LanguageCubit>` no longer rebuild entire tree
- Use `BlocSelector` where only specific fields matter

---

### Phase 3 — Navigation (GoRouter)

#### T013 — Install & configure GoRouter
- Add `go_router` to `pubspec.yaml`
- Create `lib/core/router/app_router.dart` (GoRouter instance)
- Define route constants in `lib/core/router/route_names.dart`

#### T014 — Migrate all routes to GoRouter
- Convert every `case` in the old `AppRouter` to a `GoRoute`
- Use `ShellRoute` for the main layout (bottom nav)
- Use typed route parameters via `GoRouterState.extra` with null-safe casting helpers
- Add `redirect` guard for authenticated routes (check saved user in `StorageService`)
- Wire `DeepLinkListener` → GoRouter `router.go()`
- Delete old `lib/shared/routing/app_router.dart`

#### T015 — Authentication Guard
- Implement `GoRouter.redirect` callback
- Unauthenticated users → `/login`
- Already-authenticated users going to login → `/home`

---

### Phase 4 — Feature Migration (MVVM per feature)

Each feature follows the pattern:
```
features/<feature>/
  data/
    datasources/<feature>_remote_datasource.dart
    models/<feature>_model.dart      (keep existing, move here)
    repositories/<feature>_repository_impl.dart
  domain/
    entities/<feature>_entity.dart   (if useful)
    repositories/i_<feature>_repository.dart
    usecases/<feature>_usecase.dart  (if beneficial)
  presentation/
    view/<feature>_screen.dart
    viewmodel/<feature>_view_model.dart  (optional glue)
    cubit/<feature>_cubit.dart
    cubit/<feature>_state.dart
    widgets/                         (extracted sub-widgets)
```

#### T016 — Auth Feature Migration
- Move `LoginRepository` → `features/auth/data/repositories/`
- Create `AuthRemoteDataSource` (Firestore calls)
- Split screen widgets out of `login_screen.dart` (21 KB)
- Create `SignUpCubit` in correct feature folder

#### T017 — Home Feature Migration
- Move `CategoryRepository`, `CategoryCubit` → `features/home/`
- Move `home_screen.dart` widgets into `features/home/presentation/widgets/`
- Break `home_screen.dart` into sub-widgets

#### T018 — Restaurant & Menu Feature Migration
- Move `RestaurantModel`, `ItemModel` → `features/restaurant/data/models/`
- Move `item_repository.dart` → `features/restaurant/data/repositories/`
- Split `restaurant_screen.dart` and `meal_details_screen.dart`

#### T019 — Cart Feature Migration (after T009)
- Relocate `CartCubit` to `features/cart/presentation/cubit/`
- Move `cart_item_model.dart` → `features/cart/data/models/`
- Break `my_cart_screen.dart` (34 KB) into sub-widgets

#### T020 — Order Feature Migration (after T010)
- Relocate `OrderCubit` to `features/order/presentation/cubit/`
- Move `order_model.dart` → `features/order/data/models/`
- **Break up `common_order_state_widget.dart` (1,439 lines)** into individual order-state widgets under `features/order/presentation/widgets/`

#### T021 — Payment Feature Migration
- Move `PaymentRepository` → `features/payment/data/repositories/`
- Move payment models → `features/payment/data/models/`
- Break `pay_method_screen.dart` (28 KB) and `enter_card_data_screen.dart` (20 KB)

#### T022 — QR Feature Migration
- Move `select_your_place_screen.dart` → `features/qr/presentation/view/`
- Move QR scan logic into `QrCubit`

#### T023 — Notifications & Deep Links Migration
- Move `notification_service.dart` → `core/services/`
- Wire FCM into GoRouter properly
- Wire `app_links` into GoRouter `refresh` stream

#### T024 — Profile / Account Feature Migration
- Move profile/change-password screens → `features/profile/`
- Extract profile cubit from `LoginCubit`

---

### Phase 5 — Localization Hardening

#### T025 — Audit all hardcoded strings
- `grep` for all string literals in `lib/` excluding ARB files
- Add missing keys to `app_en.arb` and `app_ar.arb`
- Replace hardcoded strings with `AppLocalizations.of(context)!.key`

#### T026 — RTL Layout validation
- Run app in Arabic locale
- Fix any LTR-hardcoded `EdgeInsets`, `Alignment`, `CrossAxisAlignment` issues

---

### Phase 6 — Performance & Memory

#### T027 — Add `const` constructors across shared widgets
- Audit `lib/shared/widget/` and all feature widgets
- Add `const` wherever possible

#### T028 — Replace `ListView` with `ListView.builder` where applicable
- Audit all lists rendering full item arrays
- Switch to builder pattern with `itemCount`

#### T029 — Add `RepaintBoundary` to heavy animated widgets
- Identify `Lottie` animations and carousel sliders
- Wrap with `RepaintBoundary`

#### T030 — Dispose audit
- Search for all `TextEditingController`, `AnimationController`, `FocusNode`
- Verify `dispose()` is called in `State.dispose()`
- Fix any missing disposals

#### T031 — Image optimization
- Verify `cached_network_image` is used everywhere for remote images
- Remove any `Image.network` usages
- Add `memCacheWidth`/`memCacheHeight` constraints where large images are displayed small

---

### Phase 7 — Code Quality & Cleanup

#### T032 — Remove dead code
- Remove `easy_localization` package completely
- Remove `http` package if confirmed unused
- Remove `provider` package after T009/T010 complete
- Delete any unused imports across the project

#### T033 — Update `analysis_options.yaml`
- Enable stricter lints: `avoid_dynamic_calls`, `prefer_const_constructors`, `always_use_package_imports`, etc.
- Fix all reported lint issues

#### T034 — Write unit tests for core layers
- Test each `UseCase` / repository implementation with mock datasource
- Test each Cubit with `bloc_test` package

---

### Phase 8 — Finalization

#### T035 — Update `memory.md`
- Create/update `memory.md` at project root
- Reflects all completed tasks, current state, decisions made

#### T036 — Final verification
- `flutter analyze` — zero significant issues
- `flutter build apk --release` — clean build
- Manual smoke test of all critical flows: login, browse, cart, order, payment

---

## Target Folder Structure (Final)

```
lib/
  core/
    config/
    constants/
    errors/            ← Failure hierarchy
    extensions/
    helpers/           ← BlocObserver
    services/          ← NotificationService, DeepLinkService
    network/           ← NetworkClient (Dio), NetworkInfo
    storage/           ← StorageService (SharedPreferences)
    theme/             ← AppThemes, AppColors
    router/            ← GoRouter config, route names
    di/                ← get_it ServiceLocator
    utils/
  l10n/                ← ARB files (moved from localization_i18n_arb/)
  shared/
    widgets/           ← CommonButton, ShimmerWidget, etc.
    models/            ← shared cross-feature models if any
  features/
    auth/
    home/
    restaurant/
    cart/
    order/
    payment/
    qr/
    profile/
    notification/
    splash/
  main.dart
  justorder.dart
```

---

## Verification Plan

### After Each Task
- `flutter analyze` — no new issues introduced
- `flutter build apk --debug` — compiles successfully
- Manual test of affected flow

### Automated Tests (Phase 7)
```bash
flutter test
flutter analyze
```

### Manual Verification
- Login flow (email + Google)
- Browse restaurants/categories
- Add items to cart → checkout → payment
- Order tracking screen
- Language switch (EN ↔ AR)
- Dark/Light theme switch
- Deep link handling
- Push notification receipt
