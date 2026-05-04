import '../../models/profile_models.dart';

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
    final raw = value.trim();
    if (raw.isEmpty) return null;
    final parts = raw.split('-');
    if (parts.length == 3) {
      // Already in API format.
      if (parts[0].length == 4) {
        final yyyy = int.tryParse(parts[0]);
        final mm = int.tryParse(parts[1]);
        final dd = int.tryParse(parts[2]);
        if (yyyy != null && mm != null && dd != null) {
          return '${yyyy.toString().padLeft(4, '0')}-${mm.toString().padLeft(2, '0')}-${dd.toString().padLeft(2, '0')}';
        }
      }
      // DD-MM-YYYY
      final dd = int.tryParse(parts[0]);
      final mm = int.tryParse(parts[1]);
      final yyyy = int.tryParse(parts[2]);
      if (dd != null &&
          mm != null &&
          yyyy != null &&
          dd >= 1 &&
          dd <= 31 &&
          mm >= 1 &&
          mm <= 12) {
        return '${yyyy.toString().padLeft(4, '0')}-${mm.toString().padLeft(2, '0')}-${dd.toString().padLeft(2, '0')}';
      }
    } else if (parts.length == 2) {
      // MM-YYYY
      final mm = int.tryParse(parts[0]);
      final yyyy = int.tryParse(parts[1]);
      if (mm != null && yyyy != null) {
        return '${yyyy.toString().padLeft(4, '0')}-${mm.toString().padLeft(2, '0')}-01';
      }
    }
    return raw;
  }

  static String isoDateToDdMmYyyy(dynamic raw) {
    if (raw == null) return '';
    final text = raw.toString().trim();
    if (text.isEmpty) return '';
    final parsed = DateTime.tryParse(text);
    if (parsed == null) return text;
    return '${parsed.day.toString().padLeft(2, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.year.toString().padLeft(4, '0')}';
  }

  static String? mmYyyyToIsoDate(String value) {
    final raw = value.trim();
    if (raw.isEmpty) return null;
    final parts = raw.split('-');
    if (parts.length != 2) return raw;
    final mm = int.tryParse(parts[0]);
    final yyyy = int.tryParse(parts[1]);
    if (mm == null || yyyy == null || mm < 1 || mm > 12) return raw;
    return '${yyyy.toString().padLeft(4, '0')}-${mm.toString().padLeft(2, '0')}-01';
  }

  static String? isoDateToMmYyyy(dynamic raw) {
    if (raw == null) return null;
    final text = raw.toString().trim();
    if (text.isEmpty) return null;
    final parsed = DateTime.tryParse(text);
    if (parsed == null) return text;
    return '${parsed.month.toString().padLeft(2, '0')}-${parsed.year.toString().padLeft(4, '0')}';
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
        final id = int.tryParse(entry.value.id);
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
