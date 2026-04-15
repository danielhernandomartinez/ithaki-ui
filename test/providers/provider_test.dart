// test/providers/provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/providers/registration_provider.dart';

// ─── Fake notifiers used as overrides ────────────────────────────────────────
// These preset state so profileCompletionProvider tests stay declarative.

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
          jobTitle: 'Dev',
          companyName: 'Co',
          location: 'City',
          experienceLevel: 'Mid',
          workplace: 'Remote',
          jobType: 'Full time',
          startDate: '01-2020',
        ),
      ];
}

class _OneEduNotifier extends ProfileEducationsNotifier {
  @override
  Future<List<Education>> build() async => const [
        Education(
          institutionName: 'Uni',
          fieldOfStudy: 'CS',
          location: 'City',
          degreeType: 'Bachelor',
          startDate: '09-2015',
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

// ─── Shared test data ─────────────────────────────────────────────────────────

const _sampleExp = WorkExperience(
  jobTitle: 'Developer',
  companyName: 'Acme',
  location: 'Madrid',
  experienceLevel: 'Mid',
  workplace: 'Remote',
  jobType: 'Full time',
  startDate: '01-2020',
);

const _sampleEdu = Education(
  institutionName: 'UPM',
  fieldOfStudy: 'Computer Science',
  location: 'Madrid',
  degreeType: 'Bachelor',
  startDate: '09-2015',
  endDate: '06-2019',
);

const _sampleFile = UploadedFile(name: 'cv.pdf', size: '120 KB');

// In Riverpod 3.x, ProviderContainer.test() is the correct testing factory:
// it automatically registers addTearDown(container.dispose).
// Override is a sealed class not exported from the public API, so it cannot be
// used as a type annotation; pass override lists directly to the named parameter.

void main() {
  // ─── registrationProvider ─────────────────────────────────────────────────

  group('registrationProvider', () {
    test('initial state is all-empty', () {
      final c = ProviderContainer.test();
      final s = c.read(registrationProvider);
      expect(s.language, '');
      expect(s.techLevel, '');
      expect(s.email, '');
      expect(s.password, '');
      expect(s.name, '');
      expect(s.lastName, '');
      expect(s.phone, '');
      expect(s.verifyMethod, '');
      expect(s.rememberVerifyChoice, false);
    });

    test('setLanguage updates language only', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier).setLanguage('es');
      final s = c.read(registrationProvider);
      expect(s.language, 'es');
      expect(s.email, ''); // other fields untouched
    });

    test('setTechLevel updates techLevel', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier).setTechLevel('advanced');
      expect(c.read(registrationProvider).techLevel, 'advanced');
    });

    test('setCredentials updates email and password together', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier).setCredentials('a@b.com', 'pass123');
      final s = c.read(registrationProvider);
      expect(s.email, 'a@b.com');
      expect(s.password, 'pass123');
    });

    test('setPersonalDetails updates name, lastName and phone', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier)
          .setPersonalDetails('Ana', 'López', '+34 600 000 000');
      final s = c.read(registrationProvider);
      expect(s.name, 'Ana');
      expect(s.lastName, 'López');
      expect(s.phone, '+34 600 000 000');
    });

    test('setVerifyMethod with remember=true', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier)
          .setVerifyMethod('email', remember: true);
      final s = c.read(registrationProvider);
      expect(s.verifyMethod, 'email');
      expect(s.rememberVerifyChoice, true);
    });

    test('setVerifyMethod defaults remember to false', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier).setVerifyMethod('sms');
      expect(c.read(registrationProvider).rememberVerifyChoice, false);
    });

    test('reset clears all fields back to initial', () {
      final c = ProviderContainer.test();
      c.read(registrationProvider.notifier).setLanguage('fr');
      c.read(registrationProvider.notifier)
          .setCredentials('x@y.com', 'secret');
      c.read(registrationProvider.notifier).reset();
      final s = c.read(registrationProvider);
      expect(s.language, '');
      expect(s.email, '');
      expect(s.password, '');
    });
  });

  // ─── profileBasicsProvider ────────────────────────────────────────────────

  group('profileBasicsProvider', () {
    test('initial state has hard-coded defaults', () async {
      final c = ProviderContainer.test(overrides: [
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
      ]);
      final s = await c.read(profileBasicsProvider.future);
      expect(s.firstName, 'Christos');
      expect(s.lastName, 'Ioannides');
      expect(s.email, 'c.ioannidis@gmail.com');
      expect(s.photoUrl, 'https://img.test/photo.jpg');
    });

    test('save replaces the provided fields', () async {
      final c = ProviderContainer.test(overrides: [
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
      ]);
      await c.read(profileBasicsProvider.future);
      await c.read(profileBasicsProvider.notifier).save(
            firstName: 'Maria',
            lastName: 'García',
            dateOfBirth: '15-06-1990',
            gender: 'Female',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'No',
          );
      final s = c.read(profileBasicsProvider).requireValue;
      expect(s.firstName, 'Maria');
      expect(s.lastName, 'García');
      expect(s.gender, 'Female');
    });

    test('save with photoUrl sets photoUrl', () async {
      final c = ProviderContainer.test(overrides: [
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
      ]);
      await c.read(profileBasicsProvider.future);
      await c.read(profileBasicsProvider.notifier).save(
            firstName: 'X',
            lastName: 'Y',
            dateOfBirth: '01-01-2000',
            gender: 'Male',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'Yes',
            photoUrl: 'https://cdn.test/avatar.jpg',
          );
      expect(c.read(profileBasicsProvider).requireValue.photoUrl,
          'https://cdn.test/avatar.jpg');
    });
  });

  // ─── profileAboutMeProvider ───────────────────────────────────────────────

  group('profileAboutMeProvider', () {
    test('initial bio is empty, videoUrl is null', () async {
      final c = ProviderContainer.test(overrides: [
        profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
      ]);
      final s = await c.read(profileAboutMeProvider.future);
      expect(s.bio, 'Pre-set bio');
      expect(s.videoUrl, isNull);
    });

    test('save sets bio and videoUrl', () async {
      final c = ProviderContainer.test(overrides: [
        profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
      ]);
      await c.read(profileAboutMeProvider.future);
      await c.read(profileAboutMeProvider.notifier)
          .save('Software dev', videoUrl: 'https://youtu.be/xyz');
      final s = c.read(profileAboutMeProvider).requireValue;
      expect(s.bio, 'Software dev');
      expect(s.videoUrl, 'https://youtu.be/xyz');
    });

    test('save with only bio leaves videoUrl null', () async {
      final c = ProviderContainer.test(overrides: [
        profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
      ]);
      await c.read(profileAboutMeProvider.future);
      await c.read(profileAboutMeProvider.notifier).save('Just bio');
      expect(c.read(profileAboutMeProvider).requireValue.videoUrl, isNull);
    });

    test('save overwrites previous bio', () async {
      final c = ProviderContainer.test(overrides: [
        profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
      ]);
      await c.read(profileAboutMeProvider.future);
      await c.read(profileAboutMeProvider.notifier).save('First');
      await c.read(profileAboutMeProvider.notifier).save('Second');
      expect(c.read(profileAboutMeProvider).requireValue.bio, 'Second');
    });
  });

  // ─── profileSkillsProvider ────────────────────────────────────────────────

  group('profileSkillsProvider', () {
    test('initial state is fully empty', () async {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      final s = await c.read(profileSkillsProvider.future);
      expect(s.hardSkills, ['Dart']);
      expect(s.softSkills, isEmpty);
      expect(s.languages, isEmpty);
      expect(s.competencies, isEmpty);
    });

    test('updateSkills sets hard and soft skills', () async {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      await c.read(profileSkillsProvider.future);
      await c.read(profileSkillsProvider.notifier)
          .updateSkills(['Dart', 'Flutter'], ['Teamwork']);
      final s = c.read(profileSkillsProvider).requireValue;
      expect(s.hardSkills, ['Dart', 'Flutter']);
      expect(s.softSkills, ['Teamwork']);
    });

    test('updateSkills replaces previous lists', () async {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      await c.read(profileSkillsProvider.future);
      await c.read(profileSkillsProvider.notifier).updateSkills(['A'], ['B']);
      await c.read(profileSkillsProvider.notifier).updateSkills(['C'], []);
      expect(c.read(profileSkillsProvider).requireValue.hardSkills, ['C']);
      expect(c.read(profileSkillsProvider).requireValue.softSkills, isEmpty);
    });

    test('updateLanguages sets language list', () async {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      await c.read(profileSkillsProvider.future);
      const lang = Language(language: 'English', proficiency: 'Fluent');
      await c.read(profileSkillsProvider.notifier).updateLanguages([lang]);
      expect(
          c.read(profileSkillsProvider).requireValue.languages.first.language,
          'English');
    });

    test('updateCompetencies sets competency map', () async {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      await c.read(profileSkillsProvider.future);
      await c.read(profileSkillsProvider.notifier)
          .updateCompetencies({'leadership': 'Advanced'});
      expect(c.read(profileSkillsProvider).requireValue.competencies,
          {'leadership': 'Advanced'});
    });
  });

  // ─── profileWorkExperiencesProvider ──────────────────────────────────────

  group('profileWorkExperiencesProvider', () {
    test('initial state is empty list', () async {
      final c = ProviderContainer.test(overrides: [
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
      ]);
      final result = await c.read(profileWorkExperiencesProvider.future);
      expect(result.length, 1);
    });

    test('add appends a new experience', () async {
      final c = ProviderContainer.test(overrides: [
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
      ]);
      await c.read(profileWorkExperiencesProvider.future);
      await c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      expect(c.read(profileWorkExperiencesProvider).requireValue.length, 2);
      expect(
          c.read(profileWorkExperiencesProvider).requireValue.elementAt(1).jobTitle,
          'Developer');
    });

    test('add twice results in two items', () async {
      final c = ProviderContainer.test(overrides: [
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
      ]);
      await c.read(profileWorkExperiencesProvider.future);
      await c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      await c.read(profileWorkExperiencesProvider.notifier)
          .add(_sampleExp.copyWith(jobTitle: 'Lead'));
      expect(c.read(profileWorkExperiencesProvider).requireValue.length, 3);
    });

    test('save replaces experience at given index', () async {
      final c = ProviderContainer.test(overrides: [
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
      ]);
      await c.read(profileWorkExperiencesProvider.future);
      await c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      await c.read(profileWorkExperiencesProvider.notifier)
          .save(1, _sampleExp.copyWith(jobTitle: 'Lead'));
      expect(
          c.read(profileWorkExperiencesProvider).requireValue.elementAt(1).jobTitle,
          'Lead');
    });
  });

  // ─── profileEducationsProvider ────────────────────────────────────────────

  group('profileEducationsProvider', () {
    test('initial state is empty list', () async {
      final c = ProviderContainer.test(overrides: [
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
      ]);
      final result = await c.read(profileEducationsProvider.future);
      expect(result.length, 1);
    });

    test('add appends a new education', () async {
      final c = ProviderContainer.test(overrides: [
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
      ]);
      await c.read(profileEducationsProvider.future);
      await c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      expect(c.read(profileEducationsProvider).requireValue.length, 2);
      expect(
          c.read(profileEducationsProvider).requireValue.elementAt(1).institutionName,
          'UPM');
    });

    test('add twice results in two items', () async {
      final c = ProviderContainer.test(overrides: [
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
      ]);
      await c.read(profileEducationsProvider.future);
      await c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      await c.read(profileEducationsProvider.notifier)
          .add(_sampleEdu.copyWith(degreeType: 'Master'));
      expect(c.read(profileEducationsProvider).requireValue.length, 3);
    });

    test('save replaces education at given index', () async {
      final c = ProviderContainer.test(overrides: [
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
      ]);
      await c.read(profileEducationsProvider.future);
      await c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      await c.read(profileEducationsProvider.notifier)
          .save(1, _sampleEdu.copyWith(degreeType: 'Master'));
      expect(
          c.read(profileEducationsProvider).requireValue.elementAt(1).degreeType,
          'Master');
    });
  });

  // ─── profileFilesProvider ─────────────────────────────────────────────────

  group('profileFilesProvider', () {
    test('initial state is empty list', () async {
      final c = ProviderContainer.test(overrides: [
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      final result = await c.read(profileFilesProvider.future);
      expect(result.length, 1);
    });

    test('add appends a file', () async {
      final c = ProviderContainer.test(overrides: [
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      await c.read(profileFilesProvider.future);
      await c.read(profileFilesProvider.notifier).add(_sampleFile);
      expect(c.read(profileFilesProvider).requireValue.length, 2);
      expect(c.read(profileFilesProvider).requireValue.elementAt(1).name, 'cv.pdf');
    });

    test('delete removes file at index, preserving order', () async {
      final c = ProviderContainer.test(overrides: [
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      await c.read(profileFilesProvider.future);
      const second = UploadedFile(name: 'cert.pdf', size: '50 KB');
      await c.read(profileFilesProvider.notifier).add(_sampleFile);
      await c.read(profileFilesProvider.notifier).add(second);
      await c.read(profileFilesProvider.notifier).delete(0);
      expect(c.read(profileFilesProvider).requireValue.length, 2);
      expect(c.read(profileFilesProvider).requireValue.first.name, '1 MB');
    });

    test('delete last item results in empty list', () async {
      final c = ProviderContainer.test(overrides: [
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      await c.read(profileFilesProvider.future);
      await c.read(profileFilesProvider.notifier).add(_sampleFile);
      await c.read(profileFilesProvider.notifier).delete(1);
      expect(c.read(profileFilesProvider).requireValue.length, 1);
    });
  });

  // ─── profileValuesProvider ────────────────────────────────────────────────

  group('profileValuesProvider', () {
    test('initial state is empty list', () async {
      expect(
          await ProviderContainer.test().read(profileValuesProvider.future),
          isEmpty);
    });

    test('save sets values list', () async {
      final c = ProviderContainer.test();
      await c.read(profileValuesProvider.future);
      await c.read(profileValuesProvider.notifier).save(['Integrity', 'Innovation']);
      expect(c.read(profileValuesProvider).requireValue,
          ['Integrity', 'Innovation']);
    });

    test('save replaces previous list entirely', () async {
      final c = ProviderContainer.test();
      await c.read(profileValuesProvider.future);
      await c.read(profileValuesProvider.notifier).save(['A', 'B', 'C']);
      await c.read(profileValuesProvider.notifier).save(['X']);
      expect(c.read(profileValuesProvider).requireValue, ['X']);
    });

    test('save with empty list clears values', () async {
      final c = ProviderContainer.test();
      await c.read(profileValuesProvider.future);
      await c.read(profileValuesProvider.notifier).save(['Integrity']);
      await c.read(profileValuesProvider.notifier).save([]);
      expect(c.read(profileValuesProvider).requireValue, isEmpty);
    });
  });

  // ─── profileJobPreferencesProvider ───────────────────────────────────────

  group('profileJobPreferencesProvider', () {
    test('initial state has expected defaults', () async {
      final c = ProviderContainer.test();
      final s = await c.read(profileJobPreferencesProvider.future);
      expect(s.positionLevel, 'Senior');
      expect(s.jobType, 'Full time');
      expect(s.workplace, 'On-site');
      expect(s.expectedSalary, 1800);
      expect(s.preferNotToSpecifySalary, false);
      expect(s.jobInterests, isNotEmpty);
    });

    test('save changes all preference fields', () async {
      final c = ProviderContainer.test();
      await c.read(profileJobPreferencesProvider.future);
      await c.read(profileJobPreferencesProvider.notifier).save(
            interests: [
              const JobInterest(title: 'PM', category: 'Management')
            ],
            positionLevel: 'Junior',
            jobType: 'Part time',
            workplace: 'Remote',
            expectedSalary: 1200,
            preferNotToSpecifySalary: false,
          );
      final s = c.read(profileJobPreferencesProvider).requireValue;
      expect(s.positionLevel, 'Junior');
      expect(s.jobType, 'Part time');
      expect(s.workplace, 'Remote');
      expect(s.expectedSalary, 1200);
      expect(s.jobInterests.first.title, 'PM');
    });

    test('preferNotToSpecifySalary can be toggled on', () async {
      final c = ProviderContainer.test();
      await c.read(profileJobPreferencesProvider.future);
      await c.read(profileJobPreferencesProvider.notifier).save(
            interests: [],
            positionLevel: 'Mid',
            jobType: 'Full time',
            workplace: 'Hybrid',
            preferNotToSpecifySalary: true,
          );
      expect(
          c.read(profileJobPreferencesProvider).requireValue.preferNotToSpecifySalary,
          true);
    });
  });

  // ─── profileVisibleProvider ───────────────────────────────────────────────

  group('profileVisibleProvider', () {
    test('initial state is true (visible)', () async {
      expect(
          await ProviderContainer.test().read(profileVisibleProvider.future),
          true);
    });

    test('toggle flips to false', () async {
      final c = ProviderContainer.test();
      await c.read(profileVisibleProvider.future);
      await c.read(profileVisibleProvider.notifier).toggle();
      expect(c.read(profileVisibleProvider).requireValue, false);
    });

    test('double toggle returns to true', () async {
      final c = ProviderContainer.test();
      await c.read(profileVisibleProvider.future);
      await c.read(profileVisibleProvider.notifier).toggle();
      await c.read(profileVisibleProvider.notifier).toggle();
      expect(c.read(profileVisibleProvider).requireValue, true);
    });
  });

  // ─── profileCompletionProvider ────────────────────────────────────────────
  // Derived provider – tested both with direct state mutations and with
  // overrides to preset each dependency independently.

  group('profileCompletionProvider', () {
    test('starts at 0.0 with a fresh container', () {
      expect(ProviderContainer.test().read(profileCompletionProvider), 0.0);
    });

    test('bio filled → 1/6 via direct mutation', () async {
      final c = ProviderContainer.test();
      await c.read(profileAboutMeProvider.future);
      await c.read(profileAboutMeProvider.notifier).save('Hello world');
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('photo set → 1/6 via override', () async {
      final c = ProviderContainer.test(overrides: [
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
      ]);
      await c.read(profileBasicsProvider.future);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('experience added → 1/6 via override', () async {
      final c = ProviderContainer.test(overrides: [
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
      ]);
      await c.read(profileWorkExperiencesProvider.future);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('education added → 1/6 via override', () async {
      final c = ProviderContainer.test(overrides: [
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
      ]);
      await c.read(profileEducationsProvider.future);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('skills added → 1/6 via override', () async {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      await c.read(profileSkillsProvider.future);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('file added → 1/6 via override', () async {
      final c = ProviderContainer.test(overrides: [
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      await c.read(profileFilesProvider.future);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('all 6 sections filled → 1.0 via overrides', () async {
      final c = ProviderContainer.test(overrides: [
        profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      await Future.wait([
        c.read(profileAboutMeProvider.future),
        c.read(profileBasicsProvider.future),
        c.read(profileWorkExperiencesProvider.future),
        c.read(profileEducationsProvider.future),
        c.read(profileSkillsProvider.future),
        c.read(profileFilesProvider.future),
      ]);
      expect(c.read(profileCompletionProvider), 1.0);
    });

    test('all 6 sections filled → 1.0 via direct mutations', () async {
      final c = ProviderContainer.test();
      await c.read(profileAboutMeProvider.future);
      await c.read(profileBasicsProvider.future);
      await c.read(profileWorkExperiencesProvider.future);
      await c.read(profileEducationsProvider.future);
      await c.read(profileSkillsProvider.future);
      await c.read(profileFilesProvider.future);
      await c.read(profileAboutMeProvider.notifier).save('Bio');
      await c.read(profileBasicsProvider.notifier).save(
            firstName: 'X',
            lastName: 'Y',
            dateOfBirth: '01-01-2000',
            gender: 'Male',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'Yes',
            photoUrl: 'https://photo.url',
          );
      await c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      await c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      await c.read(profileSkillsProvider.notifier).updateSkills(['Dart'], []);
      await c.read(profileFilesProvider.notifier).add(_sampleFile);
      expect(c.read(profileCompletionProvider), 1.0);
    });

    test('softSkills alone count as skills section filled', () async {
      final c = ProviderContainer.test();
      await c.read(profileSkillsProvider.future);
      await c.read(profileSkillsProvider.notifier).updateSkills([], ['Teamwork']);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('3 of 6 sections filled → 0.5', () async {
      final c = ProviderContainer.test();
      await c.read(profileAboutMeProvider.future);
      await c.read(profileWorkExperiencesProvider.future);
      await c.read(profileSkillsProvider.future);
      await c.read(profileAboutMeProvider.notifier).save('Bio');
      await c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      await c.read(profileSkillsProvider.notifier).updateSkills(['Dart'], []);
      expect(c.read(profileCompletionProvider), closeTo(0.5, 0.001));
    });
  });

  // ─── WorkExperience.duration ──────────────────────────────────────────────
  // _calcDuration is private; these tests exercise it through the model getter.

  group('WorkExperience.duration', () {
    WorkExperience exp({
      String startDate = '01-2020',
      String? endDate,
      bool currentlyWorkHere = false,
    }) =>
        WorkExperience(
          jobTitle: 'Dev',
          companyName: 'Co',
          location: 'City',
          experienceLevel: 'Mid',
          workplace: 'Remote',
          jobType: 'Full time',
          startDate: startDate,
          endDate: endDate,
          currentlyWorkHere: currentlyWorkHere,
        );

    test('years and months', () {
      expect(exp(startDate: '01-2020', endDate: '06-2021').duration,
          '1 year 5 months');
    });

    test('exact years with no month remainder', () {
      expect(
          exp(startDate: '01-2020', endDate: '01-2021').duration, '1 year');
    });

    test('multiple years', () {
      expect(exp(startDate: '01-2018', endDate: '03-2021').duration,
          '3 years 2 months');
    });

    test('exactly 2 years plural', () {
      expect(
          exp(startDate: '01-2019', endDate: '01-2021').duration, '2 years');
    });

    test('multiple months less than a year', () {
      expect(
          exp(startDate: '01-2020', endDate: '04-2020').duration, '3 months');
    });

    test('exactly 1 month uses singular form', () {
      expect(
          exp(startDate: '01-2020', endDate: '02-2020').duration, '1 month');
    });

    test('same month start and end → 0 months', () {
      expect(exp(startDate: '01-2020', endDate: '01-2020').duration,
          '0 months');
    });

    test('end before start → empty string', () {
      expect(exp(startDate: '06-2021', endDate: '01-2020').duration, '');
    });

    test('malformed startDate → empty string', () {
      expect(exp(startDate: 'invalid').duration, '');
    });

    test('currentlyWorkHere ignores endDate and returns non-empty string', () {
      // endDate is in the past but should be ignored
      final e = exp(
          startDate: '01-2020',
          endDate: '01-2018',
          currentlyWorkHere: true);
      expect(e.duration, isNotEmpty);
    });
  });

  // ─── Education.duration ───────────────────────────────────────────────────

  group('Education.duration', () {
    Education edu({
      String startDate = '09-2015',
      String? endDate,
      bool currentlyStudyHere = false,
    }) =>
        Education(
          institutionName: 'Uni',
          fieldOfStudy: 'CS',
          location: 'City',
          degreeType: 'Bachelor',
          startDate: startDate,
          endDate: endDate,
          currentlyStudyHere: currentlyStudyHere,
        );

    test('typical bachelor range → years and months', () {
      expect(edu(startDate: '09-2015', endDate: '06-2019').duration,
          '3 years 9 months');
    });

    test('exactly 1 year', () {
      expect(edu(startDate: '09-2018', endDate: '09-2019').duration, '1 year');
    });

    test('currentlyStudyHere ignores endDate', () {
      final e = edu(
          startDate: '09-2022',
          endDate: '01-2010',
          currentlyStudyHere: true);
      expect(e.duration, isNotEmpty);
    });

    test('malformed startDate → empty string', () {
      expect(edu(startDate: 'not-a-date').duration, '');
    });
  });

  // ─── UploadedFile.isComplete ──────────────────────────────────────────────

  group('UploadedFile.isComplete', () {
    test('default uploadProgress (1.0) → true', () {
      expect(const UploadedFile(name: 'f', size: '1 KB').isComplete, true);
    });

    test('uploadProgress 0.5 → false', () {
      expect(
          const UploadedFile(name: 'f', size: '1 KB', uploadProgress: 0.5)
              .isComplete,
          false);
    });

    test('uploadProgress 0.99 → false (not yet complete)', () {
      expect(
          const UploadedFile(name: 'f', size: '1 KB', uploadProgress: 0.99)
              .isComplete,
          false);
    });

    test('uploadProgress exactly 1.0 → true', () {
      expect(
          const UploadedFile(name: 'f', size: '1 KB', uploadProgress: 1.0)
              .isComplete,
          true);
    });
  });

  // ─── Additional edge-case tests ───────────────────────────────────────────

  group('profileAboutMeProvider – copyWith nullable semantics', () {
    test('save without videoUrl preserves previously set videoUrl', () async {
      final c = ProviderContainer.test();
      await c.read(profileAboutMeProvider.future);
      await c.read(profileAboutMeProvider.notifier)
          .save('Bio', videoUrl: 'https://v.url');
      // second call omits videoUrl
      await c.read(profileAboutMeProvider.notifier).save('Updated bio');
      expect(c.read(profileAboutMeProvider).requireValue.videoUrl, 'https://v.url');
    });
  });

  group('profileBasicsProvider – save API boundary', () {
    test('save cannot change email or phone (not in params)', () async {
      final c = ProviderContainer.test();
      await c.read(profileBasicsProvider.future);
      await c.read(profileBasicsProvider.notifier).save(
            firstName: 'X',
            lastName: 'Y',
            dateOfBirth: '01-01-2000',
            gender: 'Male',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'Yes',
          );
      // email and phone keep the hard-coded default values
      expect(c.read(profileBasicsProvider).requireValue.email, 'c.ioannidis@gmail.com');
      expect(c.read(profileBasicsProvider).requireValue.phone, '+30 123 456 78 90');
    });

    test('save without photoUrl preserves previously set photoUrl', () async {
      final c = ProviderContainer.test();
      await c.read(profileBasicsProvider.future);
      await c.read(profileBasicsProvider.notifier).save(
            firstName: 'X',
            lastName: 'Y',
            dateOfBirth: '01-01-2000',
            gender: 'Male',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'Yes',
            photoUrl: 'https://cdn.test/avatar.jpg',
          );
      await c.read(profileBasicsProvider.notifier).save(
            firstName: 'X',
            lastName: 'Y',
            dateOfBirth: '01-01-2000',
            gender: 'Male',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'Yes',
            // photoUrl omitted
          );
      expect(c.read(profileBasicsProvider).requireValue.photoUrl,
          'https://cdn.test/avatar.jpg');
    });
  });

  group('profileSkillsProvider – orthogonality of update methods', () {
    test('updateLanguages does not reset existing skills', () async {
      final c = ProviderContainer.test();
      await c.read(profileSkillsProvider.future);
      await c.read(profileSkillsProvider.notifier)
          .updateSkills(['Dart'], ['Teamwork']);
      await c.read(profileSkillsProvider.notifier).updateLanguages(
          [const Language(language: 'English', proficiency: 'Fluent')]);
      expect(c.read(profileSkillsProvider).requireValue.hardSkills, ['Dart']);
      expect(c.read(profileSkillsProvider).requireValue.softSkills, ['Teamwork']);
    });

    test('updateCompetencies does not reset skills or languages', () async {
      final c = ProviderContainer.test();
      await c.read(profileSkillsProvider.future);
      await c.read(profileSkillsProvider.notifier).updateSkills(['Dart'], []);
      await c.read(profileSkillsProvider.notifier).updateLanguages(
          [const Language(language: 'Spanish', proficiency: 'Native')]);
      await c.read(profileSkillsProvider.notifier)
          .updateCompetencies({'leadership': 'Advanced'});
      expect(c.read(profileSkillsProvider).requireValue.hardSkills, ['Dart']);
      expect(
          c.read(profileSkillsProvider).requireValue.languages.first.language, 'Spanish');
    });
  });

  group('profileJobPreferencesProvider – null salary', () {
    test('expectedSalary can be null when preferNotToSpecifySalary is true',
        () async {
      final c = ProviderContainer.test();
      await c.read(profileJobPreferencesProvider.future);
      await c.read(profileJobPreferencesProvider.notifier).save(
            interests: [],
            positionLevel: 'Mid',
            jobType: 'Full time',
            workplace: 'Remote',
            preferNotToSpecifySalary: true,
            // expectedSalary omitted → null
          );
      expect(
          c.read(profileJobPreferencesProvider).requireValue.expectedSalary, isNull);
      expect(c.read(profileJobPreferencesProvider).requireValue.preferNotToSpecifySalary,
          true);
    });
  });

  group('profileFilesProvider – delete from middle', () {
    test('deleting middle item preserves surrounding items in order', () async {
      final c = ProviderContainer.test();
      await c.read(profileFilesProvider.future);
      const a = UploadedFile(name: 'a.pdf', size: '1 KB');
      const b = UploadedFile(name: 'b.pdf', size: '2 KB');
      const d = UploadedFile(name: 'c.pdf', size: '3 KB');
      await c.read(profileFilesProvider.notifier).add(a);
      await c.read(profileFilesProvider.notifier).add(b);
      await c.read(profileFilesProvider.notifier).add(d);
      await c.read(profileFilesProvider.notifier).delete(1); // remove b
      final files = c.read(profileFilesProvider).requireValue;
      expect(files.length, 2);
      expect(files[0].name, 'a.pdf');
      expect(files[1].name, 'c.pdf');
    });
  });

  group('registrationProvider – full sequential flow', () {
    test('all setters applied in sequence preserve every field', () {
      final c = ProviderContainer.test();
      final n = c.read(registrationProvider.notifier);
      n.setLanguage('es');
      n.setTechLevel('basic');
      n.setCredentials('user@test.com', 'secret');
      n.setPersonalDetails('Ana', 'López', '+34 600');
      n.setVerifyMethod('email', remember: true);
      final s = c.read(registrationProvider);
      expect(s.language, 'es');
      expect(s.techLevel, 'basic');
      expect(s.email, 'user@test.com');
      expect(s.password, 'secret');
      expect(s.name, 'Ana');
      expect(s.lastName, 'López');
      expect(s.phone, '+34 600');
      expect(s.verifyMethod, 'email');
      expect(s.rememberVerifyChoice, true);
    });

    test('two containers are fully isolated from each other', () {
      final c1 = ProviderContainer.test();
      final c2 = ProviderContainer.test();
      c1.read(registrationProvider.notifier).setLanguage('es');
      expect(c2.read(registrationProvider).language, '');
    });
  });
}
