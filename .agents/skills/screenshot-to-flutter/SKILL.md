---
name: screenshot-to-flutter
description: Use when user pastes a screenshot, attaches an image, or references a mockup/design and asks to convert, replicate, build, or implement it in Flutter for the Ithaki project. Triggers on "convert this screenshot", "build this UI", "make this in Flutter", "replicate this design", any image path + UI request.
---

# Screenshot → Flutter (Ithaki)

## Overview

Translate raster mockups into idiomatic Ithaki Flutter code. Output MUST use `IthakiTheme` tokens, `IthakiIcon`, `ithaki_design_system` components, and existing `lib/widgets/` before inventing anything new.

Hard rule: never produce raw hex, raw `Icon(...)`, raw `TextStyle(fontSize: ...)`, or untranslated user-visible strings.Always be Awere of not putting despite in the capture is, the footer and the ithaky.com thing

## When to Use

- User pastes/attaches a screenshot of a UI and asks for Flutter code.
- User references a mockup file path or Figma export image.
- User says "implement this design", "make this screen", "replicate this".

When NOT to use:
- Figma URL provided → use `mcp__claude_ai_Figma__get_design_context` first; this skill only for raster/screenshot inputs.
- Pure logic / non-UI tasks.

## Workflow

1. **Read image** with `Read` tool (absolute path).
2. **Decompose** the screenshot top→bottom into regions: appbar, hero/banner, cards, lists, CTAs, footer/nav.
3. **Map each region** to existing components (table below). Reuse before creating.
4. **Extract tokens** from visuals → `IthakiTheme.*`. Never inline hex.
5. **Identify icons** → `IthakiIcon('name', size: N)`. Match name against known icon list in `CLAUDE.md`; if unsure, ask user instead of guessing.
6. **Draft scaffold** using the screen skeleton from `CLAUDE.md` (`ConsumerStatefulWidget` + `IthakiAppBar` + `IthakiScreenLayout`).
7. **Stub strings** with `AppLocalizations.of(context)!.<key>` and append keys to `lib/l10n/app_en.arb` (and `el`/`ar` with TODO if unknown).
8. **Place file** under correct feature folder (`lib/screens/<feature>/` or `lib/widgets/` if reusable).
9. **State the assumptions** you made (sizes, copy, missing icons) at the end so user can correct.

## Component Mapping (visual → code)

| Visual cue in screenshot | Use this |
|---|---|
| Top bar with menu+avatar | `IthakiAppBar(onMenuTap:, onAvatarTap:)` |
| Purple gradient hero | `IthakiGradientBanner` |
| White rounded surface | `IthakiCard` (radius 20) |
| Filled CTA (purple) | `IthakiButton` |
| Outlined CTA | `IthakiOutlineButton` |
| Stat tile / KPI | `IthakiStatCard` + `IthakiStatRowData` |
| Back arrow + text | `IthakiBackLink` |
| User header (avatar + name + meta) | `ProfileHeaderCard` |
| Job/work timeline row | `WorkExperienceCard` |
| Selectable pill | `OptionChip` |
| List with "+ Add" footer | `ProfileEntryListShell` |
| Empty section placeholder | `ProfileEmptyStateCard` |
| Bottom sheet (upload, picker) | extend `BottomSheetBase` |
| Dashed dropzone | `DottedBorderBox` |
| Slide-in nav | `AppNavDrawer` via `PanelScaffold` |
| Tabs inside profile | `ProfileTabBar` |
| Footer | `IthakiFooter` |

## Color Translation Rules

| Visual | Token |
|---|---|
| Page bg (lavender) | `backgroundViolet` |
| Card bg (white) | `backgroundWhite` / `cardBackground` |
| Primary purple | `primaryPurple` |
| Light purple accent | `accentPurpleLight` |
| Lime badge | `badgeLime` |
| Green match | `matchGreen` |
| Body text | `textPrimary` |
| Muted text | `textSecondary` |
| Divider/border | `borderLight` |
| Skeleton fill | `placeholderBg` |
| Soft grey surface | `softGray` |

Match-strength gradients → `lib/utils/match_colors.dart`. Never inline.

## Spacing Defaults

- Horizontal screen margin: 16
- Card internal padding: 24
- Card radius: `BorderRadius.circular(20)`
- Icon sizes: 16–18 meta, 20–22 stats, 24 interactive

## Output Skeleton

```dart
class FooScreen extends ConsumerStatefulWidget {
  const FooScreen({super.key});
  @override
  ConsumerState<FooScreen> createState() => _FooScreenState();
}

class _FooScreenState extends ConsumerState<FooScreen>
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        onMenuTap: _panels.openNav,
        onAvatarTap: _panels.openProfile,
      ),
      body: IthakiScreenLayout(
        child: Column(children: [/* mapped regions */]),
      ),
    );
  }
}
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| `Color(0xFF...)` literal | Replace with `IthakiTheme.<token>` |
| `Icon(Icons.x)` | `IthakiIcon('<name>', size: N)` |
| `TextStyle(fontSize: 16, ...)` | `IthakiTheme.<style>` or `Theme.of(context).textTheme.<role>` |
| Hardcoded English string | ARB key + `AppLocalizations.of(context)!.<key>` |
| New custom widget for existing pattern | Search `lib/widgets/` first |
| `setState` for shared data | Riverpod provider |
| New route | Add path in `lib/routes.dart` AND `lib/router.dart` |
| Guessing icon name | Ask user; do not invent |

## Red Flags — STOP

- About to write `Color(0xFF` → stop, find token.
- About to write `Icon(Icons.` → stop, use `IthakiIcon`.
- Drafting English in widget tree → stop, ARB key first.
- Building a new card from `Container` + `BoxDecoration` → stop, use `IthakiCard`.

## Final Step

After producing code, list:
1. New ARB keys added (English copy used).
2. Assumed icon names (mark `?` if uncertain).
3. Any region you couldn't map → asked user instead of guessing.
