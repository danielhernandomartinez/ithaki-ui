import '../l10n/app_localizations.dart';

class ProfileCompetencyDisplayRow {
  const ProfileCompetencyDisplayRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

List<ProfileCompetencyDisplayRow> profileCompetencyDisplayRows(
  Map<String, String> competencies,
  AppLocalizations l,
) {
  const preferredOrder = [
    'computerSkills',
    'drivingLicense',
    'hasDrivingLicense',
    'licenseCategory',
    'drivingLicenseCategory',
    'drivingLicenseCategories',
    'greekLicense',
    'hasGreekLicense',
  ];

  final rows = <ProfileCompetencyDisplayRow>[];
  final usedKeys = <String>{};
  final usedKinds = <String>{};

  for (final key in preferredOrder) {
    _appendCompetencyRow(
      rows: rows,
      usedKeys: usedKeys,
      usedKinds: usedKinds,
      key: key,
      rawValue: competencies[key],
      l: l,
    );
  }

  for (final entry in competencies.entries) {
    _appendCompetencyRow(
      rows: rows,
      usedKeys: usedKeys,
      usedKinds: usedKinds,
      key: entry.key,
      rawValue: entry.value,
      l: l,
    );
  }

  return rows;
}

void _appendCompetencyRow({
  required List<ProfileCompetencyDisplayRow> rows,
  required Set<String> usedKeys,
  required Set<String> usedKinds,
  required String key,
  required String? rawValue,
  required AppLocalizations l,
}) {
  if (usedKeys.contains(key)) return;
  final meta = _competencyMeta(key, l);
  if (usedKinds.contains(meta.kind)) {
    usedKeys.add(key);
    return;
  }

  final value = _displayValue(rawValue, l);
  usedKeys.add(key);
  if (value == null || _hideFalseValue(meta.kind, value, l)) return;

  rows.add(ProfileCompetencyDisplayRow(label: meta.label, value: value));
  usedKinds.add(meta.kind);
}

({String kind, String label}) _competencyMeta(String key, AppLocalizations l) {
  return switch (_normalizedKey(key)) {
    'computerskills' => (
        kind: 'computerSkills',
        label: l.computerSkillsTitle,
      ),
    'drivinglicense' || 'hasdrivinglicense' => (
        kind: 'drivingLicense',
        label: l.drivingLicenseTitle,
      ),
    'licensecategory' ||
    'drivinglicensecategory' ||
    'drivinglicensecategories' =>
      (
        kind: 'licenseCategory',
        label: l.licenseCategoryTitle,
      ),
    'greeklicense' || 'hasgreeklicense' => (
        kind: 'greekLicense',
        label: l.iHaveGreekLicense,
      ),
    _ => (kind: key, label: _humanizeKey(key)),
  };
}

String _normalizedKey(String key) =>
    key.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');

String? _displayValue(String? rawValue, AppLocalizations l) {
  final value = rawValue?.trim();
  if (value == null || value.isEmpty) return null;

  final lower = value.toLowerCase();
  if (lower == 'null' || lower == '[]' || lower == '{}') return null;
  if (lower == 'true') return l.yes;
  if (lower == 'false') return l.no;

  return value;
}

bool _hideFalseValue(String kind, String value, AppLocalizations l) {
  if (value != l.no) return false;
  return kind == 'greekLicense';
}

String _humanizeKey(String key) {
  final spaced = key
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .trim();
  if (spaced.isEmpty) return key;
  return spaced
      .split(RegExp(r'\s+'))
      .map((word) =>
          word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
