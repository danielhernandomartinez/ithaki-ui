# Employer / NGO Sign-Up Flow — Design Spec

**Date:** 2026-04-30  
**Status:** Approved  

---

## Overview

Add an employer/NGO registration and onboarding flow to Ithaki. Until now the app served only job seekers. A new role-selection screen branches the sign-up into two independent paths: job seeker (existing, unchanged) and employer/NGO (new).

---

## User Flow

```
/ → SelectLanguageScreen (existing)
      ↓
/user-type → UserTypeSelectionScreen [NEW]
      ├─ Job Seeker → /tech-comfort → existing flow (no changes)
      └─ Employer/NGO → /employer-type → EmployerTypeSelectionScreen [NEW]
                              ↓
                        /register?employer=true → RegisterScreen [REUSED, minor change]
                              ↓
                        /employer/setup → EmployerSetupScreen [NEW, multi-tab]
                           Tab 1: Admin Details
                           Tab 2: Company Details
                           Tab 3: Contact Details
                           Tab 4: Profile & Branding
                              ↓
                        /employer/setup/values → ValuesScreen [REUSED, minor change]
                              ↓
                        /home
```

---

## Architecture

### Approach: Param-based reuse

Minimal changes to existing screens via constructor params. New screens are fully independent. No shared state between job seeker and employer providers.

---

## State Management

New `employerSetupProvider` (`Notifier<EmployerSetupState>`) — completely separate from the existing `setupProvider`.

```dart
enum EmployerType { employerCompany, ngo }

class EmployerSetupState {
  // Admin Details
  final String name;
  final String lastName;
  final String phone;
  final String adminRole;        // admin's role within the company
  // Company Details
  final String legalName;
  final String industry;
  final String companySize;
  // Contact Details
  final String address;
  final String city;
  final String contactEmail;
  final String contactPhone;
  final String website;          // optional
  // Profile & Branding
  final String? logoPath;        // optional
  final String aboutCompany;     // optional, max 1000 chars
  // Values
  final List<String> values;     // max 5
  // Meta
  final EmployerType type;       // set from EmployerTypeSelectionScreen
}
```

`registrationProvider` gains two fields:
- `bool isEmployer` — set at `UserTypeSelectionScreen`
- `EmployerType? employerType` — set at `EmployerTypeSelectionScreen`

These tell `RegisterScreen` which label to show and tell the router where to redirect after registration.

---

## New Screens

### 1. `UserTypeSelectionScreen` (`/user-type`)

- Same visual pattern as `TechComfortScreen`: two selectable cards + "Continue" button
- Cards: "I'm a Job Seeker" / "We are an Employer or NGO"
- "Continue" disabled until one card selected
- On continue: sets `registrationProvider.isEmployer`, navigates to `/tech-comfort` or `/employer-type`
- File: `lib/screens/auth/user_type_selection_screen.dart`

### 2. `EmployerTypeSelectionScreen` (`/employer-type`)

- Same visual pattern as `UserTypeSelectionScreen`
- Cards: "We are Employer Company" / "We are Non-Profit Organization"
- On continue: sets `registrationProvider.employerType`, navigates to `/register?employer=true`
- File: `lib/screens/auth/employer_type_selection_screen.dart`

### 3. `EmployerSetupScreen` (`/employer/setup`)

- `ConsumerStatefulWidget`
- `IthakiStepTabs` with 4 tabs (same component used in job seeker setup)
- Each tab is a private widget in the same file
- "Continue" validates required fields before advancing
- Last tab ("Profile & Branding") navigates to `/employer/setup/values`

**Tab 1 — Admin Details**
- Name (required)
- Last Name (required)
- Phone Number (required)
- Role / Position within company (required, dropdown)

**Tab 2 — Company Details**
- Legal Company Name (required)
- Business Industry (required, dropdown)
- Company Size (required, dropdown)

**Tab 3 — Contact Details**
- Registered Address (required)
- City (required, `CitySearchBottomSheet`)
- Contact Email (required)
- Contact Phone Number (required)
- Company Website (optional)

**Tab 4 — Profile & Branding**
- Upload Photo/Logo (optional, uses `UploadFilesSheet`)
- About Company textarea (optional, max 1000 chars)
- "Skip for now" text button: skips to `/employer/setup/values` without saving branding data (all fields optional anyway)

- File: `lib/screens/employer/employer_setup_screen.dart`

---

## Modified Screens

### `RegisterScreen`

- Add `bool isEmployer = false` constructor param
- If `isEmployer == true`: email field label shows "Work Email" instead of "Email"
- No other changes. Query param `?employer=true` sets this flag via GoRouter extras or extra param.

### `ValuesScreen`

- Add `bool isEmployer = false` constructor param  
- If `isEmployer == true`: show "Skip for now" text button above the values grid
- Copy change: subtitle becomes "Select up to 5 values that best reflect your company culture"
- Skip navigates to `/home`
- No changes to values list or selection logic

---

## Routing

New entries in `lib/routes.dart`:

```dart
static const userTypeSelection = '/user-type';
static const employerTypeSelection = '/employer-type';
static const employerSetup = '/employer/setup';
static const employerSetupValues = '/employer/setup/values';
```

New `GoRoute` entries in `lib/router.dart` (added alongside existing auth routes):

```dart
GoRoute(path: Routes.userTypeSelection, builder: ...)
GoRoute(path: Routes.employerTypeSelection, builder: ...)
GoRoute(path: Routes.employerSetup, builder: ...)
GoRoute(path: Routes.employerSetupValues, builder: ...) // ValuesScreen(isEmployer: true)
```

`SelectLanguageScreen` navigates to `/user-type` instead of `/tech-comfort`.

---

## File Structure

```
lib/
├── screens/
│   ├── auth/
│   │   ├── user_type_selection_screen.dart        [NEW]
│   │   └── employer_type_selection_screen.dart     [NEW]
│   └── employer/
│       └── employer_setup_screen.dart              [NEW]
├── providers/
│   └── employer_setup_provider.dart               [NEW]
├── models/
│   └── employer_setup_state.dart                  [NEW]
```

---

## Out of Scope

- Employer dashboard / home screen (separate feature)
- Login flow for employers (reuses existing login screens)
- Email verification for employers (reuses existing verify flow)
- API integration (all mock data)
