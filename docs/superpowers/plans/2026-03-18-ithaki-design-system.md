# Ithaki Design System Package — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extract the Ithaki theme, widgets, and assets into a standalone Flutter package `ithaki_design_system` on GitHub, then update `ithaki_ui` to consume it.

**Architecture:** New package lives at `C:\Users\User\Desktop\ithaki_design_system\` (sibling to `Ithaki\`). All source files are copied from `ithaki_ui` with minimal changes (asset path prefix, `IthakiAppBar` go_router decoupling). `ithaki_ui` then removes its own `lib/theme/`, `lib/widgets/`, and asset declarations, replacing them with a single git dependency.

**Tech Stack:** Flutter/Dart, flutter_svg ^2.0.10, git, GitHub.

**Spec:** `C:\Users\User\Desktop\Ithaki\docs\superpowers\specs\2026-03-18-ithaki-design-system.md`

---

## File Map

### New files in `ithaki_design_system\`
| File | Responsibility |
|------|---------------|
| `pubspec.yaml` | Package metadata, flutter_svg dep, asset declarations |
| `lib/ithaki_design_system.dart` | Barrel export — single import for consumers |
| `lib/src/theme/ithaki_theme.dart` | Colors, text styles, ThemeData |
| `lib/src/models/search_item.dart` | Data model for SearchBottomSheet |
| `lib/src/widgets/ithaki_button.dart` | Primary/outline button |
| `lib/src/widgets/ithaki_text_field.dart` | Labeled text field |
| `lib/src/widgets/ithaki_dropdown.dart` | Labeled dropdown |
| `lib/src/widgets/ithaki_icon.dart` | SVG loader — asset path uses package prefix |
| `lib/src/widgets/ithaki_flag.dart` | Flag SVG loader — asset path uses package prefix |
| `lib/src/widgets/ithaki_app_bar.dart` | Custom app bar — `onBack`/`onLoginPressed` callbacks, no go_router |
| `lib/src/widgets/ithaki_step_tabs.dart` | Step progress chips |
| `lib/src/widgets/search_bottom_sheet.dart` | Searchable modal bottom sheet |
| `lib/src/widgets/countdown_mixin.dart` | Countdown timer mixin |
| `test/smoke_test.dart` | Verifies package compiles and exports are correct |
| `assets/icons/` | All SVG icons (copied from ithaki_ui) |
| `assets/flags/` | All flag SVGs (copied from ithaki_ui) |

### Modified files in `ithaki_ui\`
| File | Change |
|------|--------|
| `pubspec.yaml` | Add git dep, remove flutter_svg + asset declarations |
| `lib/main.dart` | Update import from local theme to package |
| `lib/screens/auth/*.dart` (8 files) | Replace local imports with package import |
| `lib/screens/setup/*.dart` (4 files) | Replace local imports with package import |

### Deleted from `ithaki_ui\`
- `lib/theme/` (entire directory)
- `lib/widgets/` (entire directory)
- `lib/models/search_item.dart` (moves to package)

---

## Task 1: Create package scaffold

**Files:**
- Create: `C:\Users\User\Desktop\ithaki_design_system\pubspec.yaml`
- Create dirs: `lib\src\theme\`, `lib\src\models\`, `lib\src\widgets\`, `test\`, `assets\icons\`, `assets\flags\`

- [ ] **Step 1: Create the package directory and subdirectories**

```bash
mkdir -p /c/Users/User/Desktop/ithaki_design_system/lib/src/theme
mkdir -p /c/Users/User/Desktop/ithaki_design_system/lib/src/models
mkdir -p /c/Users/User/Desktop/ithaki_design_system/lib/src/widgets
mkdir -p /c/Users/User/Desktop/ithaki_design_system/test
mkdir -p /c/Users/User/Desktop/ithaki_design_system/assets/icons
mkdir -p /c/Users/User/Desktop/ithaki_design_system/assets/flags
```

- [ ] **Step 2: Create `pubspec.yaml`**

Create `C:\Users\User\Desktop\ithaki_design_system\pubspec.yaml`:

```yaml
name: ithaki_design_system
description: Shared design system for Ithaki Flutter apps.
version: 0.1.0
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_svg: ^2.0.10

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  assets:
    - assets/icons/
    - assets/flags/
```

- [ ] **Step 3: Run flutter pub get to verify pubspec is valid**

```bash
cd /c/Users/User/Desktop/ithaki_design_system && flutter pub get
```

Expected: `Got dependencies!` (no errors)

- [ ] **Step 4: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git init
git add pubspec.yaml
git commit -m "chore: initialize ithaki_design_system package"
```

---

## Task 2: Add theme and model

**Files:**
- Create: `lib\src\theme\ithaki_theme.dart` (exact copy from ithaki_ui)
- Create: `lib\src\models\search_item.dart` (exact copy from ithaki_ui)

No code changes needed — these files have no local imports.

- [ ] **Step 1: Copy `ithaki_theme.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\theme\ithaki_theme.dart`:

```dart
import 'package:flutter/material.dart';

class IthakiTheme {
  static const primaryPurple = Color(0xFF905CFF);
  static const primaryPurpleLight = Color(0xFFC7ADFF);
  static const backgroundWhite = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6B6B);
  static const textHint = Color(0xFFAAAAAA);
  static const borderLight = Color(0xFFD0D0D0);
  static const cardBackground = Color(0xFFF2F2F2);
  static const successGreen = Color(0xFF4CAF50);

  static const headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const sectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const bodyRegular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const labelMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: primaryPurple,
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          surface: backgroundWhite,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: backgroundWhite,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      );
}
```

- [ ] **Step 2: Copy `search_item.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\models\search_item.dart`:

```dart
import 'package:flutter/material.dart';

class SearchItem {
  final String id;
  final String label;
  final String subtitle;
  final Widget? leadingWidget;

  const SearchItem({
    required this.id,
    required this.label,
    this.subtitle = '',
    this.leadingWidget,
  });
}
```

- [ ] **Step 3: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/src/theme/ lib/src/models/
git commit -m "feat: add IthakiTheme and SearchItem"
```

---

## Task 3: Add pure widgets (no code changes)

**Files:**
- Create: `lib\src\widgets\ithaki_button.dart`
- Create: `lib\src\widgets\ithaki_text_field.dart`
- Create: `lib\src\widgets\ithaki_dropdown.dart`
- Create: `lib\src\widgets\ithaki_step_tabs.dart`
- Create: `lib\src\widgets\countdown_mixin.dart`

These widgets only import `'../theme/ithaki_theme.dart'` and sibling widgets — those relative paths resolve correctly inside the package's `src/widgets/` directory. Copy verbatim.

- [ ] **Step 1: Copy `ithaki_button.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_button.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/ithaki_theme.dart';

enum IthakiButtonVariant { primary, outline }

class IthakiButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IthakiButtonVariant variant;
  final bool isEnabled;
  final Color? outlineColor;

  const IthakiButton(
    this.label, {
    super.key,
    this.onPressed,
    this.variant = IthakiButtonVariant.primary,
    this.isEnabled = true,
    this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    );

    if (variant == IthakiButtonVariant.outline) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            shape: shape,
            side: const BorderSide(color: IthakiTheme.primaryPurple),
            foregroundColor: IthakiTheme.textPrimary,
          ),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      );
    }

    final bgColor = isEnabled ? IthakiTheme.primaryPurple : IthakiTheme.primaryPurpleLight;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: IthakiTheme.primaryPurpleLight,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          shape: shape,
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Copy `ithaki_text_field.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_text_field.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/ithaki_theme.dart';

class IthakiTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const IthakiTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          style: const TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: IthakiTheme.textHint, fontSize: 14),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: IthakiTheme.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: IthakiTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: IthakiTheme.primaryPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 3: Copy `ithaki_dropdown.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_dropdown.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/ithaki_theme.dart';
import 'ithaki_icon.dart';

class IthakiDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const IthakiDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          icon: const IthakiIcon('arrow-down', size: 20, color: IthakiTheme.textSecondary),
          hint: Text(
            hint,
            style: const TextStyle(color: IthakiTheme.textHint, fontSize: 14),
          ),
          style: const TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: IthakiTheme.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: IthakiTheme.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: IthakiTheme.primaryPurple, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Copy `ithaki_step_tabs.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_step_tabs.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/ithaki_theme.dart';
import 'ithaki_icon.dart';

class IthakiStepTabs extends StatelessWidget {
  final List<String> steps;
  final int currentIndex;
  final int completedUpTo;

  const IthakiStepTabs({
    super.key,
    required this.steps,
    required this.currentIndex,
    required this.completedUpTo,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildChip(index, label),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChip(int index, String label) {
    final isActive = index == currentIndex;
    final isCompleted = index <= completedUpTo;

    Color borderColor;
    Color textColor;
    Color bgColor;

    if (isActive) {
      borderColor = IthakiTheme.primaryPurple;
      textColor = IthakiTheme.primaryPurple;
      bgColor = const Color(0xFFF0EAFA);
    } else if (isCompleted) {
      borderColor = IthakiTheme.primaryPurple;
      textColor = IthakiTheme.primaryPurple;
      bgColor = Colors.white;
    } else {
      borderColor = IthakiTheme.borderLight;
      textColor = IthakiTheme.textSecondary;
      bgColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCompleted) ...[
            IthakiIcon('check', size: 14, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Copy `countdown_mixin.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\countdown_mixin.dart`:

```dart
import 'dart:async';
import 'package:flutter/material.dart';

/// A mixin for StatefulWidgets that need a countdown timer.
/// Provides: countdownSeconds, countdownCanResend, startCountdown(), stopCountdown()
/// Automatically calls setState on each tick.
mixin CountdownMixin<T extends StatefulWidget> on State<T> {
  int countdownSeconds = 24;
  bool countdownCanResend = false;
  Timer? _countdownTimer;

  void startCountdown([int seconds = 24]) {
    countdownSeconds = seconds;
    countdownCanResend = false;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (countdownSeconds > 0) {
          countdownSeconds--;
        } else {
          countdownCanResend = true;
          timer.cancel();
        }
      });
    });
  }

  void stopCountdown() {
    _countdownTimer?.cancel();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
```

- [ ] **Step 6: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/src/widgets/
git commit -m "feat: add pure widgets (button, textfield, dropdown, step tabs, countdown)"
```

---

## Task 4: Add IthakiIcon with package asset path

**Files:**
- Create: `lib\src\widgets\ithaki_icon.dart`

**The change:** `'assets/icons/$name.svg'` → `'packages/ithaki_design_system/assets/icons/$name.svg'`

- [ ] **Step 1: Write the failing test**

Create `C:\Users\User\Desktop\ithaki_design_system\test\smoke_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

void main() {
  test('IthakiTheme exports primary purple color', () {
    expect(IthakiTheme.primaryPurple.value, equals(const Color(0xFF905CFF).value));
  });

  testWidgets('IthakiButton renders with label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: IthakiButton('Test'),
        ),
      ),
    );
    expect(find.text('Test'), findsOneWidget);
  });

  test('IthakiIcon uses package-prefixed asset path', () {
    const icon = IthakiIcon('check', size: 20);
    expect(icon.name, equals('check'));
  });
}
```

- [ ] **Step 2: Run test — expect it to fail (no barrel export yet)**

```bash
cd /c/Users/User/Desktop/ithaki_design_system && flutter test
```

Expected: compile error about missing `ithaki_design_system.dart`

- [ ] **Step 3: Create `ithaki_icon.dart` with updated asset path**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_icon.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IthakiIcon extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const IthakiIcon(this.name, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'packages/ithaki_design_system/assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
```

- [ ] **Step 4: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/src/widgets/ithaki_icon.dart test/
git commit -m "feat: add IthakiIcon with package asset prefix"
```

---

## Task 5: Add IthakiFlag with package asset path

**Files:**
- Create: `lib\src\widgets\ithaki_flag.dart`

**The change:** `'assets/flags/$code.svg'` → `'packages/ithaki_design_system/assets/flags/$code.svg'`

- [ ] **Step 1: Create `ithaki_flag.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_flag.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IthakiFlag extends StatelessWidget {
  final String countryCode;
  final double width;
  final double height;

  const IthakiFlag(
    this.countryCode, {
    super.key,
    this.width = 28,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    final code = countryCode.toLowerCase();
    return SvgPicture.asset(
      'packages/ithaki_design_system/assets/flags/$code.svg',
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholderBuilder: (_) => SizedBox(width: width, height: height),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/src/widgets/ithaki_flag.dart
git commit -m "feat: add IthakiFlag with package asset prefix"
```

---

## Task 6: Add IthakiAppBar (decoupled from go_router)

**Files:**
- Create: `lib\src\widgets\ithaki_app_bar.dart`

**The changes:**
1. Remove `import 'package:go_router/go_router.dart'`
2. Add `VoidCallback? onBack` parameter — replaces `context.pop()`
3. Add `VoidCallback? onLoginPressed` parameter — replaces the no-op `() {}`

- [ ] **Step 1: Create `ithaki_app_bar.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\ithaki_app_bar.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/ithaki_theme.dart';
import 'ithaki_icon.dart';

class IthakiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogin;
  final bool showBack;
  final bool showMenuAndAvatar;
  final VoidCallback? onBack;
  final VoidCallback? onLoginPressed;

  const IthakiAppBar({
    super.key,
    this.showLogin = true,
    this.showBack = false,
    this.showMenuAndAvatar = false,
    this.onBack,
    this.onLoginPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(top: topPadding + 8, left: 16, right: 16, bottom: 8),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: IthakiTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeading() ?? const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Ithaki',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ..._buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading() {
    if (showMenuAndAvatar) {
      return IconButton(
        icon: const IthakiIcon('menu', size: 22),
        onPressed: () {},
      );
    }
    if (showBack) {
      return TextButton(
        onPressed: onBack,
        child: const Text(
          'Back',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: IthakiTheme.textPrimary,
            fontSize: 14,
          ),
        ),
      );
    }
    return null;
  }

  List<Widget> _buildActions() {
    if (showMenuAndAvatar) {
      return [
        IconButton(
          icon: const IthakiIcon('notifications-bell', size: 22),
          onPressed: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(right: 8),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: IthakiTheme.successGreen,
            child: Text(
              'AA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ];
    }
    if (showLogin) {
      return [
        TextButton(
          onPressed: onLoginPressed,
          child: const Text(
            'Login',
            style: TextStyle(
              color: IthakiTheme.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ];
    }
    return [];
  }
}
```

**Note:** `_buildLeading` and `_buildActions` no longer receive `BuildContext` because go_router is gone. The context parameter is removed from both private methods.

- [ ] **Step 2: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/src/widgets/ithaki_app_bar.dart
git commit -m "feat: add IthakiAppBar, decouple from go_router"
```

---

## Task 7: Add SearchBottomSheet

**Files:**
- Create: `lib\src\widgets\search_bottom_sheet.dart`

No code changes — internal imports (`../models/search_item.dart`, `ithaki_button.dart`, `ithaki_icon.dart`, `../theme/ithaki_theme.dart`) all resolve correctly via relative paths.

- [ ] **Step 1: Create `search_bottom_sheet.dart`**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\src\widgets\search_bottom_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import '../models/search_item.dart';
import '../theme/ithaki_theme.dart';
import 'ithaki_button.dart';
import 'ithaki_icon.dart';

class SearchBottomSheet extends StatefulWidget {
  final String title;
  final List<SearchItem> items;
  final ValueChanged<SearchItem> onSelect;

  const SearchBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
  });

  static void show(
    BuildContext context,
    String title,
    List<SearchItem> items,
    ValueChanged<SearchItem> onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SearchBottomSheet(
        title: title,
        items: items,
        onSelect: onSelect,
      ),
    );
  }

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final _searchController = TextEditingController();
  SearchItem? _selected;
  List<SearchItem> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? widget.items
          : widget.items
              .where((item) => item.label.toLowerCase().contains(query))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: IthakiTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(widget.title, style: IthakiTheme.sectionTitle),
                  const Spacer(),
                  IconButton(
                    icon: const IthakiIcon('x-close', size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: IthakiTheme.textHint),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: IthakiTheme.primaryPurple, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final item = _filtered[index];
                  final isSelected = _selected?.id == item.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => setState(() => _selected = item),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? IthakiTheme.cardBackground : null,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            if (isSelected) ...[
                              const IthakiIcon('check', size: 18, color: IthakiTheme.primaryPurple),
                              const SizedBox(width: 8),
                              if (item.leadingWidget != null) item.leadingWidget!,
                            ] else if (item.leadingWidget != null)
                              item.leadingWidget!
                            else
                              const SizedBox(width: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                            ),
                            if (item.subtitle.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(item.subtitle, style: const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary), overflow: TextOverflow.ellipsis),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 16),
              child: IthakiButton(
                'Select',
                isEnabled: _selected != null,
                onPressed: _selected != null
                    ? () {
                        widget.onSelect(_selected!);
                        Navigator.of(context).pop();
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/src/widgets/search_bottom_sheet.dart
git commit -m "feat: add SearchBottomSheet"
```

---

## Task 8: Copy assets

**Files:**
- Copy all files from `C:\Users\User\Desktop\Ithaki\assets\icons\` → `C:\Users\User\Desktop\ithaki_design_system\assets\icons\`
- Copy all files from `C:\Users\User\Desktop\Ithaki\assets\flags\` → `C:\Users\User\Desktop\ithaki_design_system\assets\flags\`

- [ ] **Step 1: Copy icons**

```bash
cp /c/Users/User/Desktop/Ithaki/assets/icons/* /c/Users/User/Desktop/ithaki_design_system/assets/icons/
```

- [ ] **Step 2: Copy flags**

```bash
cp /c/Users/User/Desktop/Ithaki/assets/flags/* /c/Users/User/Desktop/ithaki_design_system/assets/flags/
```

- [ ] **Step 3: Verify asset count matches**

```bash
echo "Source icons:" && ls /c/Users/User/Desktop/Ithaki/assets/icons/ | wc -l
echo "Package icons:" && ls /c/Users/User/Desktop/ithaki_design_system/assets/icons/ | wc -l
echo "Source flags:" && ls /c/Users/User/Desktop/Ithaki/assets/flags/ | wc -l
echo "Package flags:" && ls /c/Users/User/Desktop/ithaki_design_system/assets/flags/ | wc -l
```

Expected: source and package counts match for both directories.

- [ ] **Step 4: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add assets/
git commit -m "feat: add icons and flags assets"
```

---

## Task 9: Write barrel export and run tests

**Files:**
- Create: `lib\ithaki_design_system.dart`

- [ ] **Step 1: Create the barrel export**

Create `C:\Users\User\Desktop\ithaki_design_system\lib\ithaki_design_system.dart`:

```dart
export 'src/theme/ithaki_theme.dart';
export 'src/models/search_item.dart';
export 'src/widgets/ithaki_button.dart';
export 'src/widgets/ithaki_text_field.dart';
export 'src/widgets/ithaki_dropdown.dart';
export 'src/widgets/ithaki_icon.dart';
export 'src/widgets/ithaki_flag.dart';
export 'src/widgets/ithaki_app_bar.dart';
export 'src/widgets/ithaki_step_tabs.dart';
export 'src/widgets/search_bottom_sheet.dart';
export 'src/widgets/countdown_mixin.dart';
```

- [ ] **Step 2: Run the smoke tests**

```bash
cd /c/Users/User/Desktop/ithaki_design_system && flutter test
```

Expected: all 3 tests PASS

- [ ] **Step 3: Commit**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git add lib/ithaki_design_system.dart
git commit -m "feat: add barrel export — package is ready to consume"
```

---

## Task 10: Publish to GitHub

- [ ] **Step 1: Create a new GitHub repository**

Go to https://github.com/new and create a repo named `ithaki_design_system`:
- Visibility: Private (or Public, your choice)
- Do NOT initialize with README, .gitignore, or license (repo must be empty)

- [ ] **Step 2: Tag v0.1.0 and push**

```bash
cd /c/Users/User/Desktop/ithaki_design_system
git remote add origin https://github.com/TU_USUARIO/ithaki_design_system.git
git branch -M main
git tag v0.1.0
git push -u origin main
git push origin v0.1.0
```

Expected: push succeeds, tag appears on GitHub.

---

## Task 11: Update ithaki_ui — pubspec and delete old files

**Files:**
- Modify: `C:\Users\User\Desktop\Ithaki\pubspec.yaml`
- Delete: `C:\Users\User\Desktop\Ithaki\lib\theme\` (directory)
- Delete: `C:\Users\User\Desktop\Ithaki\lib\widgets\` (directory)

- [ ] **Step 1: Update `pubspec.yaml`**

Edit `C:\Users\User\Desktop\Ithaki\pubspec.yaml`. Replace the `dependencies` and `flutter` sections:

```yaml
name: ithaki_ui
description: Ithaki UI - High-Tech Talent Platform
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
  pin_code_fields: ^8.0.1
  intl_phone_field: ^3.2.0
  country_picker: ^2.0.21
  ithaki_design_system:
    git:
      url: https://github.com/TU_USUARIO/ithaki_design_system.git
      ref: v0.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
```

Note: `flutter_svg` and the `assets/icons/` + `assets/flags/` entries are removed — they now live in the package.

- [ ] **Step 2: Delete the old theme, widgets, and moved model files**

```bash
rm -rf /c/Users/User/Desktop/Ithaki/lib/theme
rm -rf /c/Users/User/Desktop/Ithaki/lib/widgets
rm /c/Users/User/Desktop/Ithaki/lib/models/search_item.dart
```

- [ ] **Step 3: Run flutter pub get**

```bash
cd /c/Users/User/Desktop/Ithaki && flutter pub get
```

Expected: `Got dependencies!` — the package is fetched from GitHub.

- [ ] **Step 4: Commit**

```bash
cd /c/Users/User/Desktop/Ithaki
git add pubspec.yaml pubspec.lock
git rm -r lib/theme lib/widgets lib/models/search_item.dart
git commit -m "chore: replace local theme+widgets with ithaki_design_system package"
```

---

## Task 12: Update imports in ithaki_ui

**Files to modify** (replace multiple local imports with single package import):

| File | Old imports to remove |
|------|-----------------------|
| `lib/main.dart` | `import 'theme/ithaki_theme.dart';` |
| `lib/screens/auth/select_language_screen.dart` | theme, ithaki_app_bar, ithaki_button, ithaki_flag, ithaki_icon, search_bottom_sheet |
| `lib/screens/auth/register_screen.dart` | theme, ithaki_app_bar, ithaki_button, ithaki_icon, ithaki_text_field |
| `lib/screens/auth/personal_details_screen.dart` | theme, ithaki_app_bar, ithaki_button, ithaki_icon, ithaki_text_field |
| `lib/screens/auth/verify_email_screen.dart` | theme, countdown_mixin, ithaki_app_bar, ithaki_button, ithaki_icon |
| `lib/screens/auth/verify_otp_screen.dart` | theme, countdown_mixin, ithaki_app_bar, ithaki_button |
| `lib/screens/auth/choose_verify_method_screen.dart` | theme, ithaki_app_bar, ithaki_button, ithaki_icon |
| `lib/screens/auth/welcome_modal_screen.dart` | `theme/ithaki_theme.dart`, `widgets/ithaki_button.dart` |
| `lib/screens/auth/tech_comfort_screen.dart` | theme, ithaki_app_bar, ithaki_button |
| `lib/screens/setup/location_screen.dart` | theme, models/search_item, ithaki_app_bar, ithaki_button, ithaki_flag, ithaki_icon, ithaki_step_tabs, ithaki_text_field, search_bottom_sheet |
| `lib/screens/setup/job_interests_screen.dart` | theme, ithaki_app_bar, ithaki_button |
| `lib/screens/setup/preferences_screen.dart` | theme, ithaki_app_bar, ithaki_button |
| `lib/screens/setup/values_screen.dart` | theme, ithaki_app_bar, ithaki_button |

In each file: remove all lines matching `import '../../theme/...`, `import '../../widgets/...`, `import '../../models/search_item.dart'`, or `import '../theme/...` and add:

```dart
import 'package:ithaki_design_system/ithaki_design_system.dart';
```

- [ ] **Step 1: Update `lib/main.dart`**

Replace `import 'theme/ithaki_theme.dart';` with `import 'package:ithaki_design_system/ithaki_design_system.dart';`

- [ ] **Step 2: Update all auth screens**

In each file under `lib/screens/auth/`, remove all `import '../../theme/...`, `import '../../widgets/...`, and `import 'package:flutter_svg/flutter_svg.dart'` lines and add the single package import.

**Special case — `register_screen.dart`:** This file imports `flutter_svg` directly and uses `SvgPicture.asset` inline in the `_GoogleLogo` widget. Replace the entire `_GoogleLogo` class with:

```dart
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return IthakiIcon('google-social', size: size);
  }
}
```

Also remove the `import 'package:flutter_svg/flutter_svg.dart';` line from this file.

- [ ] **Step 3: Update all setup screens**

In each file under `lib/screens/setup/`, remove all `import '../../theme/...`, `import '../../widgets/...`, and `import '../../models/search_item.dart'` lines and add the single package import.

- [ ] **Step 4: Add `onLoginPressed` to AppBar call sites**

The 6 auth screens that use `IthakiAppBar(showLogin: true)` need `onLoginPressed` wired up, otherwise the Login button is permanently disabled. In each of these files, update the `IthakiAppBar` constructor call:

- `select_language_screen.dart` — `IthakiAppBar(showLogin: true, onLoginPressed: () => context.go('/login'))`
- `register_screen.dart` — same
- `personal_details_screen.dart` — same
- `verify_email_screen.dart` — same
- `verify_otp_screen.dart` — same
- `tech_comfort_screen.dart` — same

Note: screens using `showLogin: false` or `showMenuAndAvatar: true` do not need `onLoginPressed`.

- [ ] **Step 5: Run flutter analyze to check for errors**

```bash
cd /c/Users/User/Desktop/Ithaki && flutter analyze
```

Expected: no errors. Fix any remaining import issues reported.

- [ ] **Step 6: Verify the app builds**

```bash
cd /c/Users/User/Desktop/Ithaki && flutter build apk --debug 2>&1 | tail -5
```

Expected: `Built build/app/outputs/flutter-apk/app-debug.apk`

- [ ] **Step 7: Commit**

```bash
cd /c/Users/User/Desktop/Ithaki
git add lib/
git commit -m "refactor: update all imports to use ithaki_design_system package"
```

---

## Task 13: Push ithaki_ui to GitHub

- [ ] **Step 1: Create GitHub repo for ithaki_ui**

Go to https://github.com/new and create a repo named `ithaki-ui` (empty, no init files).

- [ ] **Step 2: Push**

```bash
cd /c/Users/User/Desktop/Ithaki
git remote add origin https://github.com/TU_USUARIO/ithaki-ui.git
git branch -M main
git push -u origin main
```

- [ ] **Step 3: Share `ithaki_design_system` repo URL with teammate**

Your teammate adds this to their `pubspec.yaml`:

```yaml
ithaki_design_system:
  git:
    url: https://github.com/TU_USUARIO/ithaki_design_system.git
    ref: v0.1.0
```

Then runs `flutter pub get`. Done.

---

## Workflow reminder for the team

When you update the design system:
1. Make changes in `ithaki_design_system/`
2. Commit + push to GitHub
3. Create a new tag: `git tag v0.1.1 && git push origin v0.1.1`
4. Both projects update their `ref:` in `pubspec.yaml` and run `flutter pub upgrade`
