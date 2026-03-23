# Product Tour System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a 13-step interactive product tour with spotlight cutout overlays, welcome/skip/completion modals, Riverpod state management, and SharedPreferences persistence.

**Architecture:** A `TourNotifier` (Riverpod) holds `tourCompleted` and `currentStep` state, persisted to SharedPreferences. An app-level `TourOverlay` widget sits inside `MaterialApp.router`'s builder and renders on top of everything using Flutter's `Overlay` API. Each of the 13 steps is targeted via `GlobalKey` widgets placed on their respective HomeScreen elements.

**Tech Stack:** Flutter, flutter_riverpod ^3.3.1, shared_preferences ^2.3.0, GoRouter ^17.1.0, CustomPainter (spotlight cutout), OverlayEntry

---

## File Map

| Action | File | Responsibility |
|--------|------|---------------|
| Modify | `pubspec.yaml` | Add `shared_preferences` dependency |
| Create | `lib/providers/tour_provider.dart` | `TourState`, `TourNotifier`, `tourProvider`, `tourKeysProvider` |
| Create | `lib/tour/tour_steps.dart` | `TourStep` model + list of 13 steps |
| Create | `lib/tour/tour_overlay.dart` | `TourOverlay` widget — spotlight painter + tooltip bubble |
| Create | `lib/tour/tour_welcome_modal.dart` | Welcome bottom-sheet modal |
| Create | `lib/tour/tour_skip_modal.dart` | Skip confirmation bottom-sheet modal |
| Create | `lib/tour/tour_complete_modal.dart` | Tour completion bottom-sheet modal |
| Modify | `lib/main.dart` | Wrap `MaterialApp.router` body with `TourOverlay` via `builder:` |
| Modify | `lib/screens/home/home_screen.dart` | Add `GlobalKey`s on 13 target widgets, start tour on mount |

---

## Task 1: Add shared_preferences dependency

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add the dependency**

In `pubspec.yaml`, under `dependencies:`, add:
```yaml
shared_preferences: ^2.3.0
```

- [ ] **Step 2: Install**

Run: `flutter pub get`
Expected: resolves without errors, `pubspec.lock` updated

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add shared_preferences dependency for tour persistence"
```

---

## Task 2: TourState and TourNotifier

**Files:**
- Create: `lib/providers/tour_provider.dart`

- [ ] **Step 1: Create the provider file**

```dart
// lib/providers/tour_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kTourCompleted = 'tour_completed';
const _kTourStep = 'tour_step';

class TourState {
  final bool tourCompleted;
  final int currentStep; // 0 = not started, 1–13 = active step, 14 = done
  final bool welcomeVisible;
  final bool skipConfirmVisible;
  final bool completionVisible;

  const TourState({
    this.tourCompleted = false,
    this.currentStep = 0,
    this.welcomeVisible = false,
    this.skipConfirmVisible = false,
    this.completionVisible = false,
  });

  TourState copyWith({
    bool? tourCompleted,
    int? currentStep,
    bool? welcomeVisible,
    bool? skipConfirmVisible,
    bool? completionVisible,
  }) =>
      TourState(
        tourCompleted: tourCompleted ?? this.tourCompleted,
        currentStep: currentStep ?? this.currentStep,
        welcomeVisible: welcomeVisible ?? this.welcomeVisible,
        skipConfirmVisible: skipConfirmVisible ?? this.skipConfirmVisible,
        completionVisible: completionVisible ?? this.completionVisible,
      );
}

class TourNotifier extends Notifier<TourState> {
  @override
  TourState build() => const TourState();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_kTourCompleted) ?? false;
    final step = prefs.getInt(_kTourStep) ?? 0;
    state = state.copyWith(tourCompleted: completed, currentStep: step);
    if (!completed) {
      state = state.copyWith(welcomeVisible: true);
    }
  }

  Future<void> startTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kTourStep, 1);
    state = state.copyWith(
      welcomeVisible: false,
      currentStep: 1,
    );
  }

  Future<void> nextStep() async {
    final next = state.currentStep + 1;
    final prefs = await SharedPreferences.getInstance();
    if (next > 13) {
      await prefs.setBool(_kTourCompleted, true);
      await prefs.setInt(_kTourStep, 0);
      state = state.copyWith(
        currentStep: 0,
        completionVisible: true,
      );
    } else {
      await prefs.setInt(_kTourStep, next);
      state = state.copyWith(currentStep: next);
    }
  }

  void showSkipConfirm() =>
      state = state.copyWith(skipConfirmVisible: true);

  void cancelSkip() =>
      state = state.copyWith(skipConfirmVisible: false);

  Future<void> confirmSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    await prefs.setInt(_kTourStep, 0);
    state = state.copyWith(
      tourCompleted: true,
      currentStep: 0,
      skipConfirmVisible: false,
    );
  }

  Future<void> completeTour() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kTourCompleted, true);
    state = state.copyWith(
      tourCompleted: true,
      currentStep: 0,
      completionVisible: false,
    );
  }
}

final tourProvider = NotifierProvider<TourNotifier, TourState>(
  TourNotifier.new,
);

// Top-level constant map so GlobalKey instances are never recreated.
// Must be declared outside any provider factory to survive hot restarts.
final _tourKeys = {for (var i = 1; i <= 13; i++) i: GlobalKey(debugLabel: 'tourKey_$i')};

final tourKeysProvider = Provider<Map<int, GlobalKey>>((_) => _tourKeys);
```

> **Note:** Import `package:flutter/material.dart` at the top of this file for `GlobalKey`.

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/providers/tour_provider.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/providers/tour_provider.dart
git commit -m "feat: add TourNotifier with SharedPreferences persistence"
```

---

## Task 3: TourStep model and 13-step list

> **Prerequisite:** Create the `lib/tour/` directory before writing any files in Tasks 3–7.
> Run: `mkdir lib/tour` from the Ithaki app root, or let the file-creation tool create it automatically.

**Files:**
- Create: `lib/tour/tour_steps.dart`

- [ ] **Step 1: Create the file**

```dart
// lib/tour/tour_steps.dart

/// Describes one tooltip in the product tour.
class TourStep {
  final int stepNumber;   // 1–13
  final String title;
  final String body;
  final TooltipPlacement placement; // where the bubble appears relative to target

  const TourStep({
    required this.stepNumber,
    required this.title,
    required this.body,
    required this.placement,
  });
}

enum TooltipPlacement { above, below, left, right }

const tourSteps = <TourStep>[
  TourStep(
    stepNumber: 1,
    title: 'Menu',
    body: 'Tap the menu icon to navigate between all sections of the app.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 2,
    title: 'Your Profile',
    body: 'Tap your avatar to access your profile, CV, settings, and log out.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 3,
    title: 'Start the Tour',
    body: 'This card lets you restart the product tour anytime you need a refresher.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 4,
    title: 'Welcome Message',
    body: 'Your personalised greeting — here you can see your daily summary.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 5,
    title: 'Complete Your Profile',
    body: 'Finish these steps to unlock full job-matching and employer visibility.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 6,
    title: 'Job Search',
    body: 'Search for jobs by title or keyword and filter by preference.',
    placement: TooltipPlacement.below,
  ),
  TourStep(
    stepNumber: 7,
    title: 'Smart Recommendations',
    body: 'AI-powered job cards matched to your profile, skills, and location.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 8,
    title: 'Career Assistant',
    body: 'Not sure where to start? Ask the AI career assistant for guidance.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 9,
    title: 'CV Success Stats',
    body: 'Track how many employers viewed your CV, sent invitations, and more.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 10,
    title: 'Recommended Courses',
    body: 'Level up your skills with curated courses matched to your career goals.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 11,
    title: 'Latest News',
    body: 'Stay up to date with industry news, hiring trends, and career tips.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 12,
    title: 'Have Questions?',
    body: 'Reach out to our support team — we\'re here to help you succeed.',
    placement: TooltipPlacement.above,
  ),
  TourStep(
    stepNumber: 13,
    title: "You're all set!",
    body: 'That\'s the full tour. Start exploring and take the next step in your career.',
    placement: TooltipPlacement.above,
  ),
];
```

- [ ] **Step 2: Commit**

```bash
git add lib/tour/tour_steps.dart
git commit -m "feat: add 13-step TourStep model and step definitions"
```

---

## Task 4: Welcome modal

**Files:**
- Create: `lib/tour/tour_welcome_modal.dart`

- [ ] **Step 1: Create the file**

```dart
// lib/tour/tour_welcome_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

/// Shows once on first launch. Offers "Start Tour" or "Skip".
class TourWelcomeModal extends ConsumerWidget {
  const TourWelcomeModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourWelcomeModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tourProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IthakiIcon('rocket', size: 48, color: IthakiTheme.primaryPurple),
          const SizedBox(height: 16),
          Text('Welcome to Ithaki!', style: IthakiTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            "Let's take a quick tour so you know where everything is. It only takes a minute.",
            style: IthakiTheme.bodyRegular.copyWith(color: IthakiTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              'Start Tour',
              onPressed: () {
                Navigator.of(context).pop();
                notifier.startTour();
              },
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              notifier.confirmSkip();
            },
            child: Text(
              'Skip for now',
              style: IthakiTheme.bodyRegular.copyWith(
                color: IthakiTheme.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/tour/tour_welcome_modal.dart
git commit -m "feat: add TourWelcomeModal bottom sheet"
```

---

## Task 5: Skip confirmation modal

**Files:**
- Create: `lib/tour/tour_skip_modal.dart`

- [ ] **Step 1: Create the file**

```dart
// lib/tour/tour_skip_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

class TourSkipModal extends ConsumerWidget {
  const TourSkipModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourSkipModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tourProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Skip the tour?', style: IthakiTheme.headingMedium),
          const SizedBox(height: 8),
          Text(
            "You can always restart the tour from the Home screen.",
            style: IthakiTheme.bodyRegular.copyWith(color: IthakiTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              'Continue Tour',
              onPressed: () {
                Navigator.of(context).pop();
                notifier.cancelSkip();
              },
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              notifier.confirmSkip();
            },
            child: Text(
              'Skip',
              style: IthakiTheme.bodyRegular.copyWith(
                color: IthakiTheme.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/tour/tour_skip_modal.dart
git commit -m "feat: add TourSkipModal bottom sheet"
```

---

## Task 6: Completion modal

**Files:**
- Create: `lib/tour/tour_complete_modal.dart`

- [ ] **Step 1: Create the file**

```dart
// lib/tour/tour_complete_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

class TourCompleteModal extends ConsumerWidget {
  const TourCompleteModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourCompleteModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tourProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IthakiIcon('rocket', size: 48, color: IthakiTheme.primaryPurple),
          const SizedBox(height: 16),
          Text("Tour Complete!", style: IthakiTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            "You're ready to go! Start exploring Ithaki and take the next step in your career.",
            style: IthakiTheme.bodyRegular.copyWith(color: IthakiTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              "Let's Go!",
              onPressed: () {
                Navigator.of(context).pop();
                notifier.completeTour();
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/tour/tour_complete_modal.dart
git commit -m "feat: add TourCompleteModal bottom sheet"
```

---

## Task 7: Spotlight CustomPainter + TourOverlay widget

**Files:**
- Create: `lib/tour/tour_overlay.dart`

This is the most complex task. The overlay:
1. Renders a full-screen dark scrim
2. Cuts out a transparent rect around the target element (using `PathFillType.evenOdd`)
3. Draws a tooltip bubble above or below the cutout
4. Has "Next" / "Skip" buttons inside the bubble

Getting the target element's position uses `GlobalKey.currentContext?.findRenderObject()?.paintBounds` with `localToGlobal`.

- [ ] **Step 1: Create the file**

```dart
// lib/tour/tour_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';
import 'tour_steps.dart';
import 'tour_skip_modal.dart';
import 'tour_complete_modal.dart';

/// Returns the screen-space [Rect] of any widget via its [GlobalKey].
/// Returns [Rect.zero] if the key has no context yet.
Rect _getWidgetRect(GlobalKey key) {
  final ctx = key.currentContext;
  if (ctx == null) return Rect.zero;
  final box = ctx.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return Rect.zero;
  final pos = box.localToGlobal(Offset.zero);
  return pos & box.size;
}

// ── Spotlight painter ────────────────────────────────────────────────────────

class _SpotlightPainter extends CustomPainter {
  final Rect spotlight;
  final double radius;
  const _SpotlightPainter({required this.spotlight, this.radius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final scrim = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
          spotlight.inflate(8), Radius.circular(radius)));
    canvas.drawPath(path, scrim);
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.spotlight != spotlight;
}

// ── Tooltip bubble ───────────────────────────────────────────────────────────

class _TourTooltip extends StatelessWidget {
  final TourStep step;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TourTooltip({
    required this.step,
    required this.totalSteps,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = step.stepNumber == totalSteps;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(step.title,
                  // IthakiTheme.headingSmall does not exist — use explicit style
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              Text(
                '${step.stepNumber}/$totalSteps',
                style: const TextStyle(
                    fontSize: 12,
                    color: IthakiTheme.softGraphite),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(step.body,
              style: IthakiTheme.bodyRegular
                  .copyWith(color: IthakiTheme.textSecondary)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onSkip,
                child: Text('Skip',
                    style: IthakiTheme.bodyRegular.copyWith(
                        color: IthakiTheme.textSecondary,
                        decoration: TextDecoration.underline)),
              ),
              IthakiButton(
                isLast ? 'Finish' : 'Next',
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Main overlay widget ──────────────────────────────────────────────────────

/// Wraps [child] and renders the tour overlay on top when the tour is active.
///
/// Usage — in `main.dart` MaterialApp.router builder:
/// ```dart
/// builder: (context, child) => TourOverlay(keys: tourKeys, child: child!),
/// ```
class TourOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final Map<int, GlobalKey> keys; // step number → GlobalKey

  const TourOverlay({super.key, required this.child, required this.keys});

  @override
  ConsumerState<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends ConsumerState<TourOverlay> {
  @override
  Widget build(BuildContext context) {
    final tourState = ref.watch(tourProvider);
    final notifier = ref.read(tourProvider.notifier);
    final step = tourState.currentStep;
    final isActive = !tourState.tourCompleted && step >= 1 && step <= 13;

    if (!isActive) return widget.child;

    final stepDef = tourSteps[step - 1];
    final targetKey = widget.keys[step];
    final targetRect = targetKey != null ? _getWidgetRect(targetKey) : Rect.zero;
    final screenH = MediaQuery.of(context).size.height;
    const bubbleHeight = 160.0;
    const sidePadding = 24.0;

    // Decide tooltip placement
    final placeBelow = stepDef.placement == TooltipPlacement.below ||
        targetRect.top > screenH / 2;
    final tooltipTop = placeBelow
        ? targetRect.bottom + 16
        : targetRect.top - bubbleHeight - 16;

    return Stack(
      children: [
        widget.child,

        // Scrim + spotlight cutout
        Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: GestureDetector(
              onTap: () {}, // absorb taps on scrim
              child: CustomPaint(
                painter: _SpotlightPainter(spotlight: targetRect),
              ),
            ),
          ),
        ),

        // Tooltip bubble
        Positioned(
          top: tooltipTop.clamp(
              MediaQuery.of(context).padding.top + 8,
              screenH - bubbleHeight - 8),
          left: sidePadding,
          right: sidePadding,
          child: _TourTooltip(
            step: stepDef,
            totalSteps: 13,
            onNext: () => notifier.nextStep(),
            // NOTE: Task 11 adds ref.listen to drive skip/complete modals.
            // Do NOT call TourSkipModal.show or TourCompleteModal.show here.
            onSkip: () => notifier.showSkipConfirm(),
          ),
        ),
      ],
    );
  }
}
```

> **Note on `IthakiTheme.headingSmall`**: If this text style doesn't exist in the design system, replace with `const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)`. Check `ithaki_theme.dart` before using.

- [ ] **Step 2: Verify it compiles**

Run: `flutter analyze lib/tour/tour_overlay.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/tour/tour_overlay.dart
git commit -m "feat: add TourOverlay with spotlight CustomPainter and tooltip bubble"
```

---

## Task 8: Wire TourOverlay into main.dart

**Files:**
- Modify: `lib/main.dart`

The `TourOverlay` needs to sit above the router's page stack. We use `MaterialApp.router`'s `builder:` parameter. The `GlobalKey` map is created once in `IthakiApp` and passed down via `InheritedWidget` or `Riverpod`. The simplest approach: expose a `tourKeysProvider` (a plain `Provider`) holding the map, and pass it to `TourOverlay`.

- [ ] **Step 1: Verify `tourKeysProvider` is already in `tour_provider.dart`**

This was added at the end of Task 2. Confirm the file already contains:
```dart
final _tourKeys = {for (var i = 1; i <= 13; i++) i: GlobalKey(debugLabel: 'tourKey_$i')};
final tourKeysProvider = Provider<Map<int, GlobalKey>>((_) => _tourKeys);
```
If not, add it now. The top-level `_tourKeys` map ensures the same `GlobalKey` instances survive hot restarts.

- [ ] **Step 2: Modify main.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'providers/locale_provider.dart';
import 'providers/tour_provider.dart';
import 'router.dart';
import 'tour/tour_overlay.dart';
import 'tour/tour_welcome_modal.dart';

void main() => runApp(const ProviderScope(child: IthakiApp()));

class IthakiApp extends ConsumerWidget {
  const IthakiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final tourKeys = ref.watch(tourKeysProvider);

    return MaterialApp.router(
      title: 'Ithaki',
      debugShowCheckedModeBanner: false,
      theme: IthakiTheme.light,
      routerConfig: IthakiRouter.router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('el'),
        Locale('ar'),
      ],
      builder: (context, child) => TourOverlay(
        keys: tourKeys,
        child: child!,
      ),
    );
  }
}
```

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/main.dart`
Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/main.dart lib/providers/tour_provider.dart
git commit -m "feat: wire TourOverlay into MaterialApp.router builder"
```

---

## Task 9: Add GlobalKeys to HomeScreen target widgets

**Files:**
- Modify: `lib/screens/home/home_screen.dart`

The 13 tour targets map to these HomeScreen widgets:

| Step | Target widget |
|------|--------------|
| 1 | Menu hamburger icon in AppBar |
| 2 | Avatar button in AppBar |
| 3 | Product tour banner card |
| 4 | Greeting header card |
| 5 | Profile completion card |
| 6 | Search bar widget |
| 7 | Job recommendations section card |
| 8 | Career Assistant banner |
| 9 | CV Success stats card |
| 10 | Recommended Courses section card |
| 11 | Latest News section card |
| 12 | Have Questions section card |
| 13 | Footer |

Because the AppBar (steps 1 & 2) is an `IthakiAppBar` and does not expose `GlobalKey` params natively, steps 1 and 2 will target the AppBar widget itself as a fallback — or we can add `key` params to `IthakiAppBar`. The simplest approach: wrap the AppBar-area in a `KeyedSubtree` at the scaffold level.

- [ ] **Step 1: Add missing imports to `home_screen.dart`**

Add these three imports at the top of the file (after existing imports):
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tour_provider.dart';
import '../../tour/tour_welcome_modal.dart';
```

- [ ] **Step 2: Add GlobalKey fields and consume tourKeysProvider**

Convert `_HomeScreenState` to a `ConsumerStatefulWidget` + `ConsumerState`. Add key lookups from `tourKeysProvider`.

Replace:
```dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
```

With:
```dart
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
```

- [ ] **Step 3: Read tourKeysProvider inside build() and wrap targets**

At the top of `build()`, add:
```dart
final tourKeys = ref.watch(tourKeysProvider);
```

Then wrap each target widget with `KeyedSubtree(key: tourKeys[N], child: ...)`.

Example for the greeting header call:
```dart
KeyedSubtree(
  key: tourKeys[4],
  child: _buildGreetingHeader(_showProductTour ? 0 : topOffset),
),
```

Do the same for steps 3–13 using the target widget table above.

For steps 1 & 2 (AppBar), pass the keys to `IthakiAppBar`:
```dart
appBar: IthakiAppBar(
  menuKey: tourKeys[1],
  avatarKey: tourKeys[2],
  // ...existing params
),
```
> This requires `IthakiAppBar` in the design system to accept optional `menuKey`/`avatarKey` params (Task 10 covers this).

- [ ] **Step 4: Show welcome modal on first mount**

In `initState`, after setting up animation controllers, add:
```dart
WidgetsBinding.instance.addPostFrameCallback((_) async {
  await ref.read(tourProvider.notifier).init();
  final state = ref.read(tourProvider);
  if (state.welcomeVisible && mounted) {
    TourWelcomeModal.show(context);
  }
});
```

- [ ] **Step 5: Commit**

```bash
git add lib/screens/home/home_screen.dart
git commit -m "feat: add GlobalKey targets and welcome modal trigger to HomeScreen"
```

---

## Task 10: Add optional key params to IthakiAppBar (design system)

**Files:**
- Modify: `c:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_app_bar.dart`

- [ ] **Step 1: Read the current IthakiAppBar**

Read `ithaki_app_bar.dart` before editing.

- [ ] **Step 2: Add menuKey and avatarKey optional params**

Add two optional `GlobalKey?` params:
```dart
final GlobalKey? menuKey;
final GlobalKey? avatarKey;
```

Assign them to the respective leading button and avatar `Container`/`GestureDetector`:
```dart
// Leading button:
Container(
  key: menuKey,
  // ...existing decoration
)

// Avatar:
GestureDetector(
  key: avatarKey,
  // ...
)
```

- [ ] **Step 3: Run flutter pub get in design system**

```bash
cd c:/Users/User/Desktop/ithaki_design_system && flutter pub get
```

- [ ] **Step 4: Run `flutter pub get` in the Ithaki app to pick up design system changes**

```bash
cd c:/Users/User/Desktop/Ithaki && flutter pub get
```

Expected: No errors. The new `menuKey`/`avatarKey` params are now available in the app.

- [ ] **Step 5: Commit design system change**

```bash
cd c:/Users/User/Desktop/ithaki_design_system
git add lib/src/widgets/ithaki_app_bar.dart
git commit -m "feat: add optional menuKey and avatarKey params to IthakiAppBar"
```

---

## Task 11: Trigger skip/complete modals from tour state

The `TourOverlay` already calls `TourSkipModal.show` and `TourCompleteModal.show`. But the welcome modal trigger lives in `HomeScreen.initState`. We also need to watch for `skipConfirmVisible` becoming true mid-tour (the user taps Skip inside the tooltip).

- [ ] **Step 1: Modify TourOverlay to listen for skipConfirmVisible**

In `_TourOverlayState.build()`, add a `ref.listen` for `skipConfirmVisible`:

```dart
ref.listen<TourState>(tourProvider, (prev, next) {
  if (next.skipConfirmVisible && !(prev?.skipConfirmVisible ?? false)) {
    TourSkipModal.show(context);
  }
  if (next.completionVisible && !(prev?.completionVisible ?? false)) {
    TourCompleteModal.show(context);
  }
});
```

This replaces the inline calls in the tooltip callbacks (remove the `TourSkipModal.show` / `TourCompleteModal.show` calls from `_TourTooltip` callbacks and instead call `notifier.showSkipConfirm()` / `notifier.nextStep()` only, letting the listener drive the modals).

- [ ] **Step 2: Update tour_overlay.dart accordingly**

In `_TourOverlayState`, add the `ref.listen` block above. In `_TourTooltip.onSkip` callback change from `TourSkipModal.show(context)` to just `notifier.showSkipConfirm()`. In `onNext`, remove the `TourCompleteModal.show` call — the listener handles it.

- [ ] **Step 3: Commit**

```bash
git add lib/tour/tour_overlay.dart
git commit -m "feat: drive skip/complete modals via ref.listen in TourOverlay"
```

---

## Task 12: Scroll-to-target before showing tooltip

For steps 5–13, the target widgets may be off-screen (below the fold). The tour must scroll the `SingleChildScrollView` to bring the target into view before painting the spotlight.

`Scrollable.ensureVisible` walks up the widget tree automatically — no explicit `ScrollController` needed.

> **Note:** Steps 1 & 2 target AppBar elements which are outside the `SingleChildScrollView`. `Scrollable.ensureVisible` will silently do nothing for those steps — which is correct because the AppBar is always visible.

- [ ] **Step 1: Add scrollToStep() method to `_HomeScreenState`**

```dart
Future<void> _scrollToStep(int step) async {
  final tourKeys = ref.read(tourKeysProvider);
  final key = tourKeys[step];
  if (key == null) return;
  final ctx = key.currentContext;
  if (ctx == null) return;
  await Scrollable.ensureVisible(
    ctx,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
    alignment: 0.2, // show target near the top
  );
}
```

- [ ] **Step 2: Call scrollToStep when tour step changes**

In `_HomeScreenState.build()` (or via `ref.listen`), watch for step changes:
```dart
ref.listen<TourState>(tourProvider, (prev, next) {
  if (next.currentStep != (prev?.currentStep ?? 0) &&
      next.currentStep >= 1 &&
      next.currentStep <= 13) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToStep(next.currentStep);
    });
  }
});
```

- [ ] **Step 4: Commit**

```bash
git add lib/screens/home/home_screen.dart
git commit -m "feat: scroll HomeScreen to tour target widget on step change"
```

---

## Task 13: Smoke test and final polish

- [ ] **Step 1: Run the app on a simulator**

```bash
flutter run
```

Expected: App opens, welcome modal appears on first launch, "Start Tour" advances to step 1 with spotlight on the menu icon, each "Next" advances the step, last step shows completion modal, tour does not reappear on restart.

- [ ] **Step 2: Test skip flow**

Tap "Skip" in any tooltip → skip confirmation modal appears → "Skip" confirms → overlay disappears → SharedPreferences persisted → restart app → welcome modal does NOT appear.

- [ ] **Step 3: Drive product tour banner visibility from provider state**

`_showProductTour` is currently a local `bool` set from `MockHomeData.isNewUser`. It must reflect tour completion so the banner hides after the tour is done.

In `_HomeScreenState.build()`, replace the use of `_showProductTour` with:
```dart
final showTourBanner = !ref.watch(tourProvider).tourCompleted;
```
Then replace all `_showProductTour` references in `build()` with `showTourBanner`. Remove the `bool _showProductTour` field.

Also wire the "Start Tour" button in `_buildProductTourCard`:
```dart
onActionPressed: () {
  ref.read(tourProvider.notifier).startTour();
},
```

- [ ] **Step 4: Final commit**

```bash
git add -A
git commit -m "feat: complete 13-step product tour system"
```
