# Ithaki — Design System Rules for Figma MCP Integration

## Approach
- Think before acting. Read existing files before writing code.
- Be concise in output but thorough in reasoning.
- Prefer editing over rewriting whole files.
- Do not re-read files you have already read unless the file may have changed.
- Test your code before declaring done.
- No sycophantic openers or closing fluff.
- Keep solutions simple and direct.
- User instructions always override this file.

## Stack

- **Framework:** Flutter (Dart 3.x)
- **State management:** Riverpod 3 (`AsyncNotifier`, `Notifier`, `Provider`)
- **Routing:** GoRouter 17 (~37 named routes)
- **Design system package:** `ithaki_design_system` v0.10.16 (git)
- **Localization:** ARB-based (English `en`, Greek `el`, Arabic `ar`)

---

## Design Tokens

All tokens live in the external package `ithaki_design_system`. **Never hardcode raw hex values.** Always use `IthakiTheme.*` constants.

### Colors

| Token | Role |
|-------|------|
| `IthakiTheme.primaryPurple` | Primary accent, buttons, icon highlights |
| `IthakiTheme.backgroundViolet` | App-level screen background |
| `IthakiTheme.backgroundWhite` | Card / surface background |
| `IthakiTheme.textPrimary` | Main body text |
| `IthakiTheme.textSecondary` | Muted / secondary text |
| `IthakiTheme.borderLight` | Borders and dividers |
| `IthakiTheme.placeholderBg` | Skeleton / placeholder fill |
| `IthakiTheme.softGray` | Neutral grey surface |
| `IthakiTheme.softGraphite` | Dark grey icons |
| `IthakiTheme.matchGreen` | Strong job-match indicator |
| `IthakiTheme.matchBarBg` | Match bar background |
| `IthakiTheme.accentPurpleLight` | Light purple accent surface |
| `IthakiTheme.badgeLime` | Lime badge / pill |
| `IthakiTheme.cardBackground` | Card fill (distinct from `backgroundWhite`) |
| `IthakiTheme.chipActive` | Active/selected chip state |
| `IthakiTheme.lightGraphite` | Lighter graphite shade |
| `IthakiTheme.lightGray` | Lighter grey shade |
| `IthakiTheme.matchBgGood` | Match background — good match |
| `IthakiTheme.matchBgWeak` | Match background — weak match |
| `IthakiTheme.matchGradientGoodStart/End` | Gradient stops — good match |
| `IthakiTheme.matchGradientHighStart` | Gradient start — high match |
| `IthakiTheme.matchGradientWeakStart/End` | Gradient stops — weak match |
| `IthakiTheme.matchGradientNoneStart/End` | Gradient stops — no match |

For job-match gradients use the utility in `lib/utils/match_colors.dart` — do not inline gradient colors.

### Typography

Text styles are accessed through `IthakiTheme` (e.g. `IthakiTheme.headingLarge`). Prefer these over raw `TextStyle(...)`.

### Spacing

Consistent horizontal margin: **16 px**. Card internal padding: **24 px**. No arbitrary values.

---

## Component Library

### Design-system components (import from `ithaki_design_system`)

| Component | Usage |
|-----------|-------|
| `IthakiAppBar` | Top navigation bar |
| `IthakiButton` / `IthakiOutlineButton` | Primary / secondary CTAs |
| `IthakiCard` | Styled surface container |
| `IthakiIcon` | All icons — use string name, never Flutter `Icon()` |
| `IthakiScreenLayout` | Screen wrapper with standard padding |
| `IthakiStatCard` / `IthakiStatRowData` | Stats display |
| `IthakiGradientBanner` | Gradient hero banner |
| `IthakiFooter` | Page footer |
| `IthakiBackLink` | Back-navigation link |

### App-level widgets (`lib/widgets/`)

Reuse before creating new widgets:

- `AppNavDrawer` — slide-in nav menu
- `ProfileMenuPanel` — slide-in profile panel
- `ProfileHeaderCard` — user avatar + name + meta
- `WorkExperienceCard` — work history row (compact/expanded)
- `ProfileMetaCell` — icon + single text cell
- `ProfilePhotoSection` — photo upload/display
- `JobInterestTile` — job interest list row
- `OptionChip` — selectable chip
- `ProfileEntryListShell` — list container with add-button
- `UploadFilesSheet` — file upload bottom sheet
- `CitySearchBottomSheet` — location search sheet
- `SuccessBanner` — success notification
- `SalaryFieldRow` — salary input row
- `AddJobInterestSheet` — bottom sheet for adding job interests
- `BottomSheetBase` — base class for all bottom sheets
- `DottedBorderBox` — container with dotted border styling
- `LoginMethodFooter` — footer shown on login screens
- `PanelScaffold` — scaffold wrapper with slide-in panels
- `ProfileEmptyStateCard` — empty state placeholder for profile sections
- `ProfilePickerField` — field with picker/selector for profile forms
- `ProfileTabBar` — tab bar used within the profile screen
- `UploadFileTab` — file-upload tab inside upload sheet
- `UploadUrlTab` — URL-upload tab inside upload sheet

---

## Icon System

Icons are rendered exclusively via `IthakiIcon`:

```dart
IthakiIcon('edit-pencil', size: 20, color: IthakiTheme.primaryPurple)
```

### Standard sizes

| Context | Size |
|---------|------|
| Meta / label icons | 16–18 |
| Stats / regular | 20–22 |
| Large interactive | 24 |

### Known icon names

`home`, `jobs`, `applications`, `ai`, `assessment`, `learning-hub`, `blog`,
`eye`, `envelope`, `phone`, `rocket`, `edit-pencil`, `google-social`,
`arrow-down`, `calendar`, `clock`, `delete`, `flag`, `help`, `location`,
`plus`, `profile`, `resume`, `search`, `settings`, `team`, `upload-cloud`

---

## Styling Approach

- **Theme:** `IthakiTheme.light` applied at `MaterialApp.router` level — no dark theme.
- **No CSS / inline styles** — use `BoxDecoration` with `IthakiTheme` tokens.
- **Border radius:** `BorderRadius.circular(20)` for cards; follow design system defaults elsewhere.
- **Responsive:** Use `MediaQuery.paddingOf(context)` for safe areas. No fixed screen dimensions.
- **Shadows / elevation:** Follow `IthakiCard` defaults; avoid custom `BoxShadow` unless required.

---

## Project Structure

```
lib/
├── constants/        # Static nav items, app-wide constants
├── data/             # Static data (countries, etc.)
├── l10n/             # ARB localization files + generated code
├── mixins/           # Shared UI behavior (PanelMenuController)
├── models/           # Immutable data models with copyWith
├── providers/        # Riverpod providers (one file per domain)
├── repositories/     # Abstract repos + mock implementations
├── screens/          # Feature folders: auth/, home/, profile/, job_search/, settings/, setup/
├── tour/             # In-app onboarding tour
├── utils/            # Pure utility functions
├── widgets/          # Shared reusable widgets
├── main.dart
├── router.dart       # GoRouter config (30+ routes)
└── routes.dart       # Route path constants
```

---

## Translating Figma Designs to Flutter

### Workflow

1. **Get design context** with `get_design_context` (fileKey + nodeId from Figma URL).
2. **Map to existing components** — check `lib/widgets/` and design-system components before generating new widgets.
3. **Replace all colors** with `IthakiTheme.*` tokens (never raw hex).
4. **Replace all icons** with `IthakiIcon('name', size: N)`.
5. **Replace all text styles** with `IthakiTheme.*` text style constants or `Theme.of(context).textTheme.*`.
6. **Localize strings** — add keys to `lib/l10n/app_en.arb` and use `AppLocalizations.of(context)!.key`.
7. **State management** — new screens should be `ConsumerStatefulWidget` (or `ConsumerWidget` if stateless). Wire data through providers.
8. **Routing** — add new routes in `lib/router.dart` and constants in `lib/routes.dart`.

### Screen skeleton

```dart
class MyScreen extends ConsumerStatefulWidget {
  const MyScreen({super.key});

  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(this);
  }

  @override
  void dispose() {
    _panels.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IthakiAppBar(
        onMenuTap: _panels.openNav,
        onAvatarTap: _panels.openProfile,
      ),
      backgroundColor: IthakiTheme.backgroundViolet,
      body: IthakiScreenLayout(
        child: Column(children: [/* content */]),
      ),
    );
  }
}
```

### Do NOT

- Hardcode colors, font sizes, or spacing that exist as tokens.
- Use Flutter's built-in `Icon` widget — always use `IthakiIcon`.
- Create new utility functions that duplicate `match_colors.dart`.
- Skip localization for user-visible strings.
- Use `setState` for data that belongs in a provider.

---

## Build configuration

`ApiClient` requires `ITHAKI_API_BASE_URL` at build time via `--dart-define`. A build without it throws a `StateError` immediately.

`.vscode/launch.json` is committed with two pre-configured launch targets (staging / production) — use the VS Code Run & Debug selector to switch between them.

For CLI builds:

```bash
# Run on device — staging
flutter run --dart-define=ITHAKI_API_BASE_URL=https://api.odyssea.com/talent/staging

# Release APK — production
flutter build apk --release --dart-define=ITHAKI_API_BASE_URL=https://api.odyssea.com/talent
```

---

## Assets

- Images: `assets/images/` — referenced with `AssetImage('assets/images/<file>')`.
- Fonts: handled by the design-system package.
- New assets must be registered in `pubspec.yaml` under `flutter.assets`.

---

## Testing

- Unit tests: `test/` — use `mocktail` for mocking repositories.
- Widget tests: wrap with `ProviderScope` and `MaterialApp`.
- No database or network calls in tests — use mock repositories.
