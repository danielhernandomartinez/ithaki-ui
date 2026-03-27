import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

abstract class ProfileRepository {
  ProfileBasics getBasics();
  ProfileAboutMe getAboutMe();
  ProfileSkills getSkills();
  List<WorkExperience> getWorkExperiences();
  List<Education> getEducations();
  List<UploadedFile> getFiles();
  List<String> getValues();
  ProfileJobPreferences getJobPreferences();
  bool getProfileVisible();
}

class MockProfileRepository implements ProfileRepository {
  @override
  ProfileBasics getBasics() => const ProfileBasics(
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

  @override
  ProfileAboutMe getAboutMe() => const ProfileAboutMe();

  @override
  ProfileSkills getSkills() => const ProfileSkills();

  @override
  List<WorkExperience> getWorkExperiences() => const [];

  @override
  List<Education> getEducations() => const [];

  @override
  List<UploadedFile> getFiles() => const [];

  @override
  List<String> getValues() => const [];

  @override
  ProfileJobPreferences getJobPreferences() => const ProfileJobPreferences(
    jobInterests: [
      JobInterest(title: 'Web Developer', category: 'IT & Development'),
    ],
    positionLevel: 'Senior',
    jobType: 'Full time',
    workplace: 'On-site',
    expectedSalary: 1800,
  );

  @override
  bool getProfileVisible() => true;
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => MockProfileRepository(),
);
