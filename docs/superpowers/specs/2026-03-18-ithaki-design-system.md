# Ithaki Design System Package — Spec

**Date:** 2026-03-18
**Status:** Approved

## Context

Two Flutter projects share the same visual identity (Ithaki brand): `ithaki_ui` (talent onboarding app) and a login app built by a teammate. Both developers work on separate machines on the same network. The goal is to extract the shared UI layer into a standalone Flutter package hosted on GitHub so both projects can depend on it.

## Approach

A separate GitHub repository `ithaki_design_system` published as a Flutter package. Both projects reference it via a git dependency in `pubspec.yaml`. Changes to the package are distributed by pushing to GitHub; consuming projects pick them up with `flutter pub upgrade`.

## What Goes in the Package

### Theme
- `IthakiTheme` — colors (`primaryPurple`, `primaryPurpleLight`, `backgroundWhite`, `textPrimary`, `textSecondary`, `textHint`, `borderLight`, `cardBackground`, `successGreen`), text styles (`headingLarge`, `sectionTitle`, `bodyRegular`, `labelMedium`), and `ThemeData get light`.

### Widgets
- `IthakiButton` — primary and outline variants, enabled/disabled states
- `IthakiTextField` — labeled text field with consistent border styling
- `IthakiDropdown<T>` — labeled dropdown with consistent border styling
- `IthakiIcon` — SVG loader using `flutter_svg`; asset path updated to use package prefix
- `IthakiAppBar` — pill-shaped custom app bar; `onBack` callback replaces `context.pop()` to remove `go_router` dependency from the package
- `IthakiStepTabs` — horizontal step progress chips
- `IthakiFlag` — flag display widget using package-prefixed flag assets
- `SearchBottomSheet` — searchable modal bottom sheet
- `CountdownMixin` — reusable countdown timer mixin

### Models
- `SearchItem` — required by `SearchBottomSheet`; generic enough to live in the package

### Assets
- `assets/icons/` — all SVG icons
- `assets/flags/` — all flag assets

## Package Structure

```
ithaki_design_system/
├── lib/
│   ├── ithaki_design_system.dart     ← single barrel export
│   └── src/
│       ├── theme/
│       │   └── ithaki_theme.dart
│       ├── widgets/
│       │   ├── ithaki_button.dart
│       │   ├── ithaki_text_field.dart
│       │   ├── ithaki_dropdown.dart
│       │   ├── ithaki_icon.dart
│       │   ├── ithaki_app_bar.dart
│       │   ├── ithaki_step_tabs.dart
│       │   ├── search_bottom_sheet.dart
│       │   ├── ithaki_flag.dart
│       │   └── countdown_mixin.dart
│       └── models/
│           └── search_item.dart
├── assets/
│   ├── icons/
│   └── flags/
└── pubspec.yaml
```

## Key Technical Details

### Asset Path Prefix
Flutter requires package assets to be referenced with the package prefix. `IthakiIcon` and `IthakiFlag` must use:
```dart
'packages/ithaki_design_system/assets/icons/$name.svg'
'packages/ithaki_design_system/assets/flags/$code.svg'   // flags are SVG, not PNG
```

### IthakiAppBar Decoupling
Remove the `go_router` import. Add two optional callbacks so callers wire navigation themselves:
- `VoidCallback? onBack` — replaces `context.pop()` in the Back button
- `VoidCallback? onLoginPressed` — replaces the current no-op `() {}` on the Login button

The `showMenuAndAvatar` mode renders a `CircleAvatar` with hardcoded initials `'AA'`. In v0.1.0 this stays as-is (it is a placeholder); parameterization (`avatarInitials`, `avatarColor`) is deferred to a future version.

### SearchItem Model
`SearchItem` contains `Widget? leadingWidget` — a Flutter widget stored as a plain model field. This is intentional for the current use case (displaying flags and icons in the bottom sheet) but means `SearchItem` cannot be serialized or used outside Flutter. This design is preserved as-is in v0.1.0.

### Package pubspec.yaml
```yaml
name: ithaki_design_system
description: Shared design system for Ithaki Flutter apps
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.0.10

flutter:
  assets:
    - assets/icons/
    - assets/flags/
```

### Consuming projects pubspec.yaml
```yaml
ithaki_design_system:
  git:
    url: https://github.com/TU_ORG/ithaki_design_system.git
    ref: main
```

## Changes to ithaki_ui

1. Delete `lib/theme/` and `lib/widgets/`
2. Remove `assets/icons/`, `assets/flags/`, and the direct `flutter_svg` dependency from `pubspec.yaml` (it is now a transitive dep via the package)
3. Add `ithaki_design_system` git dependency
4. Update all imports to `package:ithaki_design_system/ithaki_design_system.dart`
5. Update `IthakiAppBar` usages to pass `onBack: () => context.pop()` and `onLoginPressed: () => context.go('/login')` where needed

## What Stays in ithaki_ui

- `lib/models/setup_data.dart` — app-specific model
- `lib/data/countries.dart` — app-specific data
- `lib/screens/` — all screens
- `lib/router.dart`, `lib/main.dart`

## Barrel Export

`lib/ithaki_design_system.dart` must export:
```dart
export 'src/theme/ithaki_theme.dart';
export 'src/models/search_item.dart';
export 'src/widgets/ithaki_button.dart';
export 'src/widgets/ithaki_text_field.dart';
export 'src/widgets/ithaki_dropdown.dart';
export 'src/widgets/ithaki_icon.dart';
export 'src/widgets/ithaki_app_bar.dart';
export 'src/widgets/ithaki_step_tabs.dart';
export 'src/widgets/search_bottom_sheet.dart';
export 'src/widgets/ithaki_flag.dart';
export 'src/widgets/countdown_mixin.dart';
```

## Team Workflow

```
Developer A changes a color in ithaki_design_system
  → git commit + push to ithaki_design_system repo
  → Developer B runs: flutter pub upgrade
  → Change is available in their project
```

**Important:** With `ref: main`, each developer gets whatever commit HEAD points to at the time they run `flutter pub get`. If one developer has pushed changes the other hasn't pulled, they will be on different versions. **Recommended:** both projects start with `ref: v0.1.0` (a git tag) and only bump the ref when explicitly agreeing to pick up new changes. This avoids silent divergence between machines.
