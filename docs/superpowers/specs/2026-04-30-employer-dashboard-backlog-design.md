# Employer Dashboard Backlog — Design Spec
**Date:** 2026-04-30  
**Status:** Approved

---

## Scope

Complete the employer dashboard feature set:

- 2 new routes (AI Matcher, Edit Job Post)
- Wire AI Matcher button navigation on `JobPostCard`
- `JobPostCard` refactor (callbacks + archived mode)
- 4 bottom-sheet modals (Boost, Close, Delete, Publish Again)
- 2 notification banners (Changes Published, Status Changed)
- Empty dashboard state
- Archived tab proper rendering
- `EmployerEditJobPostScreen` (5-step form)
- Search result states (already partially built — verify)

Design source: `PNGS/NGO-EMPLOYER/dashboard/`

---

## 1. Architecture

### JobPostCard — callback extension

Add two new parameters:

```dart
final void Function(String action, JobPost post)? onStatusAction;
final bool isArchived;  // default false
```

- `_StatusChip.onSelected` calls `onStatusAction(value, jobPost)` instead of `(_) {}`.
- When `isArchived: true`:
  - Status chip renders as a plain `Container` pill (no `PopupMenuButton`, no arrow icon).
  - AI Matcher button is hidden; only "Details" button is shown.

`EmployerDashboardScreen._buildJobList` passes `isArchived: _selectedTab == 1` and wires `onStatusAction` to a handler that opens the appropriate modal.

### JobPost model

Add optional field:

```dart
final String? closedReason;
```

---

## 2. Routes

### New constants (`routes.dart`)

```dart
static const employerAiMatcher = '/employer/jobs/:jobId/ai-matcher';
static String employerAiMatcherFor(String jobId) =>
    '/employer/jobs/$jobId/ai-matcher';

static const employerEditJob = '/employer/jobs/:jobId/edit';
static String employerEditJobFor(String jobId) =>
    '/employer/jobs/$jobId/edit';
```

### New GoRoutes (`router.dart`)

Both routes receive `state.extra as JobPost`.

```dart
GoRoute(
  path: Routes.employerAiMatcher,
  builder: (context, state) {
    final jobPost = state.extra as JobPost;
    return EmployerAiMatcherScreen(jobPost: jobPost);
  },
),
GoRoute(
  path: Routes.employerEditJob,
  builder: (context, state) {
    final jobPost = state.extra as JobPost;
    return EmployerEditJobPostScreen(jobPost: jobPost);
  },
),
```

### Wire AI Matcher button

In `EmployerDashboardScreen._buildJobList`, change:

```dart
onAiMatcher: () => context.push(
  Routes.employerAiMatcherFor(filtered[i].id),
  extra: filtered[i],
),
```

`EmployerAiMatcherScreen` must accept an optional `jobPost` parameter (currently it may not — update constructor if needed).

---

## 3. Bottom-Sheet Modals

All modals are shown with `showModalBottomSheet(isScrollControlled: true)`. All extend or use `BottomSheetBase` from `lib/widgets/bottom_sheet_base.dart`.

Each modal is triggered from `_handleStatusAction(String action, JobPost post)` in `EmployerDashboardScreen`.

### 3a. BoostJobPostSheet

**File:** `lib/screens/employer/dashboard/widgets/boost_job_post_sheet.dart`

**Props:**
```dart
final JobPost jobPost;
final VoidCallback? onConfirm;
```

**Layout:**
- Header: "Boost Job Post" + X close button
- Description with job title in bold
- Row: "Available Credits" + "50 credits" (mock)
- Two selectable option cards:
  - Weekly Boost — 1 week / 5 Credits
  - Full-term Boost — until expiry / 15 Credits
- CTA "Change Status" — disabled until option selected; `IthakiButton`

**State:** local `String? _selected`.

### 3b. CloseJobSheet

**File:** `lib/screens/employer/dashboard/widgets/close_job_sheet.dart`

**Props:**
```dart
final JobPost jobPost;
final void Function(String reason)? onConfirm;
```

**Layout:**
- Header: "Close this job?" + X
- Description with job title in bold, explains move to archived
- Dropdown "Select the reason" (mock options: "Position filled", "Budget cut", "Role changed", "Other")
- CTA "Change Status" — disabled until reason selected

**State:** local `String? _reason`.

### 3c. DeleteJobPostSheet

**File:** `lib/screens/employer/dashboard/widgets/delete_job_post_sheet.dart`

**Props:**
```dart
final JobPost jobPost;
final VoidCallback? onConfirm;
```

**Layout:**
- Header: "Delete Job Post" + X
- Confirmation text with job title in bold ("This job post will be hidden and marked as Archived")
- CTA "Change Status" — always active

### 3d. PublishAgainSheet

**File:** `lib/screens/employer/dashboard/widgets/publish_again_sheet.dart`

**Props:**
```dart
final JobPost jobPost;
final VoidCallback? onConfirm;
```

**Layout:**
- Header: "Publish Again" + X
- Description with job title in bold
- Row: "Available Credits" + "50 credits" (mock)
- Three selectable option cards:
  - Publish Again — expires in 1 month / 3 Credits
  - Publish and Weekly Boost — 1 week / 8 Credits
  - Full-term Boost — until expiry / 18 Credits
- CTA "Change Status" — disabled until option selected

**State:** local `String? _selected`.

### Selectable option card — shared `_OptionCard` widget

Used by Boost and PublishAgain sheets. Private widget in each file (or extracted to `lib/screens/employer/dashboard/widgets/` if shared):

```dart
Container with border (selected: primaryPurple, unselected: borderLight),
borderRadius: 12, padding: 16.
Row: [Column(label, subtitle), Spacer, "$N Credits"]
```

---

## 4. Notification Banners

### Trigger

Banners appear **after** a modal action completes (returned via `Navigator.pop` result or callback). They overlay the dashboard content at the top (below AppBar), auto-dismiss after 4 seconds, dismissible via X.

### Implementation

New widget: `lib/screens/employer/dashboard/widgets/job_action_banner.dart`

```dart
enum JobActionBannerType { changesPublished, statusChanged }

class JobActionBanner extends StatelessWidget {
  final JobActionBannerType type;
  final VoidCallback onDismiss;
}
```

**Layout:** Full-width `Container`, `softGraphite` background, white text, X icon right. Positioned above scroll content via `Stack` in `EmployerDashboardScreen`.

**Messages:**
- `changesPublished`: "The changes to this job post have been successfully saved."
- `statusChanged`: "The status has been updated successfully."

**State in `EmployerDashboardScreen`:**

```dart
JobActionBannerType? _activeBanner;
Timer? _bannerTimer;
```

Show banner → set `_activeBanner`, start 4s timer → clear.

---

## 5. Dashboard State Updates

### Empty state

When `data.activeJobPostsCount == 0 && data.archivedJobPostsCount == 0`:

- `DashboardStatsSection` renders a single centered `Text('Stat will be shown here.', style: IthakiTheme.bodySecondary)` instead of stat rows.
- Job Posts card subtitle changes to: "Manage all your job posts in one place, where you can easily create new openings..."
- Count row shows "You have 0 job posts".
- Empty state message: "No job posts yet — create one and find your perfect candidate faster!"

The `showStats` toggle remains: when `showStats: false` AND jobs exist, shows "Show Stats" link as today. Empty state (`0` jobs) ignores the toggle — always shows the placeholder text.

### Archived tab cards

Cards in the Archived tab (`_selectedTab == 1`) render with `isArchived: true`. The only action is "Details" → `Routes.employerJobDetailFor(job.id)`. No status dropdown, no AI Matcher button.

---

## 6. EmployerEditJobPostScreen

**File:** `lib/screens/employer/dashboard/employer_edit_job_post_screen.dart`

**Route:** `/employer/jobs/:jobId/edit`, `extra: JobPost`

**Class:** `ConsumerStatefulWidget`

### Step model

```dart
enum EditJobStep { basics, skills, description, preferences, review }
```

`PageController` + `_currentStep` int control navigation between steps.

### AppBar

`IthakiAppBar` with Back link (pops route), no menu/avatar panels needed.

### Step indicator

Horizontal `Row` of 5 chip-like items. Styling:
- Active: purple outline pill, white bg, purple text
- Completed: purple filled pill, white text, checkmark prefix icon
- Upcoming: softGray pill, softGraphite text

Chips are display-only (no tap navigation — use Continue/Back buttons).

### Step 1 — Job Basics

Fields (all pre-filled from `jobPost`):
| Field | Widget |
|---|---|
| Job Post Name | `TextField` |
| Industry | `DropdownButton<String>` (mock options) |
| Location | `ProfilePickerField` → opens `CitySearchBottomSheet` |
| Experience Level | `DropdownButton<String>` |
| Job Type | `DropdownButton<String>` |
| Workplace Type | `DropdownButton<String>` |
| Salary From / Salary To | `SalaryFieldRow` |
| Set Salary Range | `Checkbox` |
| Set deadline | `Checkbox` |
| Deadline date (conditional) | `TextField` with calendar icon → `showDatePicker` |

Footer: `IthakiButton('Continue')`.

### Step 2 — Skills Required

**Skills section:**
- Existing skills as dismissible chips (`FilterChip` with `onDeleted`)
- `IthakiButton` outline: "AI Skills Suggestions" → pushes to `Routes.employerAiMatcherFor(jobPost.id)` with `extra: jobPost`
- `TextField` "Start typing to add a skill" → Enter/comma adds chip

**Languages section (optional):**
- Dynamic list of `{language, proficiencyLevel}` pairs
- Each row: Language dropdown + Proficiency Level dropdown + delete `IthakiIcon('delete')`
- "+ Add Another Language" outlined button

**Competencies section:**
- Computer Skills dropdown
- "Driving Licence Required" checkbox
- Driving Licence Category dropdown (visible only when checked)

Footer: `IthakiButton('Continue')` + `IthakiOutlineButton('Back')`.

### Step 3 — Job Description

5 labeled `TextField` blocks with `maxLines: null`, `minLines: 4`:
- About the Role
- Responsibilities
- Requirements
- Nice to Have
- We Offer

Footer: Continue + Back.

### Step 4 — Preferences

- "Require a cover letter from candidates" checkbox
- "Add Screening Questions" `IthakiButton` (outline, no-op for now)

Footer: Continue + Back.

### Step 5 — Review

Read-only summary cards. Each section shows key data + an "Edit [Section]" `IthakiOutlineButton` that calls `_goToStep(EditJobStep.x)` (animates PageView).

Sections:
- Job Basics summary (title, location, job type, salary)
- Skills (chip list, read-only)
- Job Description (truncated preview)
- Cover Letter Preferences
- Additional Screening Questions

Footer:
- `IthakiButton('Publish Job Post')` → calls `context.pop('published')`. Caller uses `await context.push<String>(Routes.employerEditJobFor(...), extra: job)` and on result `== 'published'` shows `ChangesPublishedBanner`.
- `IconButton(Icons.more_horiz)` → no-op for now

---

## 7. Search States

The search field in `EmployerDashboardScreen` is already implemented. Verify:
- Active state (focused, empty): current border becomes `primaryPurple` ✓ (already in code)
- Filled state: text visible, clear X button — **add suffix X icon** that clears `_searchController`
- Result state: filtered list renders — ✓ already works via `_filtered()`

Only addition needed: suffix clear button when `_searchQuery.isNotEmpty`.

---

## Implementation Order

1. `JobPost` model — add `closedReason`
2. `routes.dart` + `router.dart` — 2 new routes
3. `JobPostCard` — add `onStatusAction` + `isArchived`
4. `EmployerDashboardScreen` — wire AI Matcher, archived cards, `_handleStatusAction`, banner state
5. 4 modal bottom sheets
6. `JobActionBanner` widget
7. Dashboard empty state (update `DashboardStatsSection`)
8. `EmployerEditJobPostScreen`
9. Search clear button

---

## Out of Scope

- Real API calls — all actions are mock (no provider mutations beyond UI state)
- `EmployerAiMatcherScreen` constructor change if already accepts `JobPost` — verify before touching
- Localization keys — add to `app_en.arb` as part of implementation
