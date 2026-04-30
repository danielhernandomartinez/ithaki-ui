# Employer Dashboard Backlog Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the employer dashboard with modals, banners, edit-job screen, archived card rendering, empty state, and search clear button.

**Architecture:** `JobPostCard` gets an `onStatusAction` callback + `isArchived` flag; modals are `StatefulWidget` bottom sheets shown from `EmployerDashboardScreen`; the 5-step edit screen uses a local `PageController`; banners overlay the scroll content via a `Stack` and auto-dismiss after 4 seconds.

**Tech Stack:** Flutter 3.x, Dart 3.x, Riverpod 3, GoRouter 17, `ithaki_design_system`, `flutter_test`, `mocktail`

**Design source:** `PNGS/NGO-EMPLOYER/dashboard/`
**Spec:** `docs/superpowers/specs/2026-04-30-employer-dashboard-backlog-design.md`

---

## File Map

| File | Action | Purpose |
|---|---|---|
| `lib/models/employer_dashboard_models.dart` | Modify | Add `closedReason` field to `JobPost` |
| `lib/routes.dart` | Modify | Add `employerAiMatcher`, `employerEditJob` constants |
| `lib/router.dart` | Modify | Register 2 new GoRoutes |
| `lib/screens/employer/dashboard/widgets/job_post_card.dart` | Modify | Add `onStatusAction`, `isArchived` |
| `lib/screens/employer/dashboard/employer_dashboard_screen.dart` | Modify | Wire AI Matcher, archived mode, banner state, `_handleStatusAction`, search clear |
| `lib/screens/employer/dashboard/employer_ai_matcher_screen.dart` | Modify | Change `jobTitle: String` → `jobPost: JobPost` |
| `lib/screens/employer/dashboard/widgets/boost_job_post_sheet.dart` | Create | Boost modal |
| `lib/screens/employer/dashboard/widgets/close_job_sheet.dart` | Create | Close modal |
| `lib/screens/employer/dashboard/widgets/delete_job_post_sheet.dart` | Create | Delete modal |
| `lib/screens/employer/dashboard/widgets/publish_again_sheet.dart` | Create | Publish Again modal |
| `lib/screens/employer/dashboard/widgets/job_action_banner.dart` | Create | Success/status banner overlay |
| `lib/screens/employer/dashboard/widgets/dashboard_stats_section.dart` | Modify | Empty-state (non-clickable) vs hidden-stats (clickable) |
| `lib/screens/employer/dashboard/employer_edit_job_post_screen.dart` | Create | 5-step edit job form |
| `lib/l10n/app_en.arb` | Modify | New l10n keys for all new UI strings |
| `test/screens/employer/job_post_card_test.dart` | Create | Card callback + archived mode tests |
| `test/screens/employer/boost_job_post_sheet_test.dart` | Create | Modal CTA enabled/disabled |
| `test/screens/employer/close_job_sheet_test.dart` | Create | Modal CTA enabled/disabled |
| `test/screens/employer/delete_job_post_sheet_test.dart` | Create | Modal renders + confirm fires |
| `test/screens/employer/publish_again_sheet_test.dart` | Create | Modal CTA enabled/disabled |
| `test/screens/employer/job_action_banner_test.dart` | Create | Banner renders correct message |

---

## Task 1: JobPost model — add `closedReason`

**Files:**
- Modify: `lib/models/employer_dashboard_models.dart`

- [ ] **Step 1: Add field to `JobPost`**

In `lib/models/employer_dashboard_models.dart`, add `final String? closedReason;` to the class:

```dart
class JobPost {
  final String id;
  final String title;
  final String category;
  final String salary;
  final JobPostStatus status;
  final int views;
  final int candidates;
  final int newCandidates;
  final DateTime createdAt;
  final String? boostedUntil;
  final String? closedReason;   // ← new

  const JobPost({
    required this.id,
    required this.title,
    required this.category,
    required this.salary,
    required this.status,
    required this.views,
    required this.candidates,
    this.newCandidates = 0,
    required this.createdAt,
    this.boostedUntil,
    this.closedReason,            // ← new
  });
}
```

- [ ] **Step 2: Run analysis — no errors expected**

```bash
flutter analyze lib/models/employer_dashboard_models.dart
```

Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/models/employer_dashboard_models.dart
git commit -m "feat(employer): add closedReason field to JobPost model"
```

---

## Task 2: New routes

**Files:**
- Modify: `lib/routes.dart`
- Modify: `lib/router.dart`
- Modify: `lib/screens/employer/dashboard/employer_ai_matcher_screen.dart`

- [ ] **Step 1: Add route constants to `routes.dart`**

After the existing `employerJobDetail` block (around line 24), add:

```dart
static const employerAiMatcher = '/employer/jobs/:jobId/ai-matcher';
static String employerAiMatcherFor(String jobId) =>
    '/employer/jobs/$jobId/ai-matcher';

static const employerEditJob = '/employer/jobs/:jobId/edit';
static String employerEditJobFor(String jobId) =>
    '/employer/jobs/$jobId/edit';
```

- [ ] **Step 2: Update `EmployerAiMatcherScreen` constructor**

In `lib/screens/employer/dashboard/employer_ai_matcher_screen.dart`, change:

```dart
// Before
class EmployerAiMatcherScreen extends ConsumerStatefulWidget {
  final String jobTitle;
  const EmployerAiMatcherScreen({super.key, required this.jobTitle});
```

```dart
// After
class EmployerAiMatcherScreen extends ConsumerStatefulWidget {
  final JobPost jobPost;
  const EmployerAiMatcherScreen({super.key, required this.jobPost});
```

Add the import at the top:

```dart
import '../../../models/employer_dashboard_models.dart';
```

Then replace every `widget.jobTitle` in `_EmployerAiMatcherScreenState` with `widget.jobPost.title`.

- [ ] **Step 3: Register routes in `router.dart`**

Add these two `GoRoute` entries inside `IthakiRouter.router` routes list, after the existing `employerJobDetail` route (around line 208):

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

Also add the import for `EmployerEditJobPostScreen` at the top of `router.dart`:

```dart
import 'screens/employer/dashboard/employer_edit_job_post_screen.dart';
```

Note: `EmployerEditJobPostScreen` is created in Task 8. Until then, this will cause a compile error — register the route in Task 8 instead if working sequentially. Or create a stub first (see below).

- [ ] **Step 4: Create stub `EmployerEditJobPostScreen` to unblock compilation**

Create `lib/screens/employer/dashboard/employer_edit_job_post_screen.dart` with a minimal stub:

```dart
import 'package:flutter/material.dart';
import '../../../models/employer_dashboard_models.dart';

class EmployerEditJobPostScreen extends StatelessWidget {
  final JobPost jobPost;
  const EmployerEditJobPostScreen({super.key, required this.jobPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Job Post')),
      body: Center(child: Text(jobPost.title)),
    );
  }
}
```

- [ ] **Step 5: Run analysis**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/routes.dart lib/router.dart \
  lib/screens/employer/dashboard/employer_ai_matcher_screen.dart \
  lib/screens/employer/dashboard/employer_edit_job_post_screen.dart
git commit -m "feat(employer): add ai-matcher and edit-job routes"
```

---

## Task 3: JobPostCard — `onStatusAction` + `isArchived`

**Files:**
- Modify: `lib/screens/employer/dashboard/widgets/job_post_card.dart`
- Create: `test/screens/employer/job_post_card_test.dart`

- [ ] **Step 1: Write failing tests**

Create `test/screens/employer/job_post_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/job_post_card.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _mockJob = JobPost(
  id: 'j1',
  title: 'Sales Manager',
  category: 'Retail',
  salary: '1,500 €/month',
  status: JobPostStatus.published,
  views: 10,
  candidates: 2,
  createdAt: DateTime(2025, 10, 1),
);

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('onStatusAction fires with correct action string', (tester) async {
    String? capturedAction;
    await tester.pumpWidget(_wrap(
      JobPostCard(
        jobPost: _mockJob,
        onStatusAction: (action, _) => capturedAction = action,
      ),
    ));
    // Open status chip popup
    await tester.tap(find.text('Published'));
    await tester.pumpAndSettle();
    // Tap 'Boost'
    await tester.tap(find.text('Boost'));
    await tester.pumpAndSettle();
    expect(capturedAction, 'boost');
  });

  testWidgets('isArchived hides AI Matcher button', (tester) async {
    await tester.pumpWidget(_wrap(
      JobPostCard(
        jobPost: _mockJob.copyWith(status: JobPostStatus.closed),
        isArchived: true,
      ),
    ));
    expect(find.text('AI Matcher'), findsNothing);
    expect(find.text('Details'), findsOneWidget);
  });

  testWidgets('isArchived status chip is not a PopupMenuButton', (tester) async {
    await tester.pumpWidget(_wrap(
      JobPostCard(
        jobPost: _mockJob.copyWith(status: JobPostStatus.closed),
        isArchived: true,
      ),
    ));
    expect(find.byType(PopupMenuButton<String>), findsNothing);
  });
}
```

- [ ] **Step 2: Run tests — expect FAIL**

```bash
flutter test test/screens/employer/job_post_card_test.dart
```

Expected: compile error or test failure (`onStatusAction` and `isArchived` not yet on `JobPostCard`, `copyWith` not on `JobPost`).

- [ ] **Step 3: Add `copyWith` to `JobPost`**

In `lib/models/employer_dashboard_models.dart`, add `copyWith` to `JobPost`:

```dart
JobPost copyWith({
  String? id,
  String? title,
  String? category,
  String? salary,
  JobPostStatus? status,
  int? views,
  int? candidates,
  int? newCandidates,
  DateTime? createdAt,
  String? boostedUntil,
  String? closedReason,
}) =>
    JobPost(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      salary: salary ?? this.salary,
      status: status ?? this.status,
      views: views ?? this.views,
      candidates: candidates ?? this.candidates,
      newCandidates: newCandidates ?? this.newCandidates,
      createdAt: createdAt ?? this.createdAt,
      boostedUntil: boostedUntil ?? this.boostedUntil,
      closedReason: closedReason ?? this.closedReason,
    );
```

- [ ] **Step 4: Update `JobPostCard` — add params and archived mode**

Replace the class declaration and `build` method in `lib/screens/employer/dashboard/widgets/job_post_card.dart`:

```dart
class JobPostCard extends StatelessWidget {
  final JobPost jobPost;
  final VoidCallback? onDetails;
  final VoidCallback? onAiMatcher;
  final void Function(String action, JobPost post)? onStatusAction;
  final bool isArchived;

  const JobPostCard({
    super.key,
    required this.jobPost,
    this.onDetails,
    this.onAiMatcher,
    this.onStatusAction,
    this.isArchived = false,
  });
```

In the action buttons row, wrap the AI Matcher button with a conditional:

```dart
// ── Action buttons ────────────────────────────────────
Row(
  children: [
    Expanded(
      child: SizedBox(
        height: 44,
        child: OutlinedButton(
          onPressed: onDetails,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            side: const BorderSide(color: IthakiTheme.lightGraphite),
            foregroundColor: IthakiTheme.textPrimary,
          ),
          child: Text(l10n.jobActionDetails,
              style: IthakiTheme.buttonLabel),
        ),
      ),
    ),
    if (!isArchived) ...[
      const SizedBox(width: 10),
      Expanded(
        child: SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: onAiMatcher,
            style: ElevatedButton.styleFrom(
              backgroundColor: IthakiTheme.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const IthakiIcon('ai', size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(l10n.jobActionAiMatcher,
                    style: IthakiTheme.buttonLabel),
              ],
            ),
          ),
        ),
      ),
    ],
  ],
),
```

Update `_StatusChip` to receive and call `onStatusAction`. Change its constructor and `PopupMenuButton.onSelected`:

```dart
class _StatusChip extends StatelessWidget {
  final JobPostStatus status;
  final AppLocalizations l10n;
  final void Function(String action)? onSelected;
  final bool isArchived;

  const _StatusChip({
    required this.status,
    required this.l10n,
    this.onSelected,
    this.isArchived = false,
  });
```

In `build`, when `isArchived` is true, return a plain Container pill instead of `PopupMenuButton`:

```dart
@override
Widget build(BuildContext context) {
  final style = _style;

  if (isArchived) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: style.text,
        ),
      ),
    );
  }

  return PopupMenuButton<String>(
    onSelected: onSelected,
    offset: const Offset(0, 36),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    itemBuilder: (_) => _menuItems(),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: style.text,
            ),
          ),
          const SizedBox(width: 4),
          IthakiIcon('arrow-down', size: 13, color: style.text),
        ],
      ),
    ),
  );
}
```

In `JobPostCard.build`, pass the new props to `_StatusChip`:

```dart
_StatusChip(
  status: jobPost.status,
  l10n: l10n,
  isArchived: isArchived,
  onSelected: onStatusAction != null
      ? (action) => onStatusAction!(action, jobPost)
      : null,
),
```

- [ ] **Step 5: Run tests — expect PASS**

```bash
flutter test test/screens/employer/job_post_card_test.dart
```

Expected: `All tests passed!`

- [ ] **Step 6: Run full analysis**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add lib/models/employer_dashboard_models.dart \
  lib/screens/employer/dashboard/widgets/job_post_card.dart \
  test/screens/employer/job_post_card_test.dart
git commit -m "feat(employer): add onStatusAction + isArchived to JobPostCard"
```

---

## Task 4: Wire dashboard — AI Matcher, archived cards, banner state, search clear

**Files:**
- Modify: `lib/screens/employer/dashboard/employer_dashboard_screen.dart`

- [ ] **Step 1: Add banner state fields and `_handleStatusAction` scaffold**

At the top of `_EmployerDashboardScreenState`, add:

```dart
import 'dart:async';
// ... existing imports ...
import 'widgets/boost_job_post_sheet.dart';
import 'widgets/close_job_sheet.dart';
import 'widgets/delete_job_post_sheet.dart';
import 'widgets/publish_again_sheet.dart';
import 'widgets/job_action_banner.dart';
```

Add fields to the state class:

```dart
JobActionBannerType? _activeBanner;
Timer? _bannerTimer;
```

Add `dispose` cleanup for the timer:

```dart
@override
void dispose() {
  _scrollController.dispose();
  _searchController.dispose();
  _bannerTimer?.cancel();
  _panels.dispose();
  super.dispose();
}
```

Add `_showBanner` helper method:

```dart
void _showBanner(JobActionBannerType type) {
  _bannerTimer?.cancel();
  setState(() => _activeBanner = type);
  _bannerTimer = Timer(const Duration(seconds: 4), () {
    if (mounted) setState(() => _activeBanner = null);
  });
}
```

Add `_handleStatusAction` method:

```dart
void _handleStatusAction(String action, JobPost post) {
  switch (action) {
    case 'boost':
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => BoostJobPostSheet(
          jobPost: post,
          onConfirm: () {
            Navigator.pop(context);
            _showBanner(JobActionBannerType.statusChanged);
          },
        ),
      );
    case 'close':
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => CloseJobSheet(
          jobPost: post,
          onConfirm: (_) {
            Navigator.pop(context);
            _showBanner(JobActionBannerType.statusChanged);
          },
        ),
      );
    case 'delete':
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => DeleteJobPostSheet(
          jobPost: post,
          onConfirm: () {
            Navigator.pop(context);
            _showBanner(JobActionBannerType.statusChanged);
          },
        ),
      );
    case 'publish':
    case 'publish_again':
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => PublishAgainSheet(
          jobPost: post,
          onConfirm: () {
            Navigator.pop(context);
            _showBanner(JobActionBannerType.statusChanged);
          },
        ),
      );
    case 'pause':
      _showBanner(JobActionBannerType.statusChanged);
  }
}
```

- [ ] **Step 2: Wire `JobPostCard` callbacks in `_buildJobList`**

Replace the `JobPostCard` builder in `_buildJobList`:

```dart
itemBuilder: (_, i) => JobPostCard(
  jobPost: filtered[i],
  isArchived: _selectedTab == 1,
  onDetails: () => context.push(
    Routes.employerJobDetailFor(filtered[i].id),
    extra: filtered[i],
  ),
  onAiMatcher: () => context.push(
    Routes.employerAiMatcherFor(filtered[i].id),
    extra: filtered[i],
  ),
  onStatusAction: _handleStatusAction,
),
```

- [ ] **Step 3: Add banner overlay to `Stack` and search clear button**

In the `Stack` children (inside the `data:` branch of `ref.watch`), add the banner overlay after the scroll content but before the panel overlays:

```dart
if (_activeBanner != null)
  Positioned(
    top: topOffset,
    left: 16,
    right: 16,
    child: JobActionBanner(
      type: _activeBanner!,
      onDismiss: () {
        _bannerTimer?.cancel();
        setState(() => _activeBanner = null);
      },
    ),
  ),
```

For the search clear button, update the `TextField` decoration's `suffixIcon`:

```dart
suffixIcon: _searchQuery.isNotEmpty
    ? GestureDetector(
        onTap: () => _searchController.clear(),
        child: const Padding(
          padding: EdgeInsets.only(right: 12),
          child: IthakiIcon('x-close',
              size: 16, color: IthakiTheme.lightGraphite),
        ),
      )
    : null,
suffixIconConstraints: const BoxConstraints(minWidth: 0),
```

- [ ] **Step 4: Wire Edit Job navigation from `EmployerJobDetailScreen`**

Open `lib/screens/employer/dashboard/employer_job_detail_screen.dart`. Find the `...` (more options) button or wherever edit should be triggered. Add a navigation call (this may vary based on what actions exist — check the "open actions" design):

```dart
// In the more-options handler or wherever "Edit" appears:
context.push(
  Routes.employerEditJobFor(jobPost.id),
  extra: jobPost,
);
```

And after `await context.push<String>(...)`:

```dart
// At the call site in dashboard when pushing edit:
final result = await context.push<String>(
  Routes.employerEditJobFor(filtered[i].id),
  extra: filtered[i],
);
if (result == 'published') {
  _showBanner(JobActionBannerType.changesPublished);
}
```

Note: In `_buildJobList` the job card does not have an "Edit" button — editing is launched from `EmployerJobDetailScreen`. Wire the edit entry point there rather than from the card.

- [ ] **Step 5: Run analysis**

```bash
flutter analyze
```

Note: will fail until Tasks 5–7 (modal + banner files) are created. Proceed to those tasks, then re-run.

- [ ] **Step 6: Commit after Tasks 5–7 are done**

```bash
git add lib/screens/employer/dashboard/employer_dashboard_screen.dart
git commit -m "feat(employer): wire dashboard modals, banner, archived cards, search clear"
```

---

## Task 5: l10n keys for new UI strings

**Files:**
- Modify: `lib/l10n/app_en.arb`

- [ ] **Step 1: Add keys at end of file (before closing `}`)**

```json
  "boostJobPostTitle": "Boost Job Post",
  "boostJobPostDescription": "Boost your job \"{title}\" to keep it at the top of search results and increase visibility to candidates.",
  "@boostJobPostDescription": {
    "placeholders": { "title": { "type": "String" } }
  },
  "availableCredits": "Available Credits",
  "creditsUnit": "{count} credits",
  "@creditsUnit": {
    "placeholders": { "count": { "type": "int" } }
  },
  "weeklyBoostLabel": "Weekly Boost",
  "weeklyBoostSubtitle": "1 week (till {date})",
  "@weeklyBoostSubtitle": {
    "placeholders": { "date": { "type": "String" } }
  },
  "fullTermBoostLabel": "Full-term Boost",
  "fullTermBoostSubtitle": "Until job post expires ({date})",
  "@fullTermBoostSubtitle": {
    "placeholders": { "date": { "type": "String" } }
  },
  "changeStatusButton": "Change Status",
  "closeJobTitle": "Close this job?",
  "closeJobDescription": "Ready to close \"{title}\"? It will be moved to archived, and you'll still be able to reopen it anytime.\nPlease select a reason for closing the job:",
  "@closeJobDescription": {
    "placeholders": { "title": { "type": "String" } }
  },
  "closeJobReasonHint": "Select the reason",
  "deleteJobPostTitle": "Delete Job Post",
  "deleteJobPostDescription": "Are you ready to delete \"{title}\"?\n\nThis job post will be hidden and marked as Archived, but you can reactivate it later if required.",
  "@deleteJobPostDescription": {
    "placeholders": { "title": { "type": "String" } }
  },
  "publishAgainTitle": "Publish Again",
  "publishAgainDescription": "You can republish the job \"{title}\" for another month to keep it active and visible to candidates.",
  "@publishAgainDescription": {
    "placeholders": { "title": { "type": "String" } }
  },
  "publishAgainOptionLabel": "Publish Again",
  "publishAndWeeklyBoostLabel": "Publish and Weekly Boost",
  "changesPublishedMessage": "The changes to this job post have been successfully saved.",
  "statusChangedMessage": "The status has been updated successfully.",
  "editJobPostTitle": "Edit Job Post",
  "editJobPostSubtitle": "You can edit any section if needed — and if everything looks correct, go ahead and publish it.",
  "editStepBasics": "Job Basics",
  "editStepSkills": "Skills Required",
  "editStepDescription": "Job Description",
  "editStepPreferences": "Preferences",
  "editStepReview": "Review",
  "editJobPostNameLabel": "Job Post Name",
  "editIndustryLabel": "Industry",
  "editExperienceLevelLabel": "Experience Level",
  "editJobTypeLabel": "Job Type",
  "editWorkplaceTypeLabel": "Workplace Type",
  "editSalaryFromLabel": "Salary From",
  "editSalaryToLabel": "Salary To",
  "editSetSalaryRange": "Set Salary Range",
  "editSetDeadline": "Set the deadline for applications",
  "editSkillsTitle": "Skills Required",
  "editSkillsDescription": "Add the required skills for this role by typing them one by one and selecting from the dropdown, or enter multiple skills separated by commas.",
  "editSkillsHint": "Start typing to add a skill",
  "editAiSkillsSuggestions": "AI Skills Suggestions",
  "editLanguagesTitle": "Languages skills Required",
  "editLanguageLabel": "Language",
  "editProficiencyLabel": "Proficiency Level",
  "editAddLanguage": "+ Add Another Language",
  "editCompetenciesTitle": "Competencies",
  "editComputerSkillsLabel": "Computer Skills",
  "editDrivingLicence": "Driving Licence Required",
  "editDrivingLicenceCategory": "Driving Licence Category",
  "editJobDescriptionTitle": "Job Description",
  "editAboutRole": "About the Role",
  "editResponsibilities": "Responsibilities",
  "editRequirements": "Requirements",
  "editNiceToHave": "Nice to Have",
  "editWeOffer": "We Offer",
  "editPreferencesTitle": "Preferences",
  "editCoverLetterTitle": "Cover Letter",
  "editCoverLetterDescription": "Cover letters help you better understand motivation and communication skills. Candidates will be asked to add it when applying.",
  "editRequireCoverLetter": "Require a cover letter from candidates",
  "editScreeningQuestionsTitle": "Additional Questions",
  "editScreeningQuestionsDescription": "Add additional questions to learn more about candidates before the interview. This step is optional. We recommend adding up to 5 questions.",
  "editAddScreeningQuestions": "Add Screening Questions",
  "editReviewTitle": "Review",
  "editJobBasicsButton": "Edit Job Basics",
  "editSkillsButton": "Edit Skills",
  "editDescriptionButton": "Edit Job Description",
  "editCoverLetterPrefsButton": "Update Cover Letter Preferences",
  "editScreeningButton": "Edit Additional Screening Questions",
  "publishJobPostButton": "Publish Job post",
  "dashboardArchivedCount": "You have {count} archived job posts",
  "@dashboardArchivedCount": {
    "placeholders": { "count": { "type": "int" } }
  }
```

- [ ] **Step 2: Regenerate l10n**

```bash
flutter gen-l10n
```

Expected: no errors, `lib/l10n/app_localizations_en.dart` updated.

- [ ] **Step 3: Commit**

```bash
git add lib/l10n/app_en.arb lib/l10n/
git commit -m "feat(employer): add l10n keys for dashboard modals, banners, edit screen"
```

---

## Task 6: Four modal bottom sheets

### 6a. BoostJobPostSheet

**Files:**
- Create: `lib/screens/employer/dashboard/widgets/boost_job_post_sheet.dart`
- Create: `test/screens/employer/boost_job_post_sheet_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/screens/employer/boost_job_post_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/boost_job_post_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.published,
  views: 0, candidates: 0, createdAt: DateTime(2025),
);

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('CTA disabled before selection', (tester) async {
    await tester.pumpWidget(_wrap(
      BoostJobPostSheet(jobPost: _job),
    ));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNull);
  });

  testWidgets('CTA enabled after selecting an option', (tester) async {
    await tester.pumpWidget(_wrap(
      BoostJobPostSheet(jobPost: _job),
    ));
    await tester.tap(find.text('Weekly Boost'));
    await tester.pump();
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('onConfirm fires when CTA tapped', (tester) async {
    bool confirmed = false;
    await tester.pumpWidget(_wrap(
      BoostJobPostSheet(jobPost: _job, onConfirm: () => confirmed = true),
    ));
    await tester.tap(find.text('Weekly Boost'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(confirmed, isTrue);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/screens/employer/boost_job_post_sheet_test.dart
```

Expected: compile error (file not created yet).

- [ ] **Step 3: Implement `BoostJobPostSheet`**

Create `lib/screens/employer/dashboard/widgets/boost_job_post_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

class BoostJobPostSheet extends StatefulWidget {
  final JobPost jobPost;
  final VoidCallback? onConfirm;

  const BoostJobPostSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<BoostJobPostSheet> createState() => _BoostJobPostSheetState();
}

class _BoostJobPostSheetState extends State<BoostJobPostSheet> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(l10n.boostJobPostTitle, style: IthakiTheme.headingMedium),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ]),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: IthakiTheme.bodySmall,
                children: [
                  const TextSpan(text: 'Boost your job '),
                  TextSpan(
                    text: '"${widget.jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: ' to keep it at the top of search results and increase visibility to candidates.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: IthakiTheme.softGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Text(l10n.availableCredits, style: IthakiTheme.bodySmallBold),
                const Spacer(),
                Text('50 credits', style: IthakiTheme.bodySmall),
              ]),
            ),
            const SizedBox(height: 16),
            _OptionCard(
              label: l10n.weeklyBoostLabel,
              subtitle: '1 week',
              credits: 5,
              selected: _selected == 'weekly',
              onTap: () => setState(() => _selected = 'weekly'),
            ),
            const SizedBox(height: 8),
            _OptionCard(
              label: l10n.fullTermBoostLabel,
              subtitle: 'Until job post expires',
              credits: 15,
              selected: _selected == 'full',
              onTap: () => setState(() => _selected = 'full'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selected != null ? widget.onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  disabledBackgroundColor:
                      IthakiTheme.primaryPurple.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.changeStatusButton,
                    style: IthakiTheme.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final int credits;
  final bool selected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.subtitle,
    required this.credits,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          border: Border.all(
            color: selected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: IthakiTheme.bodySmallBold),
              Text(subtitle, style: IthakiTheme.captionRegular),
            ],
          ),
          const Spacer(),
          Text('$credits Credits', style: IthakiTheme.bodySmallBold),
        ]),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

```bash
flutter test test/screens/employer/boost_job_post_sheet_test.dart
```

Expected: `All tests passed!`

---

### 6b. CloseJobSheet

**Files:**
- Create: `lib/screens/employer/dashboard/widgets/close_job_sheet.dart`
- Create: `test/screens/employer/close_job_sheet_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/screens/employer/close_job_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/close_job_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.boosted,
  views: 0, candidates: 0, createdAt: DateTime(2025),
);

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('CTA disabled before reason selected', (tester) async {
    await tester.pumpWidget(_wrap(CloseJobSheet(jobPost: _job)));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNull);
  });

  testWidgets('onConfirm fires with reason string', (tester) async {
    String? reason;
    await tester.pumpWidget(_wrap(
      CloseJobSheet(jobPost: _job, onConfirm: (r) => reason = r),
    ));
    // Open dropdown
    await tester.tap(find.text('Select the reason'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Position filled').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(reason, 'Position filled');
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/screens/employer/close_job_sheet_test.dart
```

- [ ] **Step 3: Implement `CloseJobSheet`**

Create `lib/screens/employer/dashboard/widgets/close_job_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

const _kCloseReasons = [
  'Position filled',
  'Budget cut',
  'Role changed',
  'Other',
];

class CloseJobSheet extends StatefulWidget {
  final JobPost jobPost;
  final void Function(String reason)? onConfirm;

  const CloseJobSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<CloseJobSheet> createState() => _CloseJobSheetState();
}

class _CloseJobSheetState extends State<CloseJobSheet> {
  String? _reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(l10n.closeJobTitle, style: IthakiTheme.headingMedium),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ]),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: IthakiTheme.bodySmall,
                children: [
                  const TextSpan(text: 'Ready to close '),
                  TextSpan(
                    text: '"${widget.jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: '? It will be moved to archived, and you\'ll still be able to reopen it anytime.\nPlease select a reason for closing the job:',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: IthakiTheme.borderLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _reason,
                  isExpanded: true,
                  hint: Text(l10n.closeJobReasonHint,
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary)),
                  items: _kCloseReasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _reason = v),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _reason != null
                    ? () => widget.onConfirm?.call(_reason!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  disabledBackgroundColor:
                      IthakiTheme.primaryPurple.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.changeStatusButton,
                    style: IthakiTheme.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

```bash
flutter test test/screens/employer/close_job_sheet_test.dart
```

---

### 6c. DeleteJobPostSheet

**Files:**
- Create: `lib/screens/employer/dashboard/widgets/delete_job_post_sheet.dart`
- Create: `test/screens/employer/delete_job_post_sheet_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/screens/employer/delete_job_post_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/delete_job_post_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.published,
  views: 0, candidates: 0, createdAt: DateTime(2025),
);

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('CTA always enabled', (tester) async {
    await tester.pumpWidget(_wrap(DeleteJobPostSheet(jobPost: _job)));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('onConfirm fires on tap', (tester) async {
    bool confirmed = false;
    await tester.pumpWidget(_wrap(
      DeleteJobPostSheet(jobPost: _job, onConfirm: () => confirmed = true),
    ));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(confirmed, isTrue);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/screens/employer/delete_job_post_sheet_test.dart
```

- [ ] **Step 3: Implement `DeleteJobPostSheet`**

Create `lib/screens/employer/dashboard/widgets/delete_job_post_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

class DeleteJobPostSheet extends StatelessWidget {
  final JobPost jobPost;
  final VoidCallback? onConfirm;

  const DeleteJobPostSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(l10n.deleteJobPostTitle, style: IthakiTheme.headingMedium),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ]),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: IthakiTheme.bodySmall,
                children: [
                  const TextSpan(text: 'Are you ready to delete '),
                  TextSpan(
                    text: '"${jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: '?\n\nThis job post will be hidden and marked as Archived, but you can reactivate it later if required.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.changeStatusButton,
                    style: IthakiTheme.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

```bash
flutter test test/screens/employer/delete_job_post_sheet_test.dart
```

---

### 6d. PublishAgainSheet

**Files:**
- Create: `lib/screens/employer/dashboard/widgets/publish_again_sheet.dart`
- Create: `test/screens/employer/publish_again_sheet_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/screens/employer/publish_again_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/publish_again_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.closed,
  views: 0, candidates: 0, createdAt: DateTime(2025),
);

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('CTA disabled before selection', (tester) async {
    await tester.pumpWidget(_wrap(PublishAgainSheet(jobPost: _job)));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNull);
  });

  testWidgets('shows three options', (tester) async {
    await tester.pumpWidget(_wrap(PublishAgainSheet(jobPost: _job)));
    expect(find.text('Publish Again'), findsWidgets);
    expect(find.text('Publish and Weekly Boost'), findsOneWidget);
    expect(find.text('Full-term Boost'), findsOneWidget);
  });

  testWidgets('onConfirm fires after selection', (tester) async {
    bool confirmed = false;
    await tester.pumpWidget(_wrap(
      PublishAgainSheet(jobPost: _job, onConfirm: () => confirmed = true),
    ));
    await tester.tap(find.text('Publish and Weekly Boost'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(confirmed, isTrue);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/screens/employer/publish_again_sheet_test.dart
```

- [ ] **Step 3: Implement `PublishAgainSheet`**

Create `lib/screens/employer/dashboard/widgets/publish_again_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';
import 'boost_job_post_sheet.dart' show _OptionCard;

class PublishAgainSheet extends StatefulWidget {
  final JobPost jobPost;
  final VoidCallback? onConfirm;

  const PublishAgainSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<PublishAgainSheet> createState() => _PublishAgainSheetState();
}

class _PublishAgainSheetState extends State<PublishAgainSheet> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(l10n.publishAgainTitle, style: IthakiTheme.headingMedium),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ]),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: IthakiTheme.bodySmall,
                children: [
                  const TextSpan(text: 'You can republish the job '),
                  TextSpan(
                    text: '"${widget.jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: ' for another month to keep it active and visible to candidates.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: IthakiTheme.softGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Text(l10n.availableCredits, style: IthakiTheme.bodySmallBold),
                const Spacer(),
                Text('50 credits', style: IthakiTheme.bodySmall),
              ]),
            ),
            const SizedBox(height: 16),
            _OptionCard(
              label: l10n.publishAgainOptionLabel,
              subtitle: 'Expires in 1 month',
              credits: 3,
              selected: _selected == 'publish',
              onTap: () => setState(() => _selected = 'publish'),
            ),
            const SizedBox(height: 8),
            _OptionCard(
              label: l10n.publishAndWeeklyBoostLabel,
              subtitle: '1 week boost included',
              credits: 8,
              selected: _selected == 'weekly',
              onTap: () => setState(() => _selected = 'weekly'),
            ),
            const SizedBox(height: 8),
            _OptionCard(
              label: l10n.fullTermBoostLabel,
              subtitle: 'Until job post expires',
              credits: 18,
              selected: _selected == 'full',
              onTap: () => setState(() => _selected = 'full'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selected != null ? widget.onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  disabledBackgroundColor:
                      IthakiTheme.primaryPurple.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.changeStatusButton,
                    style: IthakiTheme.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

Note: `_OptionCard` is re-exported from `boost_job_post_sheet.dart`. Because `_OptionCard` is a private class (prefixed `_`), it cannot be imported. **Change `_OptionCard` to `OptionCard`** (remove the `_` prefix) in `boost_job_post_sheet.dart` so `PublishAgainSheet` can import it. Update the test file reference accordingly.

- [ ] **Step 4: Make `_OptionCard` public in `boost_job_post_sheet.dart`**

In `boost_job_post_sheet.dart`, rename `_OptionCard` → `OptionCard` everywhere (class name + constructors + usages).

Update `publish_again_sheet.dart` import:

```dart
import 'boost_job_post_sheet.dart' show OptionCard;
```

And use `OptionCard(...)` instead of `_OptionCard(...)`.

- [ ] **Step 5: Run all sheet tests**

```bash
flutter test test/screens/employer/boost_job_post_sheet_test.dart \
  test/screens/employer/close_job_sheet_test.dart \
  test/screens/employer/delete_job_post_sheet_test.dart \
  test/screens/employer/publish_again_sheet_test.dart
```

Expected: all pass.

- [ ] **Step 6: Commit**

```bash
git add lib/screens/employer/dashboard/widgets/boost_job_post_sheet.dart \
  lib/screens/employer/dashboard/widgets/close_job_sheet.dart \
  lib/screens/employer/dashboard/widgets/delete_job_post_sheet.dart \
  lib/screens/employer/dashboard/widgets/publish_again_sheet.dart \
  test/screens/employer/boost_job_post_sheet_test.dart \
  test/screens/employer/close_job_sheet_test.dart \
  test/screens/employer/delete_job_post_sheet_test.dart \
  test/screens/employer/publish_again_sheet_test.dart
git commit -m "feat(employer): add Boost, Close, Delete, PublishAgain modal sheets"
```

---

## Task 7: `JobActionBanner` widget

**Files:**
- Create: `lib/screens/employer/dashboard/widgets/job_action_banner.dart`
- Create: `test/screens/employer/job_action_banner_test.dart`

- [ ] **Step 1: Write failing test**

Create `test/screens/employer/job_action_banner_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/job_action_banner.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('changesPublished shows correct message', (tester) async {
    await tester.pumpWidget(_wrap(
      JobActionBanner(
        type: JobActionBannerType.changesPublished,
        onDismiss: () {},
      ),
    ));
    expect(
      find.text('The changes to this job post have been successfully saved.'),
      findsOneWidget,
    );
  });

  testWidgets('statusChanged shows correct message', (tester) async {
    await tester.pumpWidget(_wrap(
      JobActionBanner(
        type: JobActionBannerType.statusChanged,
        onDismiss: () {},
      ),
    ));
    expect(
      find.text('The status has been updated successfully.'),
      findsOneWidget,
    );
  });

  testWidgets('onDismiss fires when X tapped', (tester) async {
    bool dismissed = false;
    await tester.pumpWidget(_wrap(
      JobActionBanner(
        type: JobActionBannerType.changesPublished,
        onDismiss: () => dismissed = true,
      ),
    ));
    await tester.tap(find.byType(GestureDetector).last);
    await tester.pump();
    expect(dismissed, isTrue);
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

```bash
flutter test test/screens/employer/job_action_banner_test.dart
```

- [ ] **Step 3: Implement `JobActionBanner`**

Create `lib/screens/employer/dashboard/widgets/job_action_banner.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';

enum JobActionBannerType { changesPublished, statusChanged }

class JobActionBanner extends StatelessWidget {
  final JobActionBannerType type;
  final VoidCallback onDismiss;

  const JobActionBanner({
    super.key,
    required this.type,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final message = type == JobActionBannerType.changesPublished
        ? l10n.changesPublishedMessage
        : l10n.statusChangedMessage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: IthakiTheme.softGraphite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: IthakiTheme.bodySmall.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: const IthakiIcon('x-close', size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

```bash
flutter test test/screens/employer/job_action_banner_test.dart
```

- [ ] **Step 5: Run full analysis and all tests**

```bash
flutter analyze && flutter test
```

Expected: no issues, all tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/screens/employer/dashboard/widgets/job_action_banner.dart \
  test/screens/employer/job_action_banner_test.dart \
  lib/screens/employer/dashboard/employer_dashboard_screen.dart
git commit -m "feat(employer): add JobActionBanner and wire full dashboard action flow"
```

---

## Task 8: Empty state — `DashboardStatsSection`

**Files:**
- Modify: `lib/screens/employer/dashboard/widgets/dashboard_stats_section.dart`

The `DashboardStatsSection` already handles `showStats: false` by showing clickable "Stat will be shown here." For the zero-jobs empty state, this text should be non-clickable (plain).

- [ ] **Step 1: Add `isEmpty` parameter**

```dart
class DashboardStatsSection extends StatelessWidget {
  final EmployerDashboardData data;
  final VoidCallback onToggleStats;
  final bool isEmpty;        // ← new

  const DashboardStatsSection({
    super.key,
    required this.data,
    required this.onToggleStats,
    this.isEmpty = false,    // ← new
  });
```

- [ ] **Step 2: Update the `!data.showStats` branch**

```dart
if (!data.showStats || isEmpty) {
  final isClickable = !isEmpty;
  final placeholder = Center(
    child: Text(
      l10n.dashboardStatPlaceholder,
      style: IthakiTheme.bodySmall.copyWith(
        decoration: isClickable ? TextDecoration.underline : null,
        decorationColor: IthakiTheme.textPrimary,
      ),
    ),
  );
  if (!isClickable) return placeholder;
  return GestureDetector(onTap: onToggleStats, child: placeholder);
}
```

- [ ] **Step 3: Pass `isEmpty` from `EmployerDashboardScreen`**

In `employer_dashboard_screen.dart`, find the `DashboardStatsSection` call and add:

```dart
DashboardStatsSection(
  data: data,
  isEmpty: data.activeJobPostsCount == 0 && data.archivedJobPostsCount == 0,
  onToggleStats: () => ref
      .read(employerDashboardProvider.notifier)
      .toggleStats(),
),
```

- [ ] **Step 4: Run analysis**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/screens/employer/dashboard/widgets/dashboard_stats_section.dart \
  lib/screens/employer/dashboard/employer_dashboard_screen.dart
git commit -m "feat(employer): non-clickable stats placeholder in empty dashboard state"
```

---

## Task 9: `EmployerEditJobPostScreen` — 5-step form

**Files:**
- Modify: `lib/screens/employer/dashboard/employer_edit_job_post_screen.dart` (replace stub)

- [ ] **Step 1: Define step enum and form state class at top of file**

Replace the stub with the full implementation. Start with imports and data structures:

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/employer_dashboard_models.dart';
import '../../../routes.dart';

enum _Step { basics, skills, description, preferences, review }

class _LanguageEntry {
  String language;
  String proficiency;
  _LanguageEntry({this.language = '', this.proficiency = ''});
}
```

- [ ] **Step 2: Implement the widget skeleton**

```dart
class EmployerEditJobPostScreen extends ConsumerStatefulWidget {
  final JobPost jobPost;
  const EmployerEditJobPostScreen({super.key, required this.jobPost});

  @override
  ConsumerState<EmployerEditJobPostScreen> createState() =>
      _EmployerEditJobPostScreenState();
}

class _EmployerEditJobPostScreenState
    extends ConsumerState<EmployerEditJobPostScreen> {
  final _pageController = PageController();
  _Step _currentStep = _Step.basics;

  // Basics fields
  late final TextEditingController _nameCtrl;
  String _industry = 'Retail';
  String _location = 'Thessaloniki';
  String _experienceLevel = 'Entry';
  String _jobType = 'Full-time';
  String _workplaceType = 'Office';
  String _salaryFrom = '1,000';
  String _salaryTo = '1,500';
  bool _setSalaryRange = true;
  bool _setDeadline = true;
  DateTime? _deadline;

  // Skills fields
  final List<String> _skills = [];
  final TextEditingController _skillInputCtrl = TextEditingController();
  final List<_LanguageEntry> _languages = [_LanguageEntry()];
  String _computerSkills = 'Advanced';
  bool _drivingLicence = false;
  String _drivingCategory = 'Category B';

  // Description fields
  final TextEditingController _aboutCtrl = TextEditingController();
  final TextEditingController _responsibilitiesCtrl = TextEditingController();
  final TextEditingController _requirementsCtrl = TextEditingController();
  final TextEditingController _niceToHaveCtrl = TextEditingController();
  final TextEditingController _weOfferCtrl = TextEditingController();

  // Preferences fields
  bool _requireCoverLetter = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.jobPost.title);
    _deadline = DateTime.now().add(const Duration(days: 60));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _skillInputCtrl.dispose();
    _aboutCtrl.dispose();
    _responsibilitiesCtrl.dispose();
    _requirementsCtrl.dispose();
    _niceToHaveCtrl.dispose();
    _weOfferCtrl.dispose();
    super.dispose();
  }

  void _goToStep(_Step step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_currentStep.index < _Step.values.length - 1) {
      _goToStep(_Step.values[_currentStep.index + 1]);
    }
  }

  void _back() {
    if (_currentStep.index > 0) {
      _goToStep(_Step.values[_currentStep.index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showMenuAndAvatar: false,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Row(
            children: [
              const IthakiIcon('arrow-left', size: 18,
                  color: IthakiTheme.textPrimary),
              const SizedBox(width: 4),
              Text('Back', style: IthakiTheme.bodySmall),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _BasicsStep(this, l10n),
                _SkillsStep(this, l10n),
                _DescriptionStep(this, l10n),
                _PreferencesStep(this, l10n),
                _ReviewStep(this, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Implement `_StepIndicator`**

Add this private widget to the same file:

```dart
class _StepIndicator extends StatelessWidget {
  final _Step current;
  const _StepIndicator(this.current, {super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.editStepBasics,
      l10n.editStepSkills,
      l10n.editStepDescription,
      l10n.editStepPreferences,
      l10n.editStepReview,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_Step.values.length, (i) {
          final step = _Step.values[i];
          final isActive = step == current;
          final isCompleted = step.index < current.index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? IthakiTheme.primaryPurple
                    : IthakiTheme.softGray,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? Border.all(color: IthakiTheme.primaryPurple, width: 2)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted) ...[
                    const IthakiIcon('check', size: 13, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive || isCompleted
                          ? Colors.white
                          : IthakiTheme.softGraphite,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
```

- [ ] **Step 4: Implement step content widgets**

Each step is a private `StatelessWidget` that takes the state object as a parameter. Add them to the same file after `_StepIndicator`.

**`_BasicsStep`:**

```dart
class _BasicsStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _BasicsStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editStepBasics, style: IthakiTheme.headingMedium),
                const SizedBox(height: 16),
                _FieldLabel(l10n.editJobPostNameLabel),
                TextField(
                  controller: s._nameCtrl,
                  style: IthakiTheme.bodySmall,
                  decoration: _inputDeco(),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editIndustryLabel),
                _DropdownField(
                  value: s._industry,
                  items: ['Retail', 'Transportation & Logistics', 'Marketing',
                    'Technology', 'Healthcare'],
                  onChanged: (v) => s.setState(() => s._industry = v!),
                ),
                const SizedBox(height: 12),
                _FieldLabel('Location'),
                TextField(
                  controller: TextEditingController(text: s._location),
                  style: IthakiTheme.bodySmall,
                  readOnly: true,
                  decoration: _inputDeco(
                    suffix: const IthakiIcon('location', size: 18,
                        color: IthakiTheme.softGraphite),
                  ),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editExperienceLevelLabel),
                _DropdownField(
                  value: s._experienceLevel,
                  items: ['Entry', 'Junior', 'Mid', 'Senior', 'Lead'],
                  onChanged: (v) => s.setState(() => s._experienceLevel = v!),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editJobTypeLabel),
                _DropdownField(
                  value: s._jobType,
                  items: ['Full-time', 'Part-time', 'Contract', 'Internship'],
                  onChanged: (v) => s.setState(() => s._jobType = v!),
                ),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editWorkplaceTypeLabel),
                _DropdownField(
                  value: s._workplaceType,
                  items: ['Office', 'Remote', 'Hybrid'],
                  onChanged: (v) => s.setState(() => s._workplaceType = v!),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(l10n.editSalaryFromLabel),
                      TextField(
                        controller: TextEditingController(text: s._salaryFrom),
                        keyboardType: TextInputType.number,
                        style: IthakiTheme.bodySmall,
                        decoration: _inputDeco(suffix: const Text('€')),
                        onChanged: (v) => s._salaryFrom = v,
                      ),
                    ],
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(l10n.editSalaryToLabel),
                      TextField(
                        controller: TextEditingController(text: s._salaryTo),
                        keyboardType: TextInputType.number,
                        style: IthakiTheme.bodySmall,
                        decoration: _inputDeco(suffix: const Text('€')),
                        onChanged: (v) => s._salaryTo = v,
                      ),
                    ],
                  )),
                ]),
                CheckboxListTile(
                  value: s._setSalaryRange,
                  onChanged: (v) => s.setState(() => s._setSalaryRange = v!),
                  title: Text(l10n.editSetSalaryRange,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                CheckboxListTile(
                  value: s._setDeadline,
                  onChanged: (v) => s.setState(() => s._setDeadline = v!),
                  title: Text(l10n.editSetDeadline, style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                if (s._setDeadline) ...[
                  _FieldLabel('Deadline Date'),
                  TextField(
                    readOnly: true,
                    style: IthakiTheme.bodySmall,
                    controller: TextEditingController(
                      text: s._deadline != null
                          ? '${s._deadline!.day.toString().padLeft(2,'0')}-'
                            '${s._deadline!.month.toString().padLeft(2,'0')}-'
                            '${s._deadline!.year}'
                          : '',
                    ),
                    decoration: _inputDeco(
                      suffix: const IthakiIcon('calendar', size: 18,
                          color: IthakiTheme.softGraphite),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: s._deadline ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        s.setState(() => s._deadline = picked);
                      }
                    },
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: IthakiButton(
                    'Continue',
                    onPressed: s._next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**`_SkillsStep`:**

```dart
class _SkillsStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _SkillsStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editSkillsTitle, style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Text(l10n.editSkillsDescription, style: IthakiTheme.bodySecondary),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const IthakiIcon('ai', size: 16,
                      color: IthakiTheme.primaryPurple),
                  label: Text(l10n.editAiSkillsSuggestions,
                      style: IthakiTheme.bodySmall.copyWith(
                          color: IthakiTheme.primaryPurple)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: IthakiTheme.primaryPurple),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: s._skills.map((skill) => Chip(
                    label: Text(skill, style: IthakiTheme.bodySmall),
                    onDeleted: () =>
                        s.setState(() => s._skills.remove(skill)),
                    deleteIcon: const IthakiIcon('x', size: 14,
                        color: IthakiTheme.softGraphite),
                    backgroundColor: IthakiTheme.softGray,
                    side: BorderSide.none,
                  )).toList(),
                ),
                TextField(
                  controller: s._skillInputCtrl,
                  style: IthakiTheme.bodySmall,
                  decoration: _inputDeco(hint: l10n.editSkillsHint),
                  onSubmitted: (v) {
                    if (v.trim().isNotEmpty) {
                      s.setState(() {
                        s._skills.add(v.trim());
                        s._skillInputCtrl.clear();
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Text(l10n.editLanguagesTitle, style: IthakiTheme.headingMedium),
                const SizedBox(height: 12),
                ...s._languages.asMap().entries.map((e) {
                  final i = e.key;
                  final lang = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DropdownField(
                            value: lang.language.isEmpty
                                ? null : lang.language,
                            hint: l10n.editLanguageLabel,
                            items: ['Greek', 'English', 'Arabic', 'French',
                              'German', 'Spanish'],
                            onChanged: (v) =>
                                s.setState(() => lang.language = v!),
                          ),
                          const SizedBox(height: 8),
                          _DropdownField(
                            value: lang.proficiency.isEmpty
                                ? null : lang.proficiency,
                            hint: l10n.editProficiencyLabel,
                            items: ['Basic', 'Conversational', 'Fluent',
                              'Native', 'Intermediate'],
                            onChanged: (v) =>
                                s.setState(() => lang.proficiency = v!),
                          ),
                        ],
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            s.setState(() => s._languages.removeAt(i)),
                        child: const IthakiIcon('delete', size: 20,
                            color: IthakiTheme.softGraphite),
                      ),
                    ]),
                  );
                }),
                OutlinedButton.icon(
                  onPressed: () =>
                      s.setState(() => s._languages.add(_LanguageEntry())),
                  icon: const IthakiIcon('plus', size: 16,
                      color: IthakiTheme.textPrimary),
                  label: Text(l10n.editAddLanguage,
                      style: IthakiTheme.bodySmall),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(l10n.editCompetenciesTitle,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 12),
                _FieldLabel(l10n.editComputerSkillsLabel),
                _DropdownField(
                  value: s._computerSkills,
                  items: ['Basic', 'Intermediate', 'Advanced'],
                  onChanged: (v) =>
                      s.setState(() => s._computerSkills = v!),
                ),
                CheckboxListTile(
                  value: s._drivingLicence,
                  onChanged: (v) =>
                      s.setState(() => s._drivingLicence = v!),
                  title: Text(l10n.editDrivingLicence,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                if (s._drivingLicence) ...[
                  _FieldLabel(l10n.editDrivingLicenceCategory),
                  _DropdownField(
                    value: s._drivingCategory,
                    items: ['Category A', 'Category B', 'Category C',
                      'Category D'],
                    onChanged: (v) =>
                        s.setState(() => s._drivingCategory = v!),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**`_DescriptionStep`:**

```dart
class _DescriptionStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _DescriptionStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in [
                  (l10n.editAboutRole, s._aboutCtrl),
                  (l10n.editResponsibilities, s._responsibilitiesCtrl),
                  (l10n.editRequirements, s._requirementsCtrl),
                  (l10n.editNiceToHave, s._niceToHaveCtrl),
                  (l10n.editWeOffer, s._weOfferCtrl),
                ]) ...[
                  _FieldLabel(entry.$1),
                  TextField(
                    controller: entry.$2,
                    style: IthakiTheme.bodySmall,
                    maxLines: null,
                    minLines: 4,
                    decoration: _inputDeco(),
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**`_PreferencesStep`:**

```dart
class _PreferencesStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _PreferencesStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.editCoverLetterTitle, style: IthakiTheme.headingMedium),
                const SizedBox(height: 4),
                Text(l10n.editCoverLetterDescription,
                    style: IthakiTheme.bodySecondary),
                CheckboxListTile(
                  value: s._requireCoverLetter,
                  onChanged: (v) =>
                      s.setState(() => s._requireCoverLetter = v!),
                  title: Text(l10n.editRequireCoverLetter,
                      style: IthakiTheme.bodySmall),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: IthakiTheme.primaryPurple,
                ),
                const SizedBox(height: 20),
                Text(l10n.editScreeningQuestionsTitle,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 4),
                Text(l10n.editScreeningQuestionsDescription,
                    style: IthakiTheme.bodySecondary),
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  child: IthakiButton(l10n.editAddScreeningQuestions,
                      onPressed: () {}),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiButton('Continue', onPressed: s._next),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, height: 52,
                  child: IthakiOutlineButton('Back', onPressed: s._back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**`_ReviewStep`:**

```dart
class _ReviewStep extends StatelessWidget {
  final _EmployerEditJobPostScreenState s;
  final AppLocalizations l10n;
  const _ReviewStep(this.s, this.l10n);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.editJobPostTitle, style: IthakiTheme.headingLarge),
          const SizedBox(height: 4),
          Text(l10n.editJobPostSubtitle, style: IthakiTheme.bodySecondary),
          const SizedBox(height: 16),
          _StepIndicator(s._currentStep),
          const SizedBox(height: 24),
          IthakiCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Basics summary
                Text(l10n.editStepBasics, style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Text('${s._nameCtrl.text} · ${s._jobType} · ${s._location}',
                    style: IthakiTheme.bodySmall),
                Text('${s._salaryFrom}–${s._salaryTo} € · ${s._experienceLevel}',
                    style: IthakiTheme.bodySmall),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editJobBasicsButton,
                  onPressed: () => s._goToStep(_Step.basics)),
                const Divider(height: 24),

                // Skills summary
                Text(l10n.editStepSkills, style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: s._skills.map((sk) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: IthakiTheme.softGray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(sk, style: IthakiTheme.captionRegular),
                  )).toList(),
                ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editSkillsButton,
                  onPressed: () => s._goToStep(_Step.skills)),
                const Divider(height: 24),

                // Description summary
                Text(l10n.editStepDescription,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                if (s._aboutCtrl.text.isNotEmpty)
                  Text(
                    s._aboutCtrl.text.length > 120
                        ? '${s._aboutCtrl.text.substring(0, 120)}…'
                        : s._aboutCtrl.text,
                    style: IthakiTheme.bodySmall,
                  ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editDescriptionButton,
                  onPressed: () => s._goToStep(_Step.description)),
                const Divider(height: 24),

                // Preferences summary
                Text(l10n.editStepPreferences,
                    style: IthakiTheme.headingMedium),
                const SizedBox(height: 8),
                Text(
                  s._requireCoverLetter
                      ? 'Cover letter required'
                      : 'Cover letter not required',
                  style: IthakiTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                IthakiOutlineButton(l10n.editCoverLetterPrefsButton,
                  onPressed: () => s._goToStep(_Step.preferences)),
                const Divider(height: 24),

                IthakiOutlineButton(l10n.editScreeningButton,
                  onPressed: () => s._goToStep(_Step.preferences)),
                const SizedBox(height: 24),

                Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => context.pop('published'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: IthakiTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const IthakiIcon('rocket', size: 16,
                                color: Colors.white),
                            const SizedBox(width: 6),
                            Text(l10n.publishJobPostButton,
                                style: IthakiTheme.buttonLabel),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48, height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: IthakiTheme.borderLight),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: IthakiIcon('arrow-down', size: 18,
                          color: IthakiTheme.softGraphite),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Add shared helper widgets at bottom of file**

```dart
InputDecoration _inputDeco({String? hint, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: IthakiTheme.bodySmall
          .copyWith(color: IthakiTheme.textSecondary),
      suffixIcon: suffix != null
          ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffix,
            )
          : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 0),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: IthakiTheme.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: IthakiTheme.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: IthakiTheme.primaryPurple),
      ),
      filled: true,
      fillColor: IthakiTheme.backgroundWhite,
    );

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label, style: IthakiTheme.bodySmallBold),
      );
}

class _DropdownField extends StatelessWidget {
  final String? value;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        border: Border.all(color: IthakiTheme.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(hint!, style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary))
              : null,
          style: IthakiTheme.bodySmall,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
          icon: const IthakiIcon('arrow-down', size: 16,
              color: IthakiTheme.softGraphite),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Run analysis**

```bash
flutter analyze
```

Fix any type errors (common: `TextEditingController` re-created in build — move init to `initState` for controllers that need persistence).

- [ ] **Step 7: Commit**

```bash
git add lib/screens/employer/dashboard/employer_edit_job_post_screen.dart
git commit -m "feat(employer): implement 5-step EmployerEditJobPostScreen"
```

---

## Task 10: Final integration — run all tests and analysis

- [ ] **Step 1: Run full test suite**

```bash
flutter test
```

Expected: all tests pass. Fix any failures before continuing.

- [ ] **Step 2: Run analysis**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Commit any remaining fixes**

```bash
git add -A
git commit -m "fix(employer): resolve analysis issues after full integration"
```

---

## Summary of new files

```
lib/
  models/employer_dashboard_models.dart          (modified)
  routes.dart                                    (modified)
  router.dart                                    (modified)
  screens/employer/dashboard/
    employer_ai_matcher_screen.dart              (modified)
    employer_dashboard_screen.dart               (modified)
    employer_edit_job_post_screen.dart           (new/replaced stub)
    widgets/
      job_post_card.dart                         (modified)
      dashboard_stats_section.dart               (modified)
      boost_job_post_sheet.dart                  (new)
      close_job_sheet.dart                       (new)
      delete_job_post_sheet.dart                 (new)
      publish_again_sheet.dart                   (new)
      job_action_banner.dart                     (new)
  l10n/app_en.arb                                (modified)

test/screens/employer/
  job_post_card_test.dart                        (new)
  boost_job_post_sheet_test.dart                 (new)
  close_job_sheet_test.dart                      (new)
  delete_job_post_sheet_test.dart                (new)
  publish_again_sheet_test.dart                  (new)
  job_action_banner_test.dart                    (new)
```
