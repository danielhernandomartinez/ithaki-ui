# Employer / NGO Sign-Up Flow — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an employer/NGO registration and onboarding flow that branches from `SelectLanguageScreen`, parallel to the existing job seeker flow.

**Architecture:** Param-based reuse of `RegisterScreen` (`isEmployer` flag changes email label) and `ValuesScreen` (`isEmployer` flag adds "Skip for now" and employer copy). Three new screens (`UserTypeSelectionScreen`, `EmployerTypeSelectionScreen`, `EmployerSetupScreen`) plus a new provider (`employerSetupProvider`). `SelectLanguageScreen` navigation target changes from `/tech-comfort` to `/user-type`.

**Tech Stack:** Flutter 3.x, Dart 3.x, Riverpod 3 (Notifier), GoRouter 17, ithaki_design_system

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `lib/models/employer_models.dart` | `EmployerType` enum, `EmployerSetupState` |
| Modify | `lib/providers/registration_provider.dart` | Add `isEmployer`, `employerType` fields |
| Create | `lib/providers/employer_setup_provider.dart` | `employerSetupProvider` Notifier |
| Modify | `lib/routes.dart` | 4 new route constants |
| Create | `lib/screens/auth/user_type_selection_screen.dart` | Job Seeker vs Employer/NGO choice |
| Create | `lib/screens/auth/employer_type_selection_screen.dart` | Employer Company vs NGO choice |
| Modify | `lib/screens/auth/register_screen.dart` | Accept `isEmployer` param, change email label |
| Create | `lib/screens/employer/employer_setup_screen.dart` | 4-tab questionnaire |
| Modify | `lib/screens/setup/values_screen.dart` | Accept `isEmployer` param, add Skip button |
| Modify | `lib/l10n/app_en.arb` | New localization keys |
| Modify | `lib/router.dart` | New GoRoutes + update RegisterScreen + unguarded routes |
| Modify | `lib/screens/auth/select_language_screen.dart` | Navigate to `/user-type` instead of `/tech-comfort` |
| Create | `test/screens/auth/user_type_selection_screen_test.dart` | Widget tests |
| Create | `test/screens/auth/employer_type_selection_screen_test.dart` | Widget tests |

---

## Task 1: Models — EmployerType enum + EmployerSetupState

**Files:**
- Create: `lib/models/employer_models.dart`

- [ ] **Step 1: Create the file**

```dart
// lib/models/employer_models.dart

enum EmployerType { employerCompany, ngo }

class EmployerSetupState {
  // Admin Details
  final String adminName;
  final String adminLastName;
  final String adminPhone;
  final String adminRole;
  // Company Details
  final String legalName;
  final String industry;
  final String companySize;
  // Contact Details
  final String address;
  final String city;
  final String contactEmail;
  final String contactPhone;
  final String website;
  // Profile & Branding
  final String? logoPath;
  final String aboutCompany;
  // Values
  final Set<String> values;
  // Meta
  final EmployerType type;

  const EmployerSetupState({
    this.adminName = '',
    this.adminLastName = '',
    this.adminPhone = '',
    this.adminRole = '',
    this.legalName = '',
    this.industry = '',
    this.companySize = '',
    this.address = '',
    this.city = '',
    this.contactEmail = '',
    this.contactPhone = '',
    this.website = '',
    this.logoPath,
    this.aboutCompany = '',
    this.values = const {},
    this.type = EmployerType.employerCompany,
  });

  EmployerSetupState copyWith({
    String? adminName,
    String? adminLastName,
    String? adminPhone,
    String? adminRole,
    String? legalName,
    String? industry,
    String? companySize,
    String? address,
    String? city,
    String? contactEmail,
    String? contactPhone,
    String? website,
    String? logoPath,
    String? aboutCompany,
    Set<String>? values,
    EmployerType? type,
  }) {
    return EmployerSetupState(
      adminName: adminName ?? this.adminName,
      adminLastName: adminLastName ?? this.adminLastName,
      adminPhone: adminPhone ?? this.adminPhone,
      adminRole: adminRole ?? this.adminRole,
      legalName: legalName ?? this.legalName,
      industry: industry ?? this.industry,
      companySize: companySize ?? this.companySize,
      address: address ?? this.address,
      city: city ?? this.city,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      logoPath: logoPath ?? this.logoPath,
      aboutCompany: aboutCompany ?? this.aboutCompany,
      values: values ?? this.values,
      type: type ?? this.type,
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/models/employer_models.dart
git commit -m "feat(employer): add EmployerType enum and EmployerSetupState model"
```

---

## Task 2: employerSetupProvider

**Files:**
- Create: `lib/providers/employer_setup_provider.dart`

- [ ] **Step 1: Create the provider**

```dart
// lib/providers/employer_setup_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/employer_models.dart';

class EmployerSetupNotifier extends Notifier<EmployerSetupState> {
  @override
  EmployerSetupState build() => const EmployerSetupState();

  void setType(EmployerType type) =>
      state = state.copyWith(type: type);

  void setAdminDetails({
    required String name,
    required String lastName,
    required String phone,
    required String role,
  }) =>
      state = state.copyWith(
        adminName: name,
        adminLastName: lastName,
        adminPhone: phone,
        adminRole: role,
      );

  void setCompanyDetails({
    required String legalName,
    required String industry,
    required String companySize,
  }) =>
      state = state.copyWith(
        legalName: legalName,
        industry: industry,
        companySize: companySize,
      );

  void setContactDetails({
    required String address,
    required String city,
    required String contactEmail,
    required String contactPhone,
    String website = '',
  }) =>
      state = state.copyWith(
        address: address,
        city: city,
        contactEmail: contactEmail,
        contactPhone: contactPhone,
        website: website,
      );

  void setBranding({String? logoPath, required String aboutCompany}) =>
      state = state.copyWith(
        logoPath: logoPath,
        aboutCompany: aboutCompany,
      );

  void setValues(Set<String> values) =>
      state = state.copyWith(values: values);

  void reset() => state = const EmployerSetupState();
}

final employerSetupProvider =
    NotifierProvider<EmployerSetupNotifier, EmployerSetupState>(
  EmployerSetupNotifier.new,
);
```

- [ ] **Step 2: Commit**

```bash
git add lib/providers/employer_setup_provider.dart
git commit -m "feat(employer): add employerSetupProvider"
```

---

## Task 3: Extend RegistrationState with employer fields

**Files:**
- Modify: `lib/providers/registration_provider.dart`

- [ ] **Step 1: Add import and fields to RegistrationState**

Add this import at the top:
```dart
import '../models/employer_models.dart';
```

Replace the `RegistrationState` class and `RegistrationNotifier` with:
```dart
class RegistrationState {
  final String language;
  final String techLevel;
  final String email;
  final String password;
  final String name;
  final String lastName;
  final String phone;
  final String verifyMethod;
  final bool rememberVerifyChoice;
  final bool isEmployer;
  final EmployerType? employerType;

  const RegistrationState({
    this.language = '',
    this.techLevel = '',
    this.email = '',
    this.password = '',
    this.name = '',
    this.lastName = '',
    this.phone = '',
    this.verifyMethod = '',
    this.rememberVerifyChoice = false,
    this.isEmployer = false,
    this.employerType,
  });

  RegistrationState copyWith({
    String? language,
    String? techLevel,
    String? email,
    String? password,
    String? name,
    String? lastName,
    String? phone,
    String? verifyMethod,
    bool? rememberVerifyChoice,
    bool? isEmployer,
    EmployerType? employerType,
  }) {
    return RegistrationState(
      language: language ?? this.language,
      techLevel: techLevel ?? this.techLevel,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      verifyMethod: verifyMethod ?? this.verifyMethod,
      rememberVerifyChoice: rememberVerifyChoice ?? this.rememberVerifyChoice,
      isEmployer: isEmployer ?? this.isEmployer,
      employerType: employerType ?? this.employerType,
    );
  }
}

class RegistrationNotifier extends Notifier<RegistrationState> {
  @override
  RegistrationState build() => const RegistrationState();

  void setLanguage(String language) =>
      state = state.copyWith(language: language);

  void setTechLevel(String level) =>
      state = state.copyWith(techLevel: level);

  void setCredentials(String email, String password) =>
      state = state.copyWith(email: email, password: password);

  void setPersonalDetails(String name, String lastName, String phone) =>
      state = state.copyWith(name: name, lastName: lastName, phone: phone);

  void setVerifyMethod(String method, {bool remember = false}) =>
      state = state.copyWith(verifyMethod: method, rememberVerifyChoice: remember);

  void setIsEmployer(bool value) =>
      state = state.copyWith(isEmployer: value);

  void setEmployerType(EmployerType type) =>
      state = state.copyWith(employerType: type);

  void reset() => state = const RegistrationState();
}

final registrationProvider =
    NotifierProvider<RegistrationNotifier, RegistrationState>(
  RegistrationNotifier.new,
);
```

- [ ] **Step 2: Run existing tests to confirm nothing broke**

```bash
flutter test test/providers/provider_test.dart
```

Expected: all pass.

- [ ] **Step 3: Commit**

```bash
git add lib/providers/registration_provider.dart
git commit -m "feat(employer): extend RegistrationState with isEmployer and employerType"
```

---

## Task 4: Add route constants

**Files:**
- Modify: `lib/routes.dart`

- [ ] **Step 1: Add 5 constants to the Routes class, after the `welcome` constant**

```dart
  // Employer sign-up
  static const userTypeSelection = '/user-type';
  static const employerTypeSelection = '/employer-type';
  static const registerEmployer = '/employer/register';
  static const employerSetup = '/employer/setup';
  static const employerSetupValues = '/employer/setup/values';
```

- [ ] **Step 2: Commit**

```bash
git add lib/routes.dart
git commit -m "feat(employer): add employer route constants"
```

---

## Task 5: Localization strings

**Files:**
- Modify: `lib/l10n/app_en.arb`

- [ ] **Step 1: Add employer strings after the `techNewSubtitle` key**

```json
  "userTypeTitle": "Select your account type",
  "userTypeDescription": "Select the option that best describes you to continue with registration.",
  "userTypeJobSeekerLabel": "I'm a Job Seeker",
  "userTypeJobSeekerSubtitle": "You're looking for job opportunities. Create a talent profile to apply for jobs and connect with employers.",
  "userTypeEmployerLabel": "We are an Employer or NGO",
  "userTypeEmployerSubtitle": "You're looking for talent or coordinating candidates. Create an organization account to post jobs and manage applications.",

  "employerTypeTitle": "Select your account type",
  "employerTypeDescription": "Select the option that best describes your organization to continue with registration.",
  "employerCompanyLabel": "We are Employer Company",
  "employerCompanySubtitle": "You're looking for skilled professionals to join your team. Create a company account to post jobs, manage applications, and connect with top talent.",
  "employerNgoLabel": "We are Non-Profit Organization",
  "employerNgoSubtitle": "You're making social impact through meaningful projects. Create an organization account to coordinate your dedicated candidates and grow your community.",

  "workEmailLabel": "Work Email",

  "employerSetupAdminTab": "Admin Details",
  "employerSetupCompanyTab": "Company Details",
  "employerSetupContactsTab": "Contacts",
  "employerSetupBrandingTab": "Profile & Branding",

  "employerAdminHeading": "Account created",
  "employerAdminDescription": "Great! Profile setup is next — let’s make candidates search easier and faster.",
  "adminRoleLabel": "Role",
  "adminRoleHint": "Select your Role",

  "employerCompanyHeading": "Company Details",
  "employerCompanyDescription": "Add core information about your business. Make sure these details match your company’s legal documents.",
  "legalCompanyNameLabel": "Legal Company Name",
  "legalCompanyNameHint": "Enter legal company Name",
  "businessIndustryLabel": "Business Industry",
  "businessIndustryHint": "Select your business industry",
  "companySizeLabel": "Company Size",
  "companySizeHint": "Select your company size",

  "employerContactsHeading": "Contact Details",
  "employerContactsDescription": "Share contact details for communication and verification purposes.",
  "registeredAddressLabel": "Registered Address",
  "registeredAddressHint": "Enter registered Address",
  "contactEmailLabel": "Contact Email",
  "contactEmailHint": "Enter your email",
  "contactEmailHelper": "Contact email for candidates",
  "contactPhoneLabel": "Contact Phone Number",
  "contactPhoneHint": "+30 XXX XXX XX XX",
  "contactPhoneHelper": "Contact phone for candidates",
  "companyWebsiteLabel": "Company Website (optional)",
  "companyWebsiteHint": "Enter company website",

  "employerBrandingHeading": "Profile & Branding",
  "employerBrandingDescription": "Add your logo and company details to complete your profile. You can update this anytime in Profile Settings.",
  "skipForNow": "Skip for now",
  "uploadPhotoLabel": "Upload Photo",
  "uploadPhotoDescription": "Upload a square logo (PNG, JPG, JPEG, or SVG) up to 2 MB, at least 400×400 px, preferably with a transparent background.",
  "aboutCompanyLabel": "About Company",
  "aboutCompanyDescription": "Describe your company’s mission, values, and main activities in a few sentences.",
  "aboutCompanyHint": "Add company description",

  "employerValuesDescription": "Select up to 5 values that best reflect your company culture. We use them to match you with like-minded talents. You can update this anytime in Profile Settings."
```

- [ ] **Step 2: Run flutter gen-l10n to regenerate**

```bash
flutter gen-l10n
```

Expected: no errors, `lib/l10n/app_localizations.dart` updated.

- [ ] **Step 3: Commit**

```bash
git add lib/l10n/app_en.arb lib/l10n/
git commit -m "feat(employer): add employer localization strings"
```

---

## Task 6: UserTypeSelectionScreen

**Files:**
- Create: `lib/screens/auth/user_type_selection_screen.dart`
- Create: `test/screens/auth/user_type_selection_screen_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/screens/auth/user_type_selection_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/user_type_selection_screen.dart';

GoRouter _router() => GoRouter(
      initialLocation: Routes.userTypeSelection,
      routes: [
        GoRoute(
          path: Routes.userTypeSelection,
          builder: (_, __) => const UserTypeSelectionScreen(),
        ),
        GoRoute(
          path: Routes.techComfort,
          builder: (_, __) => const Scaffold(body: Text('tech-comfort')),
        ),
        GoRoute(
          path: Routes.employerTypeSelection,
          builder: (_, __) => const Scaffold(body: Text('employer-type')),
        ),
      ],
    );

Widget _buildApp(GoRouter router) => ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );

ButtonStyleButton _continueButton(WidgetTester tester) {
  final ancestor = find
      .ancestor(
        of: find.text('Continue'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      )
      .first;
  return tester.widget<ButtonStyleButton>(ancestor);
}

void main() {
  group('UserTypeSelectionScreen', () {
    testWidgets('shows job seeker and employer cards', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(find.text("I'm a Job Seeker"), findsOneWidget);
      expect(find.text('We are an Employer or NGO'), findsOneWidget);
    });

    testWidgets('Continue is disabled before selection', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(_continueButton(tester).onPressed, isNull);
    });

    testWidgets('Continue enables after tapping Job Seeker', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("I'm a Job Seeker"));
      await tester.pump();

      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('Continue enables after tapping Employer', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are an Employer or NGO'));
      await tester.pump();

      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('Job Seeker selection navigates to tech-comfort', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("I'm a Job Seeker"));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('tech-comfort'), findsOneWidget);
    });

    testWidgets('Employer selection navigates to employer-type', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are an Employer or NGO'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('employer-type'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to confirm it fails**

```bash
flutter test test/screens/auth/user_type_selection_screen_test.dart
```

Expected: FAIL — `UserTypeSelectionScreen` not found.

- [ ] **Step 3: Implement UserTypeSelectionScreen**

```dart
// lib/screens/auth/user_type_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/registration_provider.dart';
import '../../routes.dart';

enum _UserType { jobSeeker, employer }

class UserTypeSelectionScreen extends ConsumerStatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  ConsumerState<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState
    extends ConsumerState<UserTypeSelectionScreen> {
  _UserType? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.loginAction,
        onActionPressed: () => context.go(Routes.loginPhone),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 20),
          Text(l.userTypeTitle, style: IthakiTheme.sectionTitle),
          const SizedBox(height: 8),
          Text(l.userTypeDescription, style: IthakiTheme.bodyRegular),
          const SizedBox(height: 24),
          IthakiOptionCard(
            label: l.userTypeJobSeekerLabel,
            subtitle: l.userTypeJobSeekerSubtitle,
            isSelected: _selected == _UserType.jobSeeker,
            onTap: () => setState(() => _selected = _UserType.jobSeeker),
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            label: l.userTypeEmployerLabel,
            subtitle: l.userTypeEmployerSubtitle,
            isSelected: _selected == _UserType.employer,
            onTap: () => setState(() => _selected = _UserType.employer),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _selected != null,
            onPressed: _selected != null
                ? () {
                    final isEmployer = _selected == _UserType.employer;
                    ref
                        .read(registrationProvider.notifier)
                        .setIsEmployer(isEmployer);
                    if (isEmployer) {
                      context.push(Routes.employerTypeSelection);
                    } else {
                      context.push(Routes.techComfort);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to confirm it passes**

```bash
flutter test test/screens/auth/user_type_selection_screen_test.dart
```

Expected: all 6 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/screens/auth/user_type_selection_screen.dart test/screens/auth/user_type_selection_screen_test.dart
git commit -m "feat(employer): add UserTypeSelectionScreen"
```

---

## Task 7: EmployerTypeSelectionScreen

**Files:**
- Create: `lib/screens/auth/employer_type_selection_screen.dart`
- Create: `test/screens/auth/employer_type_selection_screen_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/screens/auth/employer_type_selection_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/employer_type_selection_screen.dart';

GoRouter _router() => GoRouter(
      initialLocation: Routes.employerTypeSelection,
      routes: [
        GoRoute(
          path: Routes.employerTypeSelection,
          builder: (_, __) => const EmployerTypeSelectionScreen(),
        ),
        GoRoute(
          path: Routes.registerEmployer,
          builder: (_, __) => const Scaffold(body: Text('register-screen')),
        ),
      ],
    );

Widget _buildApp(GoRouter router) => ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );

ButtonStyleButton _continueButton(WidgetTester tester) {
  final ancestor = find
      .ancestor(
        of: find.text('Continue'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      )
      .first;
  return tester.widget<ButtonStyleButton>(ancestor);
}

void main() {
  group('EmployerTypeSelectionScreen', () {
    testWidgets('shows employer company and NGO cards', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(find.text('We are Employer Company'), findsOneWidget);
      expect(find.text('We are Non-Profit Organization'), findsOneWidget);
    });

    testWidgets('Continue is disabled before selection', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(_continueButton(tester).onPressed, isNull);
    });

    testWidgets('Continue enables after selecting a type', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are Employer Company'));
      await tester.pump();

      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('Continue navigates to register screen', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are Employer Company'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('register-screen'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to confirm it fails**

```bash
flutter test test/screens/auth/employer_type_selection_screen_test.dart
```

Expected: FAIL — `EmployerTypeSelectionScreen` not found.

- [ ] **Step 3: Implement EmployerTypeSelectionScreen**

```dart
// lib/screens/auth/employer_type_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../models/employer_models.dart';
import '../../providers/registration_provider.dart';
import '../../providers/employer_setup_provider.dart';
import '../../routes.dart';

class EmployerTypeSelectionScreen extends ConsumerStatefulWidget {
  const EmployerTypeSelectionScreen({super.key});

  @override
  ConsumerState<EmployerTypeSelectionScreen> createState() =>
      _EmployerTypeSelectionScreenState();
}

class _EmployerTypeSelectionScreenState
    extends ConsumerState<EmployerTypeSelectionScreen> {
  EmployerType? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.loginAction,
        onActionPressed: () => context.go(Routes.loginPhone),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiBackLink(onTap: () => context.pop()),
          const SizedBox(height: 16),
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 20),
          Text(l.employerTypeTitle, style: IthakiTheme.sectionTitle),
          const SizedBox(height: 8),
          Text(l.employerTypeDescription, style: IthakiTheme.bodyRegular),
          const SizedBox(height: 24),
          IthakiOptionCard(
            label: l.employerCompanyLabel,
            subtitle: l.employerCompanySubtitle,
            isSelected: _selected == EmployerType.employerCompany,
            onTap: () =>
                setState(() => _selected = EmployerType.employerCompany),
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            label: l.employerNgoLabel,
            subtitle: l.employerNgoSubtitle,
            isSelected: _selected == EmployerType.ngo,
            onTap: () => setState(() => _selected = EmployerType.ngo),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _selected != null,
            onPressed: _selected != null
                ? () {
                    ref
                        .read(registrationProvider.notifier)
                        .setEmployerType(_selected!);
                    ref
                        .read(employerSetupProvider.notifier)
                        .setType(_selected!);
                    context.push(Routes.registerEmployer);
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to confirm it passes**

```bash
flutter test test/screens/auth/employer_type_selection_screen_test.dart
```

Expected: all 4 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/screens/auth/employer_type_selection_screen.dart test/screens/auth/employer_type_selection_screen_test.dart
git commit -m "feat(employer): add EmployerTypeSelectionScreen"
```

---

## Task 8: Modify RegisterScreen — add isEmployer param

**Files:**
- Modify: `lib/screens/auth/register_screen.dart`

- [ ] **Step 1: Add `isEmployer` constructor param**

Change the class declaration and constructor:
```dart
class RegisterScreen extends ConsumerStatefulWidget {
  final bool isEmployer;
  const RegisterScreen({super.key, this.isEmployer = false});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}
```

- [ ] **Step 2: Pass `isEmployer` to state via `widget.isEmployer`**

In `_RegisterScreenState.build`, change the email `IthakiTextField` label:
```dart
IthakiTextField(
  label: widget.isEmployer ? l.workEmailLabel : l.emailLabel,
  hint: l.emailHint,
  controller: _emailController,
  // ... rest unchanged
),
```

- [ ] **Step 3: Change post-register navigation for employer**

In the Continue button `onPressed`:
```dart
onPressed: _canContinue
    ? () {
        ref.read(registrationProvider.notifier).setCredentials(
            _emailController.text, _passwordController.text);
        if (widget.isEmployer) {
          context.push(Routes.employerSetup);
        } else {
          context.push(Routes.personalDetails);
        }
      }
    : null,
```

- [ ] **Step 4: Run existing register tests if any, plus full test suite**

```bash
flutter test
```

Expected: all pass.

- [ ] **Step 5: Commit**

```bash
git add lib/screens/auth/register_screen.dart
git commit -m "feat(employer): add isEmployer param to RegisterScreen"
```

---

## Task 10: Modify ValuesScreen — add isEmployer param

**Files:**
- Modify: `lib/screens/setup/values_screen.dart`

- [ ] **Step 1: Add `isEmployer` constructor param**

```dart
class ValuesScreen extends ConsumerStatefulWidget {
  final bool isEmployer;
  const ValuesScreen({super.key, this.isEmployer = false});

  @override
  ConsumerState<ValuesScreen> createState() => _ValuesScreenState();
}
```

- [ ] **Step 2: Add "Skip for now" button and employer subtitle**

In `_ValuesScreenState.build`, after the subtitle `Text` and before the chip group, add:
```dart
if (widget.isEmployer) ...[
  const SizedBox(height: 12),
  TextButton(
    onPressed: () => context.go(Routes.home),
    child: Text(l.skipForNow,
        style: IthakiTheme.bodyRegular.copyWith(
          decoration: TextDecoration.underline,
        )),
  ),
],
```

Change the subtitle `Text` to use employer copy when `isEmployer`:
```dart
Text(
  widget.isEmployer
      ? l.employerValuesDescription
      : l.valuesDescription(_maxValues),
  style: IthakiTheme.bodyRegular,
),
```

- [ ] **Step 3: Change Continue navigation for employer**

In the Continue button `onPressed`:
```dart
onPressed: _selected.isNotEmpty
    ? () {
        if (widget.isEmployer) {
          ref
              .read(employerSetupProvider.notifier)
              .setValues(Set.of(_selected));
          context.go(Routes.home);
        } else {
          ref.read(setupProvider.notifier).setValues(Set.of(_selected));
          context.push(Routes.setupCommunication);
        }
      }
    : null,
```

Add import at top:
```dart
import '../../providers/employer_setup_provider.dart';
```

- [ ] **Step 4: Remove the IthakiStepTabs header when isEmployer (employer has its own progress bar in EmployerSetupScreen)**

In the `IthakiStepTabs` widget, wrap with a condition:
```dart
if (!widget.isEmployer)
  IthakiStepTabs(
    steps: [l.stepLocation, l.stepJobInterests, l.stepPreferences, l.stepValues, l.stepCommunication],
    currentIndex: 3,
    completedUpTo: 2,
  ),
```

- [ ] **Step 5: Commit**

```bash
git add lib/screens/setup/values_screen.dart
git commit -m "feat(employer): add isEmployer param to ValuesScreen"
```

---

## Task 11: EmployerSetupScreen (4-tab questionnaire)

**Files:**
- Create: `lib/screens/employer/employer_setup_screen.dart`

- [ ] **Step 1: Create the screen with all 4 tabs**

```dart
// lib/screens/employer/employer_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/employer_setup_provider.dart';
import '../../routes.dart';

const _adminRoles = [
  'CEO / Founder',
  'HR Manager',
  'Recruiter',
  'Operations Manager',
  'Other',
];

const _industries = [
  'Technology',
  'Healthcare',
  'Education',
  'Finance',
  'Retail',
  'Manufacturing',
  'Non-profit',
  'Other',
];

const _companySizes = [
  '1–10',
  '11–50',
  '51–200',
  '201–500',
  '500+',
];

class EmployerSetupScreen extends ConsumerStatefulWidget {
  const EmployerSetupScreen({super.key});

  @override
  ConsumerState<EmployerSetupScreen> createState() =>
      _EmployerSetupScreenState();
}

class _EmployerSetupScreenState extends ConsumerState<EmployerSetupScreen> {
  int _currentTab = 0;

  // Tab 1 — Admin Details
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _adminRole;

  // Tab 2 — Company Details
  final _legalNameCtrl = TextEditingController();
  String? _industry;
  String? _companySize;

  // Tab 3 — Contact Details
  final _addressCtrl = TextEditingController();
  String _city = '';
  final _contactEmailCtrl = TextEditingController();
  final _contactPhoneCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  // Tab 4 — Profile & Branding
  final _aboutCtrl = TextEditingController();
  String? _logoPath;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _legalNameCtrl.dispose();
    _addressCtrl.dispose();
    _contactEmailCtrl.dispose();
    _contactPhoneCtrl.dispose();
    _websiteCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  bool get _tab0Valid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _lastNameCtrl.text.trim().isNotEmpty &&
      _phoneCtrl.text.trim().isNotEmpty &&
      _adminRole != null;

  bool get _tab1Valid =>
      _legalNameCtrl.text.trim().isNotEmpty &&
      _industry != null &&
      _companySize != null;

  bool get _tab2Valid =>
      _addressCtrl.text.trim().isNotEmpty &&
      _city.isNotEmpty &&
      _contactEmailCtrl.text.contains('@') &&
      _contactPhoneCtrl.text.trim().isNotEmpty;

  void _saveAndAdvance() {
    final notifier = ref.read(employerSetupProvider.notifier);
    switch (_currentTab) {
      case 0:
        notifier.setAdminDetails(
          name: _nameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          role: _adminRole!,
        );
      case 1:
        notifier.setCompanyDetails(
          legalName: _legalNameCtrl.text.trim(),
          industry: _industry!,
          companySize: _companySize!,
        );
      case 2:
        notifier.setContactDetails(
          address: _addressCtrl.text.trim(),
          city: _city,
          contactEmail: _contactEmailCtrl.text.trim(),
          contactPhone: _contactPhoneCtrl.text.trim(),
          website: _websiteCtrl.text.trim(),
        );
      case 3:
        notifier.setBranding(
          logoPath: _logoPath,
          aboutCompany: _aboutCtrl.text.trim(),
        );
        context.push(Routes.employerSetupValues);
        return;
    }
    setState(() => _currentTab++);
  }

  bool get _currentTabValid => switch (_currentTab) {
        0 => _tab0Valid,
        1 => _tab1Valid,
        2 => _tab2Valid,
        _ => true, // branding tab has all optional fields
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final steps = [
      l.employerSetupAdminTab,
      l.employerSetupCompanyTab,
      l.employerSetupContactsTab,
      l.employerSetupBrandingTab,
    ];

    return IthakiScreenLayout(
      appBar: const IthakiAppBar(showMenuAndAvatar: false),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiStepTabs(
            steps: steps,
            currentIndex: _currentTab,
            completedUpTo: _currentTab - 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: [
                _AdminDetailsTab(
                  nameCtrl: _nameCtrl,
                  lastNameCtrl: _lastNameCtrl,
                  phoneCtrl: _phoneCtrl,
                  adminRole: _adminRole,
                  onRoleChanged: (v) => setState(() => _adminRole = v),
                  onChanged: () => setState(() {}),
                ),
                _CompanyDetailsTab(
                  legalNameCtrl: _legalNameCtrl,
                  industry: _industry,
                  companySize: _companySize,
                  onIndustryChanged: (v) => setState(() => _industry = v),
                  onSizeChanged: (v) => setState(() => _companySize = v),
                  onChanged: () => setState(() {}),
                ),
                _ContactDetailsTab(
                  addressCtrl: _addressCtrl,
                  city: _city,
                  contactEmailCtrl: _contactEmailCtrl,
                  contactPhoneCtrl: _contactPhoneCtrl,
                  websiteCtrl: _websiteCtrl,
                  onCityChanged: (v) => setState(() => _city = v),
                  onChanged: () => setState(() {}),
                ),
                _BrandingTab(
                  aboutCtrl: _aboutCtrl,
                  logoPath: _logoPath,
                  onLogoChanged: (v) => setState(() => _logoPath = v),
                  onSkip: () => context.push(Routes.employerSetupValues),
                ),
              ][_currentTab],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                IthakiButton(
                  _currentTab == 3 ? l.continueButton : l.continueButton,
                  isEnabled: _currentTabValid,
                  onPressed: _currentTabValid ? _saveAndAdvance : null,
                ),
                if (_currentTab > 0) ...[
                  const SizedBox(height: 12),
                  IthakiButton(
                    l.backButton,
                    variant: IthakiButtonVariant.outline,
                    onPressed: () => setState(() => _currentTab--),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tab widgets ───────────────────────────────────────────────────────────────

class _AdminDetailsTab extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final String? adminRole;
  final ValueChanged<String?> onRoleChanged;
  final VoidCallback onChanged;

  const _AdminDetailsTab({
    required this.nameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.adminRole,
    required this.onRoleChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerAdminHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerAdminDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 24),
        IthakiTextField(
          label: l.nameLabel,
          hint: l.nameHint,
          controller: nameCtrl,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.lastNameLabel,
          hint: l.lastNameHint,
          controller: lastNameCtrl,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.phoneLabel,
          hint: '+XX XXX XXX XX XX',
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        IthakiSelectorField(
          label: l.adminRoleLabel,
          value: adminRole,
          placeholder: l.adminRoleHint,
          options: _adminRoles,
          onSelected: onRoleChanged,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CompanyDetailsTab extends StatelessWidget {
  final TextEditingController legalNameCtrl;
  final String? industry;
  final String? companySize;
  final ValueChanged<String?> onIndustryChanged;
  final ValueChanged<String?> onSizeChanged;
  final VoidCallback onChanged;

  const _CompanyDetailsTab({
    required this.legalNameCtrl,
    required this.industry,
    required this.companySize,
    required this.onIndustryChanged,
    required this.onSizeChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerCompanyHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerCompanyDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 24),
        IthakiTextField(
          label: l.legalCompanyNameLabel,
          hint: l.legalCompanyNameHint,
          controller: legalNameCtrl,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        IthakiSelectorField(
          label: l.businessIndustryLabel,
          value: industry,
          placeholder: l.businessIndustryHint,
          options: _industries,
          onSelected: onIndustryChanged,
        ),
        const SizedBox(height: 16),
        IthakiSelectorField(
          label: l.companySizeLabel,
          value: companySize,
          placeholder: l.companySizeHint,
          options: _companySizes,
          onSelected: onSizeChanged,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ContactDetailsTab extends StatelessWidget {
  final TextEditingController addressCtrl;
  final String city;
  final TextEditingController contactEmailCtrl;
  final TextEditingController contactPhoneCtrl;
  final TextEditingController websiteCtrl;
  final ValueChanged<String> onCityChanged;
  final VoidCallback onChanged;

  const _ContactDetailsTab({
    required this.addressCtrl,
    required this.city,
    required this.contactEmailCtrl,
    required this.contactPhoneCtrl,
    required this.websiteCtrl,
    required this.onCityChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerContactsHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerContactsDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 24),
        IthakiTextField(
          label: l.registeredAddressLabel,
          hint: l.registeredAddressHint,
          controller: addressCtrl,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => CitySearchBottomSheet.show(
            context,
            onSelected: (city) => onCityChanged(city),
          ),
          child: AbsorbPointer(
            child: IthakiTextField(
              label: l.cityLabel,
              hint: l.cityHint,
              controller: TextEditingController(text: city),
              suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: IthakiIcon('flag', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.contactEmailLabel,
          hint: l.contactEmailHint,
          helperText: l.contactEmailHelper,
          controller: contactEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: IthakiIcon('envelope', size: 20,
                color: IthakiTheme.softGraphite),
          ),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.contactPhoneLabel,
          hint: l.contactPhoneHint,
          helperText: l.contactPhoneHelper,
          controller: contactPhoneCtrl,
          keyboardType: TextInputType.phone,
          suffixIcon: const Padding(
            padding: EdgeInsets.all(12),
            child: IthakiIcon('phone', size: 20,
                color: IthakiTheme.softGraphite),
          ),
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 16),
        IthakiTextField(
          label: l.companyWebsiteLabel,
          hint: l.companyWebsiteHint,
          controller: websiteCtrl,
          keyboardType: TextInputType.url,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _BrandingTab extends StatelessWidget {
  final TextEditingController aboutCtrl;
  final String? logoPath;
  final ValueChanged<String?> onLogoChanged;
  final VoidCallback onSkip;

  const _BrandingTab({
    required this.aboutCtrl,
    required this.logoPath,
    required this.onLogoChanged,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.employerBrandingHeading, style: IthakiTheme.headingLarge),
        const SizedBox(height: 8),
        Text(l.employerBrandingDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onSkip,
          child: Text(l.skipForNow,
              style: IthakiTheme.bodyRegular
                  .copyWith(decoration: TextDecoration.underline)),
        ),
        const SizedBox(height: 16),
        Text(l.uploadPhotoLabel, style: IthakiTheme.sectionTitle),
        const SizedBox(height: 8),
        Text(l.uploadPhotoDescription,
            style: IthakiTheme.captionRegular
                .copyWith(color: IthakiTheme.textSecondary)),
        const SizedBox(height: 12),
        IthakiButton(
          l.uploadPhotoLabel,
          variant: IthakiButtonVariant.outline,
          onPressed: () {
            UploadFilesSheet.show(context, onFileSelected: (path) {
              onLogoChanged(path);
            });
          },
        ),
        const SizedBox(height: 24),
        Text(l.aboutCompanyLabel, style: IthakiTheme.sectionTitle),
        const SizedBox(height: 8),
        Text(l.aboutCompanyDescription, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 12),
        IthakiTextField(
          label: '',
          hint: l.aboutCompanyHint,
          controller: aboutCtrl,
          maxLines: 6,
          maxLength: 1000,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/screens/employer/employer_setup_screen.dart
git commit -m "feat(employer): add EmployerSetupScreen with 4-tab questionnaire"
```

---

## Task 12: Update router.dart

**Files:**
- Modify: `lib/router.dart`

- [ ] **Step 1: Add imports at top of router.dart**

After the existing imports, add:
```dart
import 'screens/auth/user_type_selection_screen.dart';
import 'screens/auth/employer_type_selection_screen.dart';
import 'screens/employer/employer_setup_screen.dart';
```

- [ ] **Step 2: Add new routes to `_unguardedRoutes` set**

```dart
static const _unguardedRoutes = {
  Routes.root,
  Routes.userTypeSelection,      // ADD
  Routes.techComfort,
  Routes.register,
  Routes.registerEmployer,       // ADD
  Routes.employerTypeSelection,  // ADD
  Routes.employerSetup,          // ADD
  Routes.employerSetupValues,    // ADD
  Routes.personalDetails,
  // ... rest unchanged
};
```

- [ ] **Step 3: Update the `/register` GoRoute to pass isEmployer**

Replace:
```dart
GoRoute(
  path: Routes.register,
  builder: (context, state) => const RegisterScreen(),
),
```

With:
```dart
GoRoute(
  path: Routes.register,
  builder: (context, state) => const RegisterScreen(),
),
GoRoute(
  path: Routes.registerEmployer,
  builder: (context, state) => const RegisterScreen(isEmployer: true),
),
```

- [ ] **Step 4: Add the new employer GoRoutes after the welcome route**

```dart
GoRoute(
  path: Routes.userTypeSelection,
  builder: (context, state) => const UserTypeSelectionScreen(),
),
GoRoute(
  path: Routes.employerTypeSelection,
  builder: (context, state) => const EmployerTypeSelectionScreen(),
),
GoRoute(
  path: Routes.employerSetup,
  builder: (context, state) => const EmployerSetupScreen(),
),
GoRoute(
  path: Routes.employerSetupValues,
  builder: (context, state) => const ValuesScreen(isEmployer: true),
),
```

- [ ] **Step 5: Update the existing setupValues route to be explicit**

The existing `/setup/values` route still passes `isEmployer: false` (default), so no change needed.

- [ ] **Step 6: Run full test suite**

```bash
flutter test
```

Expected: all pass.

- [ ] **Step 7: Commit**

```bash
git add lib/router.dart
git commit -m "feat(employer): wire employer routes in router"
```

---

## Task 13: Update SelectLanguageScreen navigation target

**Files:**
- Modify: `lib/screens/auth/select_language_screen.dart`

- [ ] **Step 1: Change both navigation calls from techComfort to userTypeSelection**

Find these two occurrences and replace:
```dart
context.push(Routes.techComfort);
```

Both become:
```dart
context.push(Routes.userTypeSelection);
```

There are two: one in the "Continue" button and one in the "Skip" button.

- [ ] **Step 2: Run app and verify the flow manually**

```bash
flutter run --dart-define=ITHAKI_API_BASE_URL=https://api.odyssea.com/talent/staging
```

Verify:
1. Select language → UserTypeSelectionScreen appears ✓
2. Select Job Seeker → TechComfortScreen appears ✓
3. Back to UserType → Select Employer/NGO → EmployerTypeSelectionScreen appears ✓
4. Select a type → RegisterScreen with "Work Email" label appears ✓
5. Fill register form → EmployerSetupScreen (Admin Details tab) appears ✓
6. Fill all 4 tabs → ValuesScreen with employer copy + "Skip for now" button appears ✓

- [ ] **Step 3: Commit**

```bash
git add lib/screens/auth/select_language_screen.dart
git commit -m "feat(employer): redirect language screen to user-type selection"
```

---

## Task 14: Final integration test run

- [ ] **Step 1: Run full test suite**

```bash
flutter test
```

Expected: all pass.

- [ ] **Step 2: Check for analysis warnings**

```bash
flutter analyze
```

Expected: no errors, no warnings on new files.

- [ ] **Step 3: Final commit if any fixes needed**

```bash
git add -A
git commit -m "fix(employer): address analysis warnings"
```

---

## Notes for the implementer

- `IthakiSelectorField` — check the design system export for exact constructor signature. If it takes `List<String>` for options, use it as shown. If it takes `List<SearchItem>`, convert the lists accordingly.
- `CitySearchBottomSheet.show` — check actual signature in `lib/widgets/city_search_bottom_sheet.dart`. Adapt the call in `_ContactDetailsTab` accordingly.
- `UploadFilesSheet.show` — check actual signature. The `onFileSelected` callback may differ.
- `IthakiTextField.helperText` — verify this param exists. If not, add a `Text` widget with `IthakiTheme.captionRegular` below the field.
- `phoneLabel` / `cityLabel` / `cityHint` — these may already exist in the ARB file from the job seeker setup screens. Do not add duplicate keys; use the existing ones.
