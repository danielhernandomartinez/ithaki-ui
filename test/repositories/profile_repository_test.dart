import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/repositories/profile_repository.dart';

void main() {
  group('MockProfileRepository', () {
    test('starts profile sections with the same demo data shown in My CV',
        () async {
      final repository = MockProfileRepository();

      final aboutMe = await repository.getAboutMe();
      final skills = await repository.getSkills();
      final workExperiences = await repository.getWorkExperiences();
      final educations = await repository.getEducations();
      final files = await repository.getFiles();
      final jobPreferences = await repository.getJobPreferences();

      expect(aboutMe.bio, contains('Passionate Frontend Developer'));
      expect(skills.hardSkills, contains('Web Development'));
      expect(skills.softSkills, contains('Teamwork'));
      expect(skills.languages.map((language) => language.language),
          containsAll(['English', 'Greek']));
      expect(skills.competencies['Computer Skills'], 'Professional');
      expect(workExperiences.first.jobTitle, 'Web Developer');
      expect(workExperiences.first.companyName, 'Amazing Dev');
      expect(educations.first.institutionName,
          'National Technical University of Athens');
      expect(files.first.name, 'CV_Christos.pdf');
      expect(jobPreferences.jobInterests.first.title, 'Frontend Developer');
    });
  });
}
