// test/providers/provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_ui/models/profile_models.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/providers/registration_provider.dart';

// ─── Fake notifiers used as overrides ────────────────────────────────────────
// These preset state so profileCompletionProvider tests stay declarative.

class _BioFilledNotifier extends ProfileAboutMeNotifier {
  @override
  ProfileAboutMe build() => const ProfileAboutMe(bio: 'Pre-set bio');
}

class _PhotoFilledNotifier extends ProfileBasicsNotifier {
  @override
  ProfileBasics build() =>
      const ProfileBasics(photoUrl: 'https://img.test/photo.jpg');
}

class _OneExpNotifier extends ProfileWorkExperiencesNotifier {
  @override
  List<WorkExperience> build() => const [
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
  List<Education> build() => const [
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
  ProfileSkills build() => const ProfileSkills(hardSkills: ['Dart']);
}

class _OneFileNotifier extends ProfileFilesNotifier {
  @override
  List<UploadedFile> build() =>
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
    test('initial state has hard-coded defaults', () {
      final c = ProviderContainer.test();
      final s = c.read(profileBasicsProvider);
      expect(s.firstName, 'Christos');
      expect(s.lastName, 'Ioannides');
      expect(s.email, 'c.ioannidis@gmail.com');
      expect(s.photoUrl, isNull);
    });

    test('update replaces the provided fields', () {
      final c = ProviderContainer.test();
      c.read(profileBasicsProvider.notifier).update(
            firstName: 'Maria',
            lastName: 'García',
            dateOfBirth: '15-06-1990',
            gender: 'Female',
            citizenship: 'Spain',
            residence: 'Spain',
            status: 'Citizen',
            relocationReadiness: 'No',
          );
      final s = c.read(profileBasicsProvider);
      expect(s.firstName, 'Maria');
      expect(s.lastName, 'García');
      expect(s.gender, 'Female');
    });

    test('update with photoUrl sets photoUrl', () {
      final c = ProviderContainer.test();
      c.read(profileBasicsProvider.notifier).update(
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
      expect(c.read(profileBasicsProvider).photoUrl,
          'https://cdn.test/avatar.jpg');
    });
  });

  // ─── profileAboutMeProvider ───────────────────────────────────────────────

  group('profileAboutMeProvider', () {
    test('initial bio is empty, videoUrl is null', () {
      final c = ProviderContainer.test();
      final s = c.read(profileAboutMeProvider);
      expect(s.bio, '');
      expect(s.videoUrl, isNull);
    });

    test('update sets bio and videoUrl', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier)
          .update('Software dev', videoUrl: 'https://youtu.be/xyz');
      final s = c.read(profileAboutMeProvider);
      expect(s.bio, 'Software dev');
      expect(s.videoUrl, 'https://youtu.be/xyz');
    });

    test('update with only bio leaves videoUrl null', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier).update('Just bio');
      expect(c.read(profileAboutMeProvider).videoUrl, isNull);
    });

    test('update overwrites previous bio', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier).update('First');
      c.read(profileAboutMeProvider.notifier).update('Second');
      expect(c.read(profileAboutMeProvider).bio, 'Second');
    });
  });

  // ─── profileSkillsProvider ────────────────────────────────────────────────

  group('profileSkillsProvider', () {
    test('initial state is fully empty', () {
      final c = ProviderContainer.test();
      final s = c.read(profileSkillsProvider);
      expect(s.hardSkills, isEmpty);
      expect(s.softSkills, isEmpty);
      expect(s.languages, isEmpty);
      expect(s.competencies, isEmpty);
    });

    test('updateSkills sets hard and soft skills', () {
      final c = ProviderContainer.test();
      c.read(profileSkillsProvider.notifier)
          .updateSkills(['Dart', 'Flutter'], ['Teamwork']);
      final s = c.read(profileSkillsProvider);
      expect(s.hardSkills, ['Dart', 'Flutter']);
      expect(s.softSkills, ['Teamwork']);
    });

    test('updateSkills replaces previous lists', () {
      final c = ProviderContainer.test();
      c.read(profileSkillsProvider.notifier).updateSkills(['A'], ['B']);
      c.read(profileSkillsProvider.notifier).updateSkills(['C'], []);
      expect(c.read(profileSkillsProvider).hardSkills, ['C']);
      expect(c.read(profileSkillsProvider).softSkills, isEmpty);
    });

    test('updateLanguages sets language list', () {
      final c = ProviderContainer.test();
      const lang = Language(language: 'English', proficiency: 'Fluent');
      c.read(profileSkillsProvider.notifier).updateLanguages([lang]);
      expect(
          c.read(profileSkillsProvider).languages.first.language, 'English');
    });

    test('updateCompetencies sets competency map', () {
      final c = ProviderContainer.test();
      c.read(profileSkillsProvider.notifier)
          .updateCompetencies({'leadership': 'Advanced'});
      expect(c.read(profileSkillsProvider).competencies,
          {'leadership': 'Advanced'});
    });
  });

  // ─── profileWorkExperiencesProvider ──────────────────────────────────────

  group('profileWorkExperiencesProvider', () {
    test('initial state is empty list', () {
      expect(
          ProviderContainer.test().read(profileWorkExperiencesProvider),
          isEmpty);
    });

    test('add appends a new experience', () {
      final c = ProviderContainer.test();
      c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      expect(c.read(profileWorkExperiencesProvider).length, 1);
      expect(c.read(profileWorkExperiencesProvider).first.jobTitle,
          'Developer');
    });

    test('add twice results in two items', () {
      final c = ProviderContainer.test();
      c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      c.read(profileWorkExperiencesProvider.notifier)
          .add(_sampleExp.copyWith(jobTitle: 'Lead'));
      expect(c.read(profileWorkExperiencesProvider).length, 2);
    });

    test('update replaces experience at given index', () {
      final c = ProviderContainer.test();
      c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      c.read(profileWorkExperiencesProvider.notifier)
          .update(0, _sampleExp.copyWith(jobTitle: 'Lead'));
      expect(c.read(profileWorkExperiencesProvider).first.jobTitle, 'Lead');
    });
  });

  // ─── profileEducationsProvider ────────────────────────────────────────────

  group('profileEducationsProvider', () {
    test('initial state is empty list', () {
      expect(
          ProviderContainer.test().read(profileEducationsProvider), isEmpty);
    });

    test('add appends a new education', () {
      final c = ProviderContainer.test();
      c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      expect(c.read(profileEducationsProvider).length, 1);
      expect(
          c.read(profileEducationsProvider).first.institutionName, 'UPM');
    });

    test('add twice results in two items', () {
      final c = ProviderContainer.test();
      c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      c.read(profileEducationsProvider.notifier)
          .add(_sampleEdu.copyWith(degreeType: 'Master'));
      expect(c.read(profileEducationsProvider).length, 2);
    });

    test('update replaces education at given index', () {
      final c = ProviderContainer.test();
      c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      c.read(profileEducationsProvider.notifier)
          .update(0, _sampleEdu.copyWith(degreeType: 'Master'));
      expect(
          c.read(profileEducationsProvider).first.degreeType, 'Master');
    });
  });

  // ─── profileFilesProvider ─────────────────────────────────────────────────

  group('profileFilesProvider', () {
    test('initial state is empty list', () {
      expect(ProviderContainer.test().read(profileFilesProvider), isEmpty);
    });

    test('add appends a file', () {
      final c = ProviderContainer.test();
      c.read(profileFilesProvider.notifier).add(_sampleFile);
      expect(c.read(profileFilesProvider).length, 1);
      expect(c.read(profileFilesProvider).first.name, 'cv.pdf');
    });

    test('delete removes file at index, preserving order', () {
      final c = ProviderContainer.test();
      const second = UploadedFile(name: 'cert.pdf', size: '50 KB');
      c.read(profileFilesProvider.notifier).add(_sampleFile);
      c.read(profileFilesProvider.notifier).add(second);
      c.read(profileFilesProvider.notifier).delete(0);
      expect(c.read(profileFilesProvider).length, 1);
      expect(c.read(profileFilesProvider).first.name, 'cert.pdf');
    });

    test('delete last item results in empty list', () {
      final c = ProviderContainer.test();
      c.read(profileFilesProvider.notifier).add(_sampleFile);
      c.read(profileFilesProvider.notifier).delete(0);
      expect(c.read(profileFilesProvider), isEmpty);
    });
  });

  // ─── profileValuesProvider ────────────────────────────────────────────────

  group('profileValuesProvider', () {
    test('initial state is empty list', () {
      expect(ProviderContainer.test().read(profileValuesProvider), isEmpty);
    });

    test('update sets values list', () {
      final c = ProviderContainer.test();
      c.read(profileValuesProvider.notifier).update(['Integrity', 'Innovation']);
      expect(c.read(profileValuesProvider), ['Integrity', 'Innovation']);
    });

    test('update replaces previous list entirely', () {
      final c = ProviderContainer.test();
      c.read(profileValuesProvider.notifier).update(['A', 'B', 'C']);
      c.read(profileValuesProvider.notifier).update(['X']);
      expect(c.read(profileValuesProvider), ['X']);
    });

    test('update with empty list clears values', () {
      final c = ProviderContainer.test();
      c.read(profileValuesProvider.notifier).update(['Integrity']);
      c.read(profileValuesProvider.notifier).update([]);
      expect(c.read(profileValuesProvider), isEmpty);
    });
  });

  // ─── profileJobPreferencesProvider ───────────────────────────────────────

  group('profileJobPreferencesProvider', () {
    test('initial state has expected defaults', () {
      final c = ProviderContainer.test();
      final s = c.read(profileJobPreferencesProvider);
      expect(s.positionLevel, 'Senior');
      expect(s.jobType, 'Full time');
      expect(s.workplace, 'On-site');
      expect(s.expectedSalary, 1800);
      expect(s.preferNotToSpecifySalary, false);
      expect(s.jobInterests, isNotEmpty);
    });

    test('update changes all preference fields', () {
      final c = ProviderContainer.test();
      c.read(profileJobPreferencesProvider.notifier).update(
            interests: [
              const JobInterest(title: 'PM', category: 'Management')
            ],
            positionLevel: 'Junior',
            jobType: 'Part time',
            workplace: 'Remote',
            expectedSalary: 1200,
            preferNotToSpecifySalary: false,
          );
      final s = c.read(profileJobPreferencesProvider);
      expect(s.positionLevel, 'Junior');
      expect(s.jobType, 'Part time');
      expect(s.workplace, 'Remote');
      expect(s.expectedSalary, 1200);
      expect(s.jobInterests.first.title, 'PM');
    });

    test('preferNotToSpecifySalary can be toggled on', () {
      final c = ProviderContainer.test();
      c.read(profileJobPreferencesProvider.notifier).update(
            interests: [],
            positionLevel: 'Mid',
            jobType: 'Full time',
            workplace: 'Hybrid',
            preferNotToSpecifySalary: true,
          );
      expect(c.read(profileJobPreferencesProvider).preferNotToSpecifySalary,
          true);
    });
  });

  // ─── profileVisibleProvider ───────────────────────────────────────────────

  group('profileVisibleProvider', () {
    test('initial state is true (visible)', () {
      expect(ProviderContainer.test().read(profileVisibleProvider), true);
    });

    test('toggle flips to false', () {
      final c = ProviderContainer.test();
      c.read(profileVisibleProvider.notifier).toggle();
      expect(c.read(profileVisibleProvider), false);
    });

    test('double toggle returns to true', () {
      final c = ProviderContainer.test();
      c.read(profileVisibleProvider.notifier).toggle();
      c.read(profileVisibleProvider.notifier).toggle();
      expect(c.read(profileVisibleProvider), true);
    });
  });

  // ─── profileCompletionProvider ────────────────────────────────────────────
  // Derived provider – tested both with direct state mutations and with
  // overrides to preset each dependency independently.

  group('profileCompletionProvider', () {
    test('starts at 0.0 with a fresh container', () {
      expect(ProviderContainer.test().read(profileCompletionProvider), 0.0);
    });

    test('bio filled → 1/6 via direct mutation', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier).update('Hello world');
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('photo set → 1/6 via override', () {
      final c = ProviderContainer.test(overrides: [
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
      ]);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('experience added → 1/6 via override', () {
      final c = ProviderContainer.test(overrides: [
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
      ]);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('education added → 1/6 via override', () {
      final c = ProviderContainer.test(overrides: [
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
      ]);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('skills added → 1/6 via override', () {
      final c = ProviderContainer.test(overrides: [
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
      ]);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('file added → 1/6 via override', () {
      final c = ProviderContainer.test(overrides: [
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('all 6 sections filled → 1.0 via overrides', () {
      final c = ProviderContainer.test(overrides: [
        profileAboutMeProvider.overrideWith(_BioFilledNotifier.new),
        profileBasicsProvider.overrideWith(_PhotoFilledNotifier.new),
        profileWorkExperiencesProvider.overrideWith(_OneExpNotifier.new),
        profileEducationsProvider.overrideWith(_OneEduNotifier.new),
        profileSkillsProvider.overrideWith(_OneSkillNotifier.new),
        profileFilesProvider.overrideWith(_OneFileNotifier.new),
      ]);
      expect(c.read(profileCompletionProvider), 1.0);
    });

    test('all 6 sections filled → 1.0 via direct mutations', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier).update('Bio');
      c.read(profileBasicsProvider.notifier).update(
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
      c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      c.read(profileEducationsProvider.notifier).add(_sampleEdu);
      c.read(profileSkillsProvider.notifier).updateSkills(['Dart'], []);
      c.read(profileFilesProvider.notifier).add(_sampleFile);
      expect(c.read(profileCompletionProvider), 1.0);
    });

    test('softSkills alone count as skills section filled', () {
      final c = ProviderContainer.test();
      c.read(profileSkillsProvider.notifier).updateSkills([], ['Teamwork']);
      expect(c.read(profileCompletionProvider), closeTo(1 / 6, 0.001));
    });

    test('3 of 6 sections filled → 0.5', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier).update('Bio');
      c.read(profileWorkExperiencesProvider.notifier).add(_sampleExp);
      c.read(profileSkillsProvider.notifier).updateSkills(['Dart'], []);
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
    test('update without videoUrl preserves previously set videoUrl', () {
      final c = ProviderContainer.test();
      c.read(profileAboutMeProvider.notifier)
          .update('Bio', videoUrl: 'https://v.url');
      // second call omits videoUrl
      c.read(profileAboutMeProvider.notifier).update('Updated bio');
      expect(c.read(profileAboutMeProvider).videoUrl, 'https://v.url');
    });
  });

  group('profileBasicsProvider – update API boundary', () {
    test('update cannot change email or phone (not in params)', () {
      final c = ProviderContainer.test();
      c.read(profileBasicsProvider.notifier).update(
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
      expect(c.read(profileBasicsProvider).email, 'c.ioannidis@gmail.com');
      expect(c.read(profileBasicsProvider).phone, '+30 123 456 78 90');
    });

    test('update without photoUrl preserves previously set photoUrl', () {
      final c = ProviderContainer.test();
      c.read(profileBasicsProvider.notifier).update(
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
      c.read(profileBasicsProvider.notifier).update(
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
      expect(c.read(profileBasicsProvider).photoUrl,
          'https://cdn.test/avatar.jpg');
    });
  });

  group('profileSkillsProvider – orthogonality of update methods', () {
    test('updateLanguages does not reset existing skills', () {
      final c = ProviderContainer.test();
      c.read(profileSkillsProvider.notifier)
          .updateSkills(['Dart'], ['Teamwork']);
      c.read(profileSkillsProvider.notifier).updateLanguages(
          [const Language(language: 'English', proficiency: 'Fluent')]);
      expect(c.read(profileSkillsProvider).hardSkills, ['Dart']);
      expect(c.read(profileSkillsProvider).softSkills, ['Teamwork']);
    });

    test('updateCompetencies does not reset skills or languages', () {
      final c = ProviderContainer.test();
      c.read(profileSkillsProvider.notifier).updateSkills(['Dart'], []);
      c.read(profileSkillsProvider.notifier).updateLanguages(
          [const Language(language: 'Spanish', proficiency: 'Native')]);
      c.read(profileSkillsProvider.notifier)
          .updateCompetencies({'leadership': 'Advanced'});
      expect(c.read(profileSkillsProvider).hardSkills, ['Dart']);
      expect(
          c.read(profileSkillsProvider).languages.first.language, 'Spanish');
    });
  });

  group('profileJobPreferencesProvider – null salary', () {
    test('expectedSalary can be null when preferNotToSpecifySalary is true',
        () {
      final c = ProviderContainer.test();
      c.read(profileJobPreferencesProvider.notifier).update(
            interests: [],
            positionLevel: 'Mid',
            jobType: 'Full time',
            workplace: 'Remote',
            preferNotToSpecifySalary: true,
            // expectedSalary omitted → null
          );
      expect(
          c.read(profileJobPreferencesProvider).expectedSalary, isNull);
      expect(c.read(profileJobPreferencesProvider).preferNotToSpecifySalary,
          true);
    });
  });

  group('profileFilesProvider – delete from middle', () {
    test('deleting middle item preserves surrounding items in order', () {
      final c = ProviderContainer.test();
      const a = UploadedFile(name: 'a.pdf', size: '1 KB');
      const b = UploadedFile(name: 'b.pdf', size: '2 KB');
      const d = UploadedFile(name: 'c.pdf', size: '3 KB');
      c.read(profileFilesProvider.notifier).add(a);
      c.read(profileFilesProvider.notifier).add(b);
      c.read(profileFilesProvider.notifier).add(d);
      c.read(profileFilesProvider.notifier).delete(1); // remove b
      final files = c.read(profileFilesProvider);
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
