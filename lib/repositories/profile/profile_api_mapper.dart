import '../../models/profile_models.dart';
import '../../utils/parse_utils.dart' as parse;

class ProfileApiMapper {
  static String enumTitle(dynamic field) => field is Map
      ? (field['title'] as String? ?? '')
      : (field as String? ?? '');

  static String countryName(dynamic field) => field is Map
      ? (field['name'] as String? ?? '')
      : (field as String? ?? '');

  static String countryCode(dynamic field) =>
      field is Map ? ((field['code'] as String? ?? '')).toLowerCase() : '';

  static String titleOrText(dynamic field) {
    if (field is Map) {
      final title = field['title'];
      if (title is String && title.trim().isNotEmpty) return title.trim();
      final name = field['name'];
      if (name is String && name.trim().isNotEmpty) return name.trim();
      final value = field['value'];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is num || value is bool) return value.toString();
    }
    if (field is String) return field.trim();
    if (field is num || field is bool) return field.toString();
    return '';
  }

  static String slug(String value) {
    final cleaned =
        value.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '_');
    final normalized =
        cleaned.replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');
    return normalized;
  }

  static Map<String, dynamic>? enumDto(String title) {
    final t = title.trim();
    if (t.isEmpty) return null;
    return {'value': slug(t), 'title': t};
  }

  static Map<String, dynamic>? locationStatusDto(String title) {
    final t = title.trim();
    if (t.isEmpty) return null;
    return switch (t.toUpperCase()) {
      'MIGRANT' => const {'value': 'MIGRANT', 'title': 'Migrant'},
      'REFUGEE' => const {'value': 'REFUGEE', 'title': 'Refugee'},
      'ASYLUM_SEEKER' || 'ASYLUM SEEKER' => const {
          'value': 'ASYLUM_SEEKER',
          'title': 'Asylum Seeker',
        },
      _ => null,
    };
  }

  static Map<String, dynamic>? relocationReadinessDto(String title) {
    final t = title.trim();
    if (t.isEmpty) return null;
    return switch (t.toUpperCase()) {
      'NEGATIVE' || 'NOT WILLING TO RELOCATE' => const {
          'value': 'NEGATIVE',
          'title': 'Not willing to relocate',
        },
      'LOCALLY' || 'WILLING TO RELOCATE LOCALLY' => const {
          'value': 'LOCALLY',
          'title': 'Willing to relocate locally',
        },
      'NATIONALLY' || 'WILLING TO RELOCATE NATIONALLY' => const {
          'value': 'NATIONALLY',
          'title': 'Willing to relocate nationally',
        },
      'INTERNATIONALLY' || 'WILLING TO RELOCATE INTERNATIONALLY' => const {
          'value': 'INTERNATIONALLY',
          'title': 'Willing to relocate internationally',
        },
      _ => {'value': slug(t), 'title': t},
    };
  }

  /// Converts DD-MM-YYYY or MM-YYYY display formats to YYYY-MM-DD for the API.
  static String? dobToIsoDate(String value) {
    return parse.dobToIsoDate(value);
  }

  static String isoDateToDdMmYyyy(dynamic raw) {
    return parse.isoDateToDdMmYyyy(raw);
  }

  static String? mmYyyyToIsoDate(String value) {
    return parse.mmYyyyToIsoDate(value);
  }

  static String? isoDateToMmYyyy(dynamic raw) {
    return parse.isoDateToMmYyyy(raw);
  }

  static List<String> stringList(dynamic field) => (field as List? ?? [])
      .map((e) => titleOrText(e))
      .where((e) => e.isNotEmpty)
      .toList();

  static List<Map<String, dynamic>> listItemDtos(List<String> values) => values
      .asMap()
      .entries
      .map((e) => {'value': e.key + 1, 'title': e.value})
      .toList();

  static Map<String, dynamic> onboardingLocationBody(ProfileBasics basics) {
    return {
      'location': {
        'status': locationStatusDto(basics.status),
        'relocationReadiness':
            relocationReadinessDto(basics.relocationReadiness),
      },
    };
  }

  static Map<String, dynamic> onboardingPreferencesBody(
      ProfileJobPreferences prefs) {
    return {
      'jobInterests': prefs.jobInterests.asMap().entries.map((entry) {
        final id = parse.intFromDynamic(entry.value.id);
        return {
          'value': id ?? (entry.key + 1),
          'title': entry.value.title,
        };
      }).toList(),
      'preferences': {
        'positionLevel': enumDto(prefs.positionLevel),
        'jobTypes': prefs.jobType.trim().isEmpty
            ? []
            : [
                {'value': slug(prefs.jobType), 'title': prefs.jobType}
              ],
        'workplaceFormats': prefs.workplace.trim().isEmpty
            ? []
            : [
                {'value': slug(prefs.workplace), 'title': prefs.workplace}
              ],
        'expectedPayment': prefs.expectedSalary?.toString(),
        'paymentTerm': const {'value': 'MONTHLY', 'title': 'Monthly'},
        'preferNotToSpecify': prefs.preferNotToSpecifySalary,
      },
    };
  }

  static List<Map<String, dynamic>> workReplaceBody(
      List<WorkExperience> experiences) {
    return experiences
        .map(
          (exp) => {
            'title': exp.jobTitle,
            'companyName': exp.companyName,
            'description': exp.summary ?? '',
            'startDate': mmYyyyToIsoDate(exp.startDate),
            'endDate': exp.currentlyWorkHere
                ? null
                : mmYyyyToIsoDate(exp.endDate ?? ''),
            'current': exp.currentlyWorkHere,
            'level': enumDto(exp.experienceLevel),
            'workType': enumDto(exp.jobType),
            'employmentType': enumDto(exp.workplace),
          },
        )
        .toList();
  }

  static List<Map<String, dynamic>> educationReplaceBody(
      List<Education> educations) {
    return educations
        .map(
          (edu) => {
            'fieldOfStudy': edu.fieldOfStudy,
            'institution': edu.institutionName,
            'degree': edu.degreeType,
            'startDate': mmYyyyToIsoDate(edu.startDate),
            'endDate': edu.currentlyStudyHere
                ? null
                : mmYyyyToIsoDate(edu.endDate ?? ''),
            'currentlyStudying': edu.currentlyStudyHere,
          },
        )
        .toList();
  }
}
