# My Assessments — Design Spec
Date: 2026-04-21

## Overview

Implement the "My Assessments" section of the Ithaki Flutter app. Users can browse assessments, take them (with progress saving), and view their results with skill breakdowns. Data is mock for now with a clean abstract repository interface for future API integration.

---

## Screen Flow

4 GoRouter routes + 3 dialog overlays (no own route):

```
/assessments              → MyAssessmentsScreen
/assessments/:id          → AssessmentDetailScreen
/assessments/:id/quiz     → AssessmentQuizScreen (internal state)
/assessments/:id/results  → AssessmentResultsScreen
```

**Overlays (shown via showModalBottomSheet / showDialog):**
- `StartAssessmentDialog` — triggered by "Start Test" button
- `ContinueAssessmentDialog` — triggered when tapping an in-progress assessment
- `LeaveAssessmentDialog` — triggered by Back tap inside quiz

**Navigation logic:**
- Not-started assessment → "Test Details" → AssessmentDetailScreen
- Not-started assessment → "Start Test" → StartAssessmentDialog → /quiz
- In-progress assessment → ContinueAssessmentDialog → Continue → /quiz (resumes) or Start Over → /quiz (resets)
- Quiz Back tap → LeaveAssessmentDialog → Leave (saves progress, go back) or Continue (dismiss)
- Last question submitted → ProcessingResultsOverlay → /results

---

## Models (`lib/models/assessment_models.dart`)

```dart
enum AssessmentStatus { notStarted, inProgress, completed }
enum QuestionType { singleSelect, multiSelect, rangeNumber, rangeSymbol, imageSelect }

class Assessment {
  final String id;
  final String title;
  final String category;       // e.g. "Skills Assessment"
  final String description;
  final String iconName;       // IthakiIcon name
  final int questionCount;
  final int durationMinutes;
  final String language;
  final AssessmentStatus status;
  final AssessmentResult? lastResult;
}

sealed class Question {
  final String id;
  final String text;
  final QuestionType type;
}

class SingleSelectQuestion extends Question {
  final List<String> options;
}

class MultiSelectQuestion extends Question {
  final List<String> options;
  final int maxSelections;
}

class RangeNumberQuestion extends Question {
  final int min;
  final int max;
  final String minLabel;  // e.g. "Never"
  final String maxLabel;  // e.g. "Always"
}

class RangeSymbolQuestion extends Question {
  final List<SymbolOption> options;  // emoji + label + sentiment color
}

class ImageSelectQuestion extends Question {
  final String imageUrl;
  final List<String> options;
}

class SymbolOption {
  final String emoji;
  final String label;
  final Color color;  // IthakiTheme token
}

class AssessmentProgress {
  final String assessmentId;
  final int currentQuestionIndex;
  final Map<String, dynamic> answers;  // questionId → selected value(s)
}

class AssessmentResult {
  final String assessmentId;
  final int score;
  final int maxScore;
  final String level;                      // e.g. "Strong problem-solving skills"
  final DateTime takenAt;
  final List<SkillBreakdown> skillBreakdowns;
  final List<String> keyInsights;
  final List<AssessmentResult> previousResults;
  final bool shownInCV;
}

class SkillBreakdown {
  final String name;
  final double score;
  final double maxScore;
}
```

---

## Repository (`lib/repositories/assessments/`)

### Abstract interface (`assessment_repository.dart`)

```dart
abstract class AssessmentRepository {
  Future<List<Assessment>> getAssessments();
  Future<List<Question>> getQuestions(String assessmentId);
  Future<AssessmentProgress?> getProgress(String assessmentId);
  Future<void> saveProgress(AssessmentProgress progress);
  Future<void> clearProgress(String assessmentId);
  Future<AssessmentResult?> getResult(String assessmentId);
  Future<AssessmentResult> submitAnswers(String assessmentId, Map<String, dynamic> answers);
  Future<void> toggleShowInCV(String assessmentId, bool show);
}
```

### Mock implementation (`mock_assessment_repository.dart`)

- In-memory `Map<String, AssessmentProgress>` for progress.
- Hardcoded list: ~6 assessments (2 in progress, 2 recommended, 2 completed).
- `submitAnswers` returns a fake result after a 2-second delay (simulates processing).
- `getQuestions` returns ~5 mock questions per assessment covering all 5 types.

---

## Providers (`lib/providers/assessment_provider.dart`)

### `assessmentsListProvider`
`AsyncNotifierProvider<AssessmentsListNotifier, List<Assessment>>`

- Loads all assessments on init.
- Exposes helpers: `inProgress`, `recommended`, `completed` getters on state.
- `refresh()` method for pull-to-refresh.

### `quizProvider` (family by `assessmentId`)
`NotifierProviderFamily<QuizNotifier, QuizState, String>`

```dart
class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final Map<String, dynamic> answers;
  final bool isLoading;
  final bool isProcessing;  // shows ProcessingResultsOverlay
}
```

- `build(String assessmentId)` — loads questions + resumes saved progress on init.
- `answer(String questionId, dynamic value)` — stores answer in state.
- `next()` — advances index or triggers submit on last question.
- `back()` — decrements index (does NOT pop route; Back tap triggers Leave dialog).
- `saveAndExit()` — persists current progress then pops route.
- `reset()` — clears progress, restarts from question 0.

### `assessmentResultProvider` (family by `assessmentId`)
`AsyncNotifierProviderFamily<ResultNotifier, AssessmentResult?, String>`

- Loads result for a given assessmentId.
- `toggleCV(bool show)` — calls `toggleShowInCV` on repo and refreshes.

---

## Screens

### `MyAssessmentsScreen` (`/assessments`)

Sections (scrollable):
1. "Start New Assessment" purple button.
2. **Assessments in Progress** — list of `AssessmentCard` with `Continue` button.
3. **Assessments recommended for you** — list of `AssessmentCard` with `Test Details` + `Start Test` buttons.
4. **Your Completed Assessments** — list of `AssessmentCard` with score, `View Details` + `Show in CV` buttons.

Empty state: shown when no assessments exist (onboarding steps illustration).

Uses `PanelScaffold` + `IthakiAppBar` per app conventions.

### `AssessmentDetailScreen` (`/assessments/:id`)

Shows full assessment info:
- Icon + title + category.
- Approx duration, question count, language meta row.
- Description paragraph.
- "What this assessment is used for" bullet list.
- "Before you start" bullet list.

No app bar drawer/profile — uses `IthakiBackLink`.

### `AssessmentQuizScreen` (`/assessments/:id/quiz`)

Single screen with internal state via `quizProvider`:
- Progress bar (currentIndex / total).
- Question number label (`1/20`).
- Question text + optional image.
- Answer widget switched by `QuestionType`:
  - `SingleSelectOptions` — tappable rows, radio-style purple border on select.
  - `MultiSelectOptions` — checkbox rows with max selection enforcement.
  - `RangeNumberOptions` — numbered rows (1–N) with Never/Always labels.
  - `RangeSymbolOptions` — emoji rows with colored sentiment labels.
  - `ImageSelectOptions` — image header + single-select rows.
- Bottom: Back + Next buttons (Next disabled until answer selected; first question hides Back).
- Back tap → `LeaveAssessmentDialog`.
- Last question Next → shows `ProcessingResultsOverlay` → navigates to `/results`.

### `AssessmentResultsScreen` (`/assessments/:id/results`)

Scrollable, sections:
1. Header: icon + title + category + date taken.
2. Score card: `score/100`, level label.
3. **Skill breakdown** — horizontal progress bars per skill (IthakiTheme colors).
4. **Key insights** — bullet list.
5. **Previous results** — prior score rows (if any).
6. **Assessments recommended for you** — 2 `AssessmentCard` widgets.
7. **What this means for your profile** — "Show result in my CV" toggle button.

---

## Widgets

### `AssessmentCard` (`lib/widgets/assessment_card.dart`)

Reused in list screen and results screen. Props:
- `assessment` — the Assessment model.
- `showScore` — bool (completed cards show score).
- `onStartTest`, `onTestDetails`, `onViewDetails` — callbacks.

### `AssessmentQuestionWidget` (`lib/widgets/assessment_question_widget.dart`)

Switch widget that renders the correct option UI based on `QuestionType`. Internal to the quiz screen folder.

### Dialogs (inline in quiz/list screens, not separate files)

- `StartAssessmentDialog` — assessment meta (duration, questions, language) + "Start now" button.
- `ContinueAssessmentDialog` — "Start over" outline + "Continue" primary button.
- `LeaveAssessmentDialog` — "Leave" outline + "Continue" primary button.
- `ProcessingResultsOverlay` — modal barrier + card with checkmark icon + progress bar animation.

---

## Routes Changes

**`lib/routes.dart` additions:**
```dart
static const assessments       = '/assessments';
static const assessmentDetail  = '/assessments/:id';
static String assessmentDetailFor(String id) => '/assessments/$id';
static const assessmentQuiz    = '/assessments/:id/quiz';
static String assessmentQuizFor(String id) => '/assessments/$id/quiz';
static const assessmentResults = '/assessments/:id/results';
static String assessmentResultsFor(String id) => '/assessments/$id/results';
```

**`lib/router.dart`:** Add 4 new `GoRoute` entries. All 4 routes follow the same auth guard as the rest of the app (require authenticated session). The quiz screen wraps its body in `PopScope(canPop: false)` to intercept Android system back and show `LeaveAssessmentDialog` instead of popping.

---

## Design Tokens

- No hardcoded colors — all via `IthakiTheme.*`.
- Skill breakdown bars: use `IthakiTheme.primaryPurple` / `IthakiTheme.matchGreen` / accent colors from existing tokens.
- Selected answer border: `IthakiTheme.primaryPurple`.
- Progress bar fill: `IthakiTheme.primaryPurple`.
- Symbol option colors: map sentiment (negative → red token, neutral → grey, positive → green token).

---

## Mock Data

6 assessments total:
- 2 in progress (Digital Skills, Decision-Making Style)
- 2 recommended (Problem-Solving, Work Pace & Focus)
- 3 completed (Adaptability Assessment, Teamwork Skills Assessment, English Proficiency Assessment)

Each assessment has 5 mock questions covering all 5 question types.
Completed assessments have a mock `AssessmentResult` with skill breakdowns + 1 previous result entry.

---

## Out of Scope

- Real API integration (repository interface is ready for it).
- Push notifications for assessment reminders.
- Assessment filtering/search (designs show search UI — deferred to next iteration).
- Dark mode.
