# Project Memory

## Stack

- Flutter
- MVVM
- Cubit
- GoRouter
- Localization

## Rules

- Widgets = UI only
- ViewModel = presentation logic
- Cubit = state
- Repository = data abstraction
- No business logic in UI
- Localize all strings
- Prefer const
- Prefer immutable state

## Completed

- [x] T001 Remove easy_localization completely
- [x] T002 Create memory.md
- [x] T003 Remove duplicate DeepLinkListener
- [x] T004 Extract global prefs into StorageService class
- [x] T005 Rename lib/Utils/ → lib/utils/
- [x] T006 Move lib/Qr.png to assets/images/
- [x] T007 Create lib/core/ folder skeleton
- [x] T008 Move constants → core/constants/
- [x] T009 Move theme files → core/theme/
- [x] T010 Move BlocObserver → core/helpers/
- [x] T011 Move utils/ → core/utils/
- [x] T012 Move network/dio_helper.dart → core/network/
- [x] T013 Move services → core/services/
- [x] T014 Add get_it and create empty service locator

## Current

- [/] T015 Register services in DI

## Known Issues

- 

## Decisions

- DI Container: get_it
- freezed scope: Union states only
- Error handling: Dart 3 sealed Result type (no dartz dependency)
- GoRouter typing: go_router_builder
- ViewModel: Mandatory per feature
- Exclusions: None (all features will be migrated)
