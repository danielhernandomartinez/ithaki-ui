# Phase 1: Async Repositories — Backend-Ready Architecture

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make all repositories async (`Future<T>`), convert notifiers to `AsyncNotifier`, fix `savedJobIndices` to use job IDs, and prepare the codebase for real backend integration.

**Architecture:** Convert sync repositories → async `Future<T>` methods. Convert `Notifier<T>` → `AsyncNotifier<T>` following the existing `TourNotifier` pattern. Widgets handle `AsyncValue<T>` with `.when()` or `.valueOrNull`. Home screen gets a new `HomeNotifier` to replace direct repository access. Job search gets a `JobSearchDataNotifier` for async data loading.

**Tech Stack:** Flutter, Riverpod 3.x (`AsyncNotifier`, `AsyncNotifierProvider`), Dart

---

### Task 1: Add `id` field to JobListing model

**Files:**
- Modify: `lib/models/job_search_models.dart`
- Modify: `lib/repositories/job_search_repository.dart` (add id to each mock)

- [ ] **Step 1: Add `id` to JobListing**

```dart
// lib/models/job_search_models.dart
import 'package:flutter/material.dart';

class JobListing {
  final String id;
  final String jobTitle;
  final String companyName;
  final String companyInitials;
  final Color companyColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String category;
  final String? location;
  final String? workMode;
  final String? employmentType;
  final String? level;
  final String postedAgo;
  final bool isSaved;

  const JobListing({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.companyInitials,
    required this.companyColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.category,
    this.location,
    this.workMode,
    this.employmentType,
    this.level,
    this.postedAgo = 'Posted 1 day ago',
    this.isSaved = false,
  });
}
```

- [ ] **Step 2: Add `id` to every mock JobListing in MockJobSearchRepository**

In `lib/repositories/job_search_repository.dart`, add `id:` to each of the 10 JobListing constructors:

```dart
JobListing(
  id: 'job-1',
  jobTitle: 'Office Secretary',
  // ... rest unchanged
),
JobListing(
  id: 'job-2',
  jobTitle: 'Junior Front-End Developer',
  // ... rest unchanged
),
// ... continue for job-3 through job-10
```

- [ ] **Step 3: Run analysis to verify no compilation errors**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze --no-pub 2>&1 | head -20`
Expected: No errors (just the existing warnings)

- [ ] **Step 4: Commit**

```bash
git add lib/models/job_search_models.dart lib/repositories/job_search_repository.dart
git commit -m "feat: add id field to JobListing model"
```

---

### Task 2: Refactor ProfileRepository to async with write methods

**Files:**
- Modify: `lib/repositories/profile_repository.dart`

- [ ] **Step 1: Convert abstract class to async + add write methods**

```dart
// lib/repositories/profile_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

abstract class ProfileRepository {
  Future<ProfileBasics> getBasics();
  Future<ProfileAboutMe> getAboutMe();
  Future<ProfileSkills> getSkills();
  Future<List<WorkExperience>> getWorkExperiences();
  Future<List<Education>> getEducations();
  Future<List<UploadedFile>> getFiles();
  Future<List<String>> getValues();
  Future<ProfileJobPreferences> getJobPreferences();
  Future<bool> getProfileVisible();

  Future<void> saveBasics(ProfileBasics basics);
  Future<void> saveAboutMe(ProfileAboutMe aboutMe);
  Future<void> saveSkills(ProfileSkills skills);
  Future<void> saveWorkExperiences(List<WorkExperience> experiences);
  Future<void> saveEducations(List<Education> educations);
  Future<void> saveFiles(List<UploadedFile> files);
  Future<void> saveValues(List<String> values);
  Future<void> saveJobPreferences(ProfileJobPreferences prefs);
  Future<void> saveProfileVisible(bool visible);
}

class MockProfileRepository implements ProfileRepository {
  // In-memory storage for mock write operations
  ProfileBasics _basics = const ProfileBasics(
    firstName: 'Christos',
    lastName: 'Ioannides',
    email: 'c.ioannidis@gmail.com',
    phone: '+30 123 456 78 90',
    dateOfBirth: '01-01-1997',
    gender: 'Male',
    citizenship: 'Greece',
    citizenshipCode: 'gr',
    residence: 'Greece',
    residenceCode: 'gr',
    status: 'Citizen',
    relocationReadiness: 'Yes',
  );
  ProfileAboutMe _aboutMe = const ProfileAboutMe();
  ProfileSkills _skills = const ProfileSkills();
  List<WorkExperience> _workExperiences = const [];
  List<Education> _educations = const [];
  List<UploadedFile> _files = const [];
  List<String> _values = const [];
  ProfileJobPreferences _jobPreferences = const ProfileJobPreferences(
    jobInterests: [
      JobInterest(title: 'Web Developer', category: 'IT & Development'),
    ],
    positionLevel: 'Senior',
    jobType: 'Full time',
    workplace: 'On-site',
    expectedSalary: 1800,
  );
  bool _profileVisible = true;

  @override
  Future<ProfileBasics> getBasics() async => _basics;
  @override
  Future<ProfileAboutMe> getAboutMe() async => _aboutMe;
  @override
  Future<ProfileSkills> getSkills() async => _skills;
  @override
  Future<List<WorkExperience>> getWorkExperiences() async => _workExperiences;
  @override
  Future<List<Education>> getEducations() async => _educations;
  @override
  Future<List<UploadedFile>> getFiles() async => _files;
  @override
  Future<List<String>> getValues() async => _values;
  @override
  Future<ProfileJobPreferences> getJobPreferences() async => _jobPreferences;
  @override
  Future<bool> getProfileVisible() async => _profileVisible;

  @override
  Future<void> saveBasics(ProfileBasics basics) async => _basics = basics;
  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async => _aboutMe = aboutMe;
  @override
  Future<void> saveSkills(ProfileSkills skills) async => _skills = skills;
  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async =>
      _workExperiences = experiences;
  @override
  Future<void> saveEducations(List<Education> educations) async =>
      _educations = educations;
  @override
  Future<void> saveFiles(List<UploadedFile> files) async => _files = files;
  @override
  Future<void> saveValues(List<String> values) async => _values = values;
  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async =>
      _jobPreferences = prefs;
  @override
  Future<void> saveProfileVisible(bool visible) async =>
      _profileVisible = visible;
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => MockProfileRepository(),
);
```

- [ ] **Step 2: Verify compilation**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze --no-pub 2>&1 | head -30`
Expected: Errors in profile_provider.dart (notifiers still sync — fixed in Task 3)

- [ ] **Step 3: Commit**

```bash
git add lib/repositories/profile_repository.dart
git commit -m "feat: make ProfileRepository async with write methods"
```

---

### Task 3: Convert Profile Notifiers to AsyncNotifier

**Files:**
- Modify: `lib/providers/profile_provider.dart`

- [ ] **Step 1: Rewrite all notifiers to AsyncNotifier pattern**

Replace the entire file content of `lib/providers/profile_provider.dart`:

```dart
// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';
import '../repositories/profile_repository.dart';

export '../models/profile_models.dart';

// ─── Profile Basics ──────────────────────────────────────────────────────────

class ProfileBasicsNotifier extends AsyncNotifier<ProfileBasics> {
  @override
  Future<ProfileBasics> build() =>
      ref.read(profileRepositoryProvider).getBasics();

  Future<void> update({
    required String firstName, required String lastName,
    required String dateOfBirth, required String gender,
    required String citizenship, String? citizenshipCode,
    required String residence, String? residenceCode,
    required String status, required String relocationReadiness,
    String? photoUrl,
  }) async {
    final updated = state.requireValue.copyWith(
      firstName: firstName, lastName: lastName,
      dateOfBirth: dateOfBirth, gender: gender,
      citizenship: citizenship, citizenshipCode: citizenshipCode,
      residence: residence, residenceCode: residenceCode,
      status: status, relocationReadiness: relocationReadiness,
      photoUrl: photoUrl,
    );
    await ref.read(profileRepositoryProvider).saveBasics(updated);
    state = AsyncData(updated);
  }
}

final profileBasicsProvider =
    AsyncNotifierProvider<ProfileBasicsNotifier, ProfileBasics>(
  ProfileBasicsNotifier.new,
);

// ─── About Me ─────────────────────────────────────────────────────────────────

class ProfileAboutMeNotifier extends AsyncNotifier<ProfileAboutMe> {
  @override
  Future<ProfileAboutMe> build() =>
      ref.read(profileRepositoryProvider).getAboutMe();

  Future<void> update(String bio, {String? videoUrl}) async {
    final updated = state.requireValue.copyWith(bio: bio, videoUrl: videoUrl);
    await ref.read(profileRepositoryProvider).saveAboutMe(updated);
    state = AsyncData(updated);
  }
}

final profileAboutMeProvider =
    AsyncNotifierProvider<ProfileAboutMeNotifier, ProfileAboutMe>(
  ProfileAboutMeNotifier.new,
);

// ─── Skills ───────────────────────────────────────────────────────────────────

class ProfileSkillsNotifier extends AsyncNotifier<ProfileSkills> {
  @override
  Future<ProfileSkills> build() =>
      ref.read(profileRepositoryProvider).getSkills();

  Future<void> updateSkills(List<String> hard, List<String> soft) async {
    final updated = state.requireValue.copyWith(hardSkills: hard, softSkills: soft);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    state = AsyncData(updated);
  }

  Future<void> updateLanguages(List<Language> langs) async {
    final updated = state.requireValue.copyWith(languages: langs);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    state = AsyncData(updated);
  }

  Future<void> updateCompetencies(Map<String, String> comp) async {
    final updated = state.requireValue.copyWith(competencies: comp);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    state = AsyncData(updated);
  }
}

final profileSkillsProvider =
    AsyncNotifierProvider<ProfileSkillsNotifier, ProfileSkills>(
  ProfileSkillsNotifier.new,
);

// ─── Work Experiences ─────────────────────────────────────────────────────────

class ProfileWorkExperiencesNotifier
    extends AsyncNotifier<List<WorkExperience>> {
  @override
  Future<List<WorkExperience>> build() =>
      ref.read(profileRepositoryProvider).getWorkExperiences();

  Future<void> add(WorkExperience exp) async {
    final updated = [...state.requireValue, exp];
    await ref.read(profileRepositoryProvider).saveWorkExperiences(updated);
    state = AsyncData(updated);
  }

  Future<void> update(int index, WorkExperience exp) async {
    final list = [...state.requireValue];
    list[index] = exp;
    await ref.read(profileRepositoryProvider).saveWorkExperiences(list);
    state = AsyncData(list);
  }
}

final profileWorkExperiencesProvider =
    AsyncNotifierProvider<ProfileWorkExperiencesNotifier, List<WorkExperience>>(
  ProfileWorkExperiencesNotifier.new,
);

// ─── Educations ───────────────────────────────────────────────────────────────

class ProfileEducationsNotifier extends AsyncNotifier<List<Education>> {
  @override
  Future<List<Education>> build() =>
      ref.read(profileRepositoryProvider).getEducations();

  Future<void> add(Education edu) async {
    final updated = [...state.requireValue, edu];
    await ref.read(profileRepositoryProvider).saveEducations(updated);
    state = AsyncData(updated);
  }

  Future<void> update(int index, Education edu) async {
    final list = [...state.requireValue];
    list[index] = edu;
    await ref.read(profileRepositoryProvider).saveEducations(list);
    state = AsyncData(list);
  }
}

final profileEducationsProvider =
    AsyncNotifierProvider<ProfileEducationsNotifier, List<Education>>(
  ProfileEducationsNotifier.new,
);

// ─── Files ────────────────────────────────────────────────────────────────────

class ProfileFilesNotifier extends AsyncNotifier<List<UploadedFile>> {
  @override
  Future<List<UploadedFile>> build() =>
      ref.read(profileRepositoryProvider).getFiles();

  Future<void> add(UploadedFile file) async {
    final updated = [...state.requireValue, file];
    await ref.read(profileRepositoryProvider).saveFiles(updated);
    state = AsyncData(updated);
  }

  Future<void> delete(int index) async {
    final list = [...state.requireValue];
    list.removeAt(index);
    await ref.read(profileRepositoryProvider).saveFiles(list);
    state = AsyncData(list);
  }
}

final profileFilesProvider =
    AsyncNotifierProvider<ProfileFilesNotifier, List<UploadedFile>>(
  ProfileFilesNotifier.new,
);

// ─── Values ───────────────────────────────────────────────────────────────────

class ProfileValuesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() =>
      ref.read(profileRepositoryProvider).getValues();

  Future<void> update(List<String> values) async {
    await ref.read(profileRepositoryProvider).saveValues(values);
    state = AsyncData(values);
  }
}

final profileValuesProvider =
    AsyncNotifierProvider<ProfileValuesNotifier, List<String>>(
  ProfileValuesNotifier.new,
);

// ─── Job Preferences ──────────────────────────────────────────────────────────

class ProfileJobPreferencesNotifier
    extends AsyncNotifier<ProfileJobPreferences> {
  @override
  Future<ProfileJobPreferences> build() =>
      ref.read(profileRepositoryProvider).getJobPreferences();

  Future<void> update({
    required List<JobInterest> interests,
    required String positionLevel,
    required String jobType,
    required String workplace,
    double? expectedSalary,
    required bool preferNotToSpecifySalary,
  }) async {
    final updated = ProfileJobPreferences(
      jobInterests: interests,
      positionLevel: positionLevel,
      jobType: jobType,
      workplace: workplace,
      expectedSalary: expectedSalary,
      preferNotToSpecifySalary: preferNotToSpecifySalary,
    );
    await ref.read(profileRepositoryProvider).saveJobPreferences(updated);
    state = AsyncData(updated);
  }
}

final profileJobPreferencesProvider =
    AsyncNotifierProvider<ProfileJobPreferencesNotifier, ProfileJobPreferences>(
  ProfileJobPreferencesNotifier.new,
);

// ─── Profile Visible ──────────────────────────────────────────────────────────

class ProfileVisibleNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() =>
      ref.read(profileRepositoryProvider).getProfileVisible();

  Future<void> toggle() async {
    final updated = !state.requireValue;
    await ref.read(profileRepositoryProvider).saveProfileVisible(updated);
    state = AsyncData(updated);
  }
}

final profileVisibleProvider =
    AsyncNotifierProvider<ProfileVisibleNotifier, bool>(
  ProfileVisibleNotifier.new,
);

// ─── Profile Completion (derived) ─────────────────────────────────────────────

final profileCompletionProvider = Provider<double>((ref) {
  final photoUrl =
      ref.watch(profileBasicsProvider).valueOrNull?.photoUrl;
  final bio =
      ref.watch(profileAboutMeProvider).valueOrNull?.bio ?? '';
  final experiences =
      ref.watch(profileWorkExperiencesProvider).valueOrNull ?? [];
  final educations =
      ref.watch(profileEducationsProvider).valueOrNull ?? [];
  final skills = ref.watch(profileSkillsProvider).valueOrNull;
  final files =
      ref.watch(profileFilesProvider).valueOrNull ?? [];

  int filled = 0;
  if (bio.isNotEmpty) filled++;
  if (photoUrl != null) filled++;
  if (experiences.isNotEmpty) filled++;
  if (educations.isNotEmpty) filled++;
  if (skills != null &&
      (skills.hardSkills.isNotEmpty || skills.softSkills.isNotEmpty)) filled++;
  if (files.isNotEmpty) filled++;
  return filled / 6;
});
```

- [ ] **Step 2: Verify compilation of profile_provider.dart**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze lib/providers/profile_provider.dart 2>&1 | head -20`
Expected: Errors only in consumer widgets (fixed in Task 4)

- [ ] **Step 3: Commit**

```bash
git add lib/providers/profile_provider.dart
git commit -m "feat: convert profile notifiers to AsyncNotifier"
```

---

### Task 4: Refactor HomeRepository to async + create HomeNotifier

**Files:**
- Modify: `lib/repositories/home_repository.dart`
- Create: `lib/providers/home_provider.dart`

- [ ] **Step 1: Convert HomeRepository to async methods**

Replace `lib/repositories/home_repository.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_models.dart';

class HomeData {
  final String userName;
  final String userInitials;
  final CvStats cvStats;
  final List<JobRecommendation> jobs;
  final List<Course> courses;
  final List<NewsItem> news;
  final bool isNewUser;
  final List<ProfileItem> profileItems;
  final List<String> profileBenefits;
  final List<String> filterChips;

  const HomeData({
    required this.userName,
    required this.userInitials,
    required this.cvStats,
    required this.jobs,
    required this.courses,
    required this.news,
    required this.isNewUser,
    required this.profileItems,
    required this.profileBenefits,
    required this.filterChips,
  });
}

abstract class HomeRepository {
  Future<HomeData> getData();
}

class MockHomeRepository implements HomeRepository {
  @override
  Future<HomeData> getData() async => const HomeData(
    userName: 'Christos',
    userInitials: 'CI',
    cvStats: CvStats(
      views: 150,
      viewsChange: 2,
      invitations: 12,
      invitationsChange: 2,
      applicationsSent: 20,
      interviews: 3,
    ),
    jobs: [
      JobRecommendation(
        companyName: 'TechWave',
        companyInitials: 'TW',
        companyColor: Color(0xFF6B4EAA),
        jobTitle: 'Junior Front-End Developer',
        salary: '1,500 \u20ac / month',
        matchPercentage: 100,
        matchLabel: 'STRONG MATCH',
        location: 'Athens',
        workMode: 'On-site',
        employmentType: 'Full-Time',
        level: 'Entry',
      ),
      JobRecommendation(
        companyName: 'TechWave',
        companyInitials: 'DS',
        companyColor: Color(0xFF2E7D32),
        jobTitle: 'Junior Front-End Developer',
        salary: '1,500 \u20ac / month',
        matchPercentage: 100,
        matchLabel: 'STRONG MATCH',
        location: 'Athens',
        workMode: 'On-site',
        employmentType: 'Full-Time',
        level: 'Entry',
      ),
      JobRecommendation(
        companyName: 'TechWave',
        companyInitials: 'FT',
        companyColor: Color(0xFF1A237E),
        jobTitle: 'Middle Front-End Developer',
        salary: '2,500 \u20ac / month',
        matchPercentage: 100,
        matchLabel: 'STRONG MATCH',
        location: 'Athens',
        workMode: 'On-site',
        employmentType: 'Full-Time',
        level: 'Entry',
      ),
    ],
    courses: [
      Course(
        title: 'Modern React Development',
        tags: ['#Frontend', '#Middle'],
        description:
            'Learn how to build fast and scalable UI using React, Hooks, and modern component patterns. This course will help you structure real-world applications and improve your state-management skills.',
        format: 'Online',
        duration: '20 hours',
        level: 'For Middle',
      ),
      Course(
        title: 'JavaScript Advanced Essentials',
        tags: ['#Frontend', '#Middle'],
        description:
            'Learn how to build fast and scalable UI using React, Hooks, and modern component patterns. This course will help you structure real-world applications and improve your state-management skills.',
        format: 'Online',
        duration: '20 hours',
        level: 'For Beginners',
      ),
    ],
    news: [
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
    ],
    isNewUser: true,
    profileItems: [
      ProfileItem(label: 'About Me', completed: true),
      ProfileItem(label: 'Photo', completed: true),
      ProfileItem(label: 'My Experience', completed: false),
      ProfileItem(label: 'My Education', completed: false),
      ProfileItem(label: 'My Skills', completed: false),
      ProfileItem(label: 'Documents', completed: false),
    ],
    profileBenefits: [
      'Get job recommendations tailored to your skills.',
      'Receive tips and resources to boost your career.',
      'Increase visibility to potential employers.',
    ],
    filterChips: [
      'Your Perfect Match',
      'Jobs near me',
      'Suitable for my experience',
      'Limited time',
    ],
  );
}

final homeRepositoryProvider = Provider<HomeRepository>(
  (_) => MockHomeRepository(),
);
```

- [ ] **Step 2: Create HomeNotifier**

Create `lib/providers/home_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/home_repository.dart';

export '../repositories/home_repository.dart' show HomeData;

class HomeNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() =>
      ref.read(homeRepositoryProvider).getData();
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeData>(
  HomeNotifier.new,
);
```

- [ ] **Step 3: Update all home widgets to use homeProvider**

**`lib/screens/home/home_screen.dart`:**
Replace `import '../../repositories/home_repository.dart';` with `import '../../providers/home_provider.dart';`
Replace `final homeRepo = ref.watch(homeRepositoryProvider);` with:
```dart
final homeAsync = ref.watch(homeProvider);
```
Then wrap the body with `homeAsync.when(data: ..., loading: ..., error: ...)` or use `homeAsync.valueOrNull` for a simpler approach. Since this is mock data that resolves instantly, use `.valueOrNull` with an early return:
```dart
final homeData = ref.watch(homeProvider).valueOrNull;
if (homeData == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
```
Then replace `homeRepo.xxx` → `homeData.xxx`.

**`lib/screens/home/widgets/home_greeting_header.dart`:**
Replace import to `../../../providers/home_provider.dart`
Replace `final homeRepo = ref.watch(homeRepositoryProvider);` with:
```dart
final homeData = ref.watch(homeProvider).valueOrNull;
if (homeData == null) return const SizedBox.shrink();
```
Replace `homeRepo.` → `homeData.`

**`lib/screens/home/widgets/home_search_section.dart`:**
Same pattern — import `home_provider.dart`, use `ref.watch(homeProvider).valueOrNull`, early return `SizedBox.shrink()`.

**`lib/screens/home/widgets/home_courses_section.dart`:**
Same pattern.

**`lib/screens/home/widgets/home_profile_completion_card.dart`:**
Same pattern. Replace both `homeRepositoryProvider` and keep `profileCompletionProvider`.

**`lib/screens/home/widgets/home_news_section.dart`:**
Replace `final newsList = ref.watch(homeRepositoryProvider).news;` with:
```dart
final newsList = ref.watch(homeProvider).valueOrNull?.news ?? [];
```

**`lib/screens/home/widgets/home_jobs_section.dart`:**
Same pattern.

- [ ] **Step 4: Verify compilation**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze 2>&1 | head -30`

- [ ] **Step 5: Commit**

```bash
git add lib/repositories/home_repository.dart lib/providers/home_provider.dart lib/screens/home/
git commit -m "feat: make HomeRepository async with HomeNotifier"
```

---

### Task 5: Refactor JobSearchRepository with search method

**Files:**
- Modify: `lib/repositories/job_search_repository.dart`
- Create: `lib/providers/job_search_data_provider.dart`

- [ ] **Step 1: Refactor JobSearchRepository abstract class**

```dart
// lib/repositories/job_search_repository.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_search_models.dart';

class JobSearchResult {
  final List<JobListing> jobs;
  final int totalJobs;
  final int totalPages;

  const JobSearchResult({
    required this.jobs,
    required this.totalJobs,
    required this.totalPages,
  });
}

abstract class JobSearchRepository {
  Future<JobSearchResult> search({
    Map<String, Set<String>> filters = const {},
    String sort = 'Date: Recent',
    int page = 1,
  });

  Future<Set<String>> getSavedJobIds();
  Future<void> saveJob(String jobId);
  Future<void> unsaveJob(String jobId);
}

class MockJobSearchRepository implements JobSearchRepository {
  final Set<String> _savedIds = {};

  static const _allJobs = [
    JobListing(
      id: 'job-1',
      jobTitle: 'Office Secretary',
      companyName: 'HelioForce Studio',
      companyInitials: 'HS',
      companyColor: Color(0xFF6B4EAA),
      salary: '2,000 \u20ac/ month',
      matchPercentage: 90,
      matchLabel: 'STRONG MATCH',
      category: 'Design and Creative',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-2',
      jobTitle: 'Junior Front-End Developer',
      companyName: 'TechWave',
      companyInitials: 'TW',
      companyColor: Color(0xFF2E7D32),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 82,
      matchLabel: 'GREAT MATCH',
      category: 'IT and Web Development',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-3',
      jobTitle: 'Pianist',
      companyName: 'Aegean Waves Hotel & Restaurant',
      companyInitials: 'AW',
      companyColor: Color(0xFF795548),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 35,
      matchLabel: 'WEAK MATCH',
      category: 'Arts, Entertainment and Music',
      location: 'Chalkida',
      workMode: 'On-site',
      employmentType: 'Part-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-4',
      jobTitle: 'Cashier - Grocery Store',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: Color(0xFF1B5E20),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 78,
      matchLabel: 'GREAT MATCH',
      category: 'Sales',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-5',
      jobTitle: 'Office Assistant',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: Color(0xFF37474F),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 0,
      matchLabel: 'NO BENEFICIARIES MATCH',
      category: 'Logistics and Supply Chain',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-6',
      jobTitle: 'Junior Photographer',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: Color(0xFF37474F),
      salary: '1,800 \u20ac/ month',
      matchPercentage: 80,
      matchLabel: 'GREAT MATCH',
      category: 'Design and Creative',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Part-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-7',
      jobTitle: 'Cashier',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: Color(0xFF1B5E20),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 65,
      matchLabel: 'GOOD MATCH',
      category: 'Customer Service',
      location: 'Thessaloniki',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-8',
      jobTitle: 'Administrative Assistant',
      companyName: 'Global Solutions Corp',
      companyInitials: 'GS',
      companyColor: Color(0xFF0D47A1),
      salary: '2,800 \u20ac/ month',
      matchPercentage: 92,
      matchLabel: 'STRONG MATCH',
      category: 'Admin and Secretarial',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-9',
      jobTitle: 'Data Entry Clerk',
      companyName: 'MyTech Solutions',
      companyInitials: 'MT',
      companyColor: Color(0xFF4A148C),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 68,
      matchLabel: 'GOOD MATCH',
      category: 'Admin and Secretarial',
      workMode: 'Remote',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-10',
      jobTitle: 'Marketing Intern',
      companyName: 'Creative Agency',
      companyInitials: 'CA',
      companyColor: Color(0xFFE65100),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 62,
      matchLabel: 'GOOD MATCH',
      category: 'Marketing',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
  ];

  @override
  Future<JobSearchResult> search({
    Map<String, Set<String>> filters = const {},
    String sort = 'Date: Recent',
    int page = 1,
  }) async {
    // Mock: return all jobs regardless of filters (real impl will filter server-side)
    return const JobSearchResult(
      jobs: _allJobs,
      totalJobs: 1500,
      totalPages: 25,
    );
  }

  @override
  Future<Set<String>> getSavedJobIds() async => Set.from(_savedIds);

  @override
  Future<void> saveJob(String jobId) async => _savedIds.add(jobId);

  @override
  Future<void> unsaveJob(String jobId) async => _savedIds.remove(jobId);
}

final jobSearchRepositoryProvider = Provider<JobSearchRepository>(
  (_) => MockJobSearchRepository(),
);
```

- [ ] **Step 2: Create JobSearchDataNotifier**

Create `lib/providers/job_search_data_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/job_search_repository.dart';
import 'job_search_provider.dart';

export '../repositories/job_search_repository.dart' show JobSearchResult;

class JobSearchDataNotifier extends AsyncNotifier<JobSearchResult> {
  @override
  Future<JobSearchResult> build() {
    final searchState = ref.watch(jobSearchProvider);
    return ref.read(jobSearchRepositoryProvider).search(
      filters: searchState.filters,
      sort: searchState.sortOption,
      page: searchState.currentPage,
    );
  }
}

final jobSearchDataProvider =
    AsyncNotifierProvider<JobSearchDataNotifier, JobSearchResult>(
  JobSearchDataNotifier.new,
);
```

- [ ] **Step 3: Verify compilation**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze 2>&1 | head -30`

- [ ] **Step 4: Commit**

```bash
git add lib/repositories/job_search_repository.dart lib/providers/job_search_data_provider.dart
git commit -m "feat: make JobSearchRepository async with search method"
```

---

### Task 6: Change savedJobIndices from Set<int> to Set<String>

**Files:**
- Modify: `lib/providers/job_search_provider.dart`
- Modify: `lib/screens/job_search/widgets/job_search_list.dart`
- Modify: `lib/screens/job_search/widgets/job_search_tab_bar.dart`

- [ ] **Step 1: Refactor JobSearchState and JobSearchNotifier**

Replace `lib/providers/job_search_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/job_search_repository.dart';

class JobSearchState {
  final int selectedTab;
  final int currentPage;
  final String sortOption;
  final Set<String> savedJobIds;
  final Map<String, Set<String>> filters;

  const JobSearchState({
    this.selectedTab = 0,
    this.currentPage = 1,
    this.sortOption = 'Date: Recent',
    this.savedJobIds = const {},
    this.filters = const {
      'Location': {},
      'Industry': {},
      'Skills': {},
      'Job Type': {},
      'Workplace': {},
      'Experience Level': {},
      'Salary': {},
      'Travel': {},
    },
  });

  int get activeFilterCount =>
      filters.values.fold(0, (sum, s) => sum + s.length);

  int get savedCount => savedJobIds.length;

  bool isSaved(String jobId) => savedJobIds.contains(jobId);

  JobSearchState copyWith({
    int? selectedTab,
    int? currentPage,
    String? sortOption,
    Set<String>? savedJobIds,
    Map<String, Set<String>>? filters,
  }) =>
      JobSearchState(
        selectedTab: selectedTab ?? this.selectedTab,
        currentPage: currentPage ?? this.currentPage,
        sortOption: sortOption ?? this.sortOption,
        savedJobIds: savedJobIds ?? this.savedJobIds,
        filters: filters ?? this.filters,
      );
}

class JobSearchNotifier extends AsyncNotifier<JobSearchState> {
  @override
  Future<JobSearchState> build() async {
    final savedIds =
        await ref.read(jobSearchRepositoryProvider).getSavedJobIds();
    return JobSearchState(savedJobIds: savedIds);
  }

  void selectTab(int tab) =>
      state = AsyncData(state.requireValue.copyWith(selectedTab: tab));

  void changePage(int page) =>
      state = AsyncData(state.requireValue.copyWith(currentPage: page));

  void nextPage(int totalPages) {
    final current = state.requireValue;
    if (current.currentPage < totalPages) {
      state = AsyncData(current.copyWith(currentPage: current.currentPage + 1));
    }
  }

  void setSort(String option) =>
      state = AsyncData(state.requireValue.copyWith(sortOption: option));

  Future<void> toggleSaved(String jobId) async {
    final current = state.requireValue;
    final updated = Set<String>.from(current.savedJobIds);
    if (updated.contains(jobId)) {
      updated.remove(jobId);
      await ref.read(jobSearchRepositoryProvider).unsaveJob(jobId);
    } else {
      updated.add(jobId);
      await ref.read(jobSearchRepositoryProvider).saveJob(jobId);
    }
    state = AsyncData(current.copyWith(savedJobIds: updated));
  }

  void applyFilters(Map<String, Set<String>> updated) {
    final current = state.requireValue;
    final merged = Map<String, Set<String>>.from(current.filters);
    for (final e in updated.entries) {
      merged[e.key] = e.value;
    }
    state = AsyncData(current.copyWith(filters: merged));
  }

  void resetFilters() {
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(filters: {for (final k in current.filters.keys) k: {}}),
    );
  }
}

final jobSearchProvider =
    AsyncNotifierProvider<JobSearchNotifier, JobSearchState>(
  JobSearchNotifier.new,
);
```

- [ ] **Step 2: Update job_search_list.dart**

In `lib/screens/job_search/widgets/job_search_list.dart`:

Add import for the data provider:
```dart
import '../../../providers/job_search_data_provider.dart';
```

Update the `build` method of `JobSearchList`:
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final searchState = ref.watch(jobSearchProvider).valueOrNull;
  final searchResult = ref.watch(jobSearchDataProvider).valueOrNull;
  if (searchState == null || searchResult == null) {
    return const Center(child: CircularProgressIndicator());
  }

  final notifier = ref.read(jobSearchProvider.notifier);
  final jobs = searchResult.jobs;

  // ... rest of widget tree stays same but update:
  // '${_fmt(jobSearchRepo.totalJobs)} jobs found' → '${_fmt(searchResult.totalJobs)} jobs found'
  // isSaved: savedIndices.contains(i) → isSaved: searchState.isSaved(jobs[i].id)
  // onSave: () => notifier.toggleSaved(i) → onSave: () => notifier.toggleSaved(jobs[i].id)
```

Update `JobSearchPagination`:
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final totalPages = ref.watch(jobSearchDataProvider).valueOrNull?.totalPages ?? 0;
  final currentPage =
      ref.watch(jobSearchProvider).valueOrNull?.currentPage ?? 1;
  final notifier = ref.read(jobSearchProvider.notifier);
  // ... rest stays same
```

- [ ] **Step 3: Update job_search_tab_bar.dart**

In `lib/screens/job_search/widgets/job_search_tab_bar.dart`:

Remove `import '../../../repositories/job_search_repository.dart';`

Update:
```dart
final selectedTab = ref.watch(jobSearchProvider).valueOrNull?.selectedTab ?? 0;
// ...
label: 'Saved (${ref.watch(jobSearchProvider).valueOrNull?.savedCount ?? 0})',
```

- [ ] **Step 4: Verify compilation**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze 2>&1 | head -30`

- [ ] **Step 5: Commit**

```bash
git add lib/providers/job_search_provider.dart lib/providers/job_search_data_provider.dart lib/screens/job_search/widgets/
git commit -m "feat: change savedJobIndices to savedJobIds (Set<String>) and use job IDs"
```

---

### Task 7: Update all profile widget consumers for AsyncValue

**Files:**
- Modify: All screens that `ref.watch` profile providers (see list below)

The pattern for each widget that watches a profile `AsyncNotifier`:
- `ref.watch(profileXxxProvider)` now returns `AsyncValue<T>` instead of `T`
- Use `.valueOrNull` for safe access, or `.when()` for full loading/error handling
- For `ref.read()` in `initState`, use `.valueOrNull` or `.requireValue`
- For `ref.read(xxxProvider.notifier).update(...)`, the method is now async (fire and forget is OK from UI)

**Widgets to update and their patterns:**

- [ ] **Step 1: `lib/screens/profile/profile_screen.dart`**

```dart
final basics = ref.watch(profileBasicsProvider).valueOrNull;
if (basics == null) return const Center(child: CircularProgressIndicator());
// Then use basics.xxx as before
```

- [ ] **Step 2: `lib/screens/profile/profile_basics_screen.dart`**

In `initState()`:
```dart
final basics = ref.read(profileBasicsProvider).valueOrNull;
if (basics == null) return; // data not yet loaded
// ... rest of initState
```

In `_save()`:
```dart
ref.read(profileBasicsProvider.notifier).update(...); // now returns Future, fire-and-forget is OK
```

- [ ] **Step 3: `lib/screens/profile/edit_about_me_screen.dart`**

Same pattern as profile_basics_screen — use `.valueOrNull` in `initState`, fire-and-forget in save.

- [ ] **Step 4: Profile tab files**

Each tab file follows the same pattern — add `.valueOrNull` and null check:

`lib/screens/profile/tabs/profile_about_me_tab.dart`:
```dart
final aboutMe = ref.watch(profileAboutMeProvider).valueOrNull;
if (aboutMe == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/tabs/profile_skills_tab.dart`:
```dart
final skills = ref.watch(profileSkillsProvider).valueOrNull;
if (skills == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/tabs/profile_work_experience_tab.dart`:
```dart
final experiences = ref.watch(profileWorkExperiencesProvider).valueOrNull;
if (experiences == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/tabs/profile_education_tab.dart`:
```dart
final educations = ref.watch(profileEducationsProvider).valueOrNull;
if (educations == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/tabs/profile_files_tab.dart`:
```dart
final files = ref.watch(profileFilesProvider).valueOrNull;
if (files == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/tabs/profile_values_tab.dart`:
```dart
final values = ref.watch(profileValuesProvider).valueOrNull;
if (values == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/tabs/profile_job_preferences_tab.dart`:
```dart
final prefs = ref.watch(profileJobPreferencesProvider).valueOrNull;
if (prefs == null) return const Center(child: CircularProgressIndicator());
```

- [ ] **Step 5: Settings screens**

`lib/screens/settings/notifications_screen.dart`:
```dart
final phone = ref.watch(profileBasicsProvider).valueOrNull?.phone ?? '';
```

`lib/screens/settings/tabs/notifications_tab.dart`:
```dart
final profile = ref.watch(profileBasicsProvider).valueOrNull;
if (profile == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/settings/tabs/account_settings_tab.dart`:
```dart
final profile = ref.watch(profileBasicsProvider).valueOrNull;
final profileVisible = ref.watch(profileVisibleProvider).valueOrNull ?? true;
if (profile == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/settings/sheets/change_phone_sheet.dart`:
```dart
final profile = ref.watch(profileBasicsProvider).valueOrNull;
if (profile == null) return const SizedBox.shrink();
```

`lib/screens/settings/sheets/change_email_sheet.dart`:
```dart
final profile = ref.watch(profileBasicsProvider).valueOrNull;
if (profile == null) return const SizedBox.shrink();
```

- [ ] **Step 6: Job search screen**

`lib/screens/job_search/job_search_screen.dart`:
```dart
avatarInitials: ref.watch(profileBasicsProvider).valueOrNull?.initials ?? '',
// ...
profileProgress: ref.watch(profileCompletionProvider),
```

- [ ] **Step 7: Profile header and widgets**

`lib/widgets/profile_header_card.dart`:
```dart
final prefs = ref.watch(profileJobPreferencesProvider).valueOrNull;
if (prefs == null) return const SizedBox.shrink();
```

- [ ] **Step 8: Work experience and education screens**

`lib/screens/profile/work_experience_screen.dart`:
```dart
final experiences = ref.watch(profileWorkExperiencesProvider).valueOrNull;
if (experiences == null) return const Center(child: CircularProgressIndicator());
```

`lib/screens/profile/education_screen.dart`:
```dart
final educations = ref.watch(profileEducationsProvider).valueOrNull;
if (educations == null) return const Center(child: CircularProgressIndicator());
```

- [ ] **Step 9: Update job_search_search_bar.dart**

```dart
final count = ref.watch(jobSearchProvider).valueOrNull?.activeFilterCount ?? 0;
```

- [ ] **Step 10: Verify full compilation**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze 2>&1 | tail -10`
Expected: 0 errors

- [ ] **Step 11: Commit**

```bash
git add lib/screens/ lib/widgets/
git commit -m "feat: update all widget consumers for AsyncValue from async providers"
```

---

### Task 8: Update tests for async notifiers

**Files:**
- Modify: `test/providers/provider_test.dart`

- [ ] **Step 1: Update fake notifiers to extend AsyncNotifier**

The fake notifiers used for profileCompletionProvider tests need to return `Future`:

```dart
class _BioFilledNotifier extends ProfileAboutMeNotifier {
  @override
  Future<ProfileAboutMe> build() async => const ProfileAboutMe(bio: 'Pre-set bio');
}

class _PhotoFilledNotifier extends ProfileBasicsNotifier {
  @override
  Future<ProfileBasics> build() async =>
      const ProfileBasics(photoUrl: 'https://img.test/photo.jpg');
}

class _OneExpNotifier extends ProfileWorkExperiencesNotifier {
  @override
  Future<List<WorkExperience>> build() async => const [
        WorkExperience(
          jobTitle: 'Dev', companyName: 'Co', location: 'City',
          experienceLevel: 'Mid', workplace: 'Remote',
          jobType: 'Full time', startDate: '01-2020',
        ),
      ];
}

class _OneEduNotifier extends ProfileEducationsNotifier {
  @override
  Future<List<Education>> build() async => const [
        Education(
          institutionName: 'Uni', fieldOfStudy: 'CS', location: 'City',
          degreeType: 'Bachelor', startDate: '09-2015',
        ),
      ];
}

class _OneSkillNotifier extends ProfileSkillsNotifier {
  @override
  Future<ProfileSkills> build() async => const ProfileSkills(hardSkills: ['Dart']);
}

class _OneFileNotifier extends ProfileFilesNotifier {
  @override
  Future<List<UploadedFile>> build() async =>
      const [UploadedFile(name: 'cv.pdf', size: '1 MB')];
}
```

- [ ] **Step 2: Update profile provider tests to use async patterns**

For tests that read profile providers, the state is now `AsyncValue<T>`. After creating the container, you need to wait for the async build to complete:

```dart
group('profileBasicsProvider', () {
  test('initial state has hard-coded defaults', () async {
    final c = ProviderContainer.test();
    // Wait for async build to resolve
    await c.read(profileBasicsProvider.future);
    final s = c.read(profileBasicsProvider).requireValue;
    expect(s.firstName, 'Christos');
    expect(s.lastName, 'Ioannides');
    expect(s.email, 'c.ioannidis@gmail.com');
    expect(s.photoUrl, isNull);
  });

  test('update replaces the provided fields', () async {
    final c = ProviderContainer.test();
    await c.read(profileBasicsProvider.future);
    await c.read(profileBasicsProvider.notifier).update(
      firstName: 'Maria',
      // ... all required fields
    );
    final s = c.read(profileBasicsProvider).requireValue;
    expect(s.firstName, 'Maria');
  });
});
```

Apply this pattern to ALL profile provider test groups:
- `profileBasicsProvider` tests → add `async`, `await .future`, use `.requireValue`
- `profileAboutMeProvider` tests → same
- `profileSkillsProvider` tests → same
- `profileWorkExperiencesProvider` tests → same
- `profileEducationsProvider` tests → same
- `profileFilesProvider` tests → same
- `profileValuesProvider` tests → same
- `profileJobPreferencesProvider` tests → same
- `profileVisibleProvider` tests → same
- `profileCompletionProvider` tests → await all futures before reading completion

For `profileCompletionProvider` tests with overrides:
```dart
test('all-filled yields 1.0', () async {
  final c = ProviderContainer.test(overrides: [
    profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
    profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
    profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
    profileEducationsProvider.overrideWith(_OneEduNotifier.new),
    profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
    profileFilesProvider.overrideWith(_OneFileNotifier.new),
  ]);
  // Wait for all async builds
  await Future.wait([
    c.read(profileBasicsProvider.future),
    c.read(profileAboutMeProvider.future),
    c.read(profileWorkExperiencesProvider.future),
    c.read(profileEducationsProvider.future),
    c.read(profileSkillsProvider.future),
    c.read(profileFilesProvider.future),
  ]);
  expect(c.read(profileCompletionProvider), closeTo(1.0, 0.01));
});
```

- [ ] **Step 3: Run tests**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter test 2>&1 | tail -20`
Expected: All tests pass

- [ ] **Step 4: Commit**

```bash
git add test/
git commit -m "test: update provider tests for async notifiers"
```

---

### Task 9: Final verification

- [ ] **Step 1: Run full analysis**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter analyze 2>&1`
Expected: 0 errors

- [ ] **Step 2: Run all tests**

Run: `cd c:/Users/User/Desktop/Ithaki && flutter test 2>&1`
Expected: All 303+ tests pass

- [ ] **Step 3: Final commit if any remaining fixes**

```bash
git add -A
git commit -m "fix: resolve remaining compilation issues from async migration"
```
