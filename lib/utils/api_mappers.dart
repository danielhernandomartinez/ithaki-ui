import 'package:flutter/material.dart';

// ─── String helpers ──────────────────────────────────────────────────────────

String enumTitle(dynamic field) =>
    field is Map ? (field['title'] as String? ?? '') : (field as String? ?? '');

String matchLabel(int pct) {
  if (pct >= 90) return 'STRONG MATCH';
  if (pct >= 75) return 'GREAT MATCH';
  if (pct >= 50) return 'GOOD MATCH';
  if (pct > 0) return 'WEAK MATCH';
  return 'NO MATCH';
}

String enumValue(dynamic field) =>
    field is Map ? (field['value'] as String? ?? '') : (field as String? ?? '');

String countryName(dynamic field) =>
    field is Map ? (field['name'] as String? ?? '') : (field as String? ?? '');

String countryCode(dynamic field) =>
    field is Map ? ((field['code'] as String? ?? '')).toLowerCase() : '';

String normalizeEscapedLineBreaks(String value) => value
    .replaceAll('\r\n', '\n')
    .replaceAll('\r', '\n')
    .replaceAll(RegExp(r'\\r\\n|\\n|\\r|/n'), '\n');

String apiDateString(dynamic value) {
  if (value == null) return '';
  final parsed = DateTime.tryParse(value.toString());
  return parsed?.toIso8601String() ?? value.toString();
}

// ─── Derived display values ───────────────────────────────────────────────────

/// Generates initials from a company/person name.
String initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  if (name.length >= 2) return name.substring(0, 2).toUpperCase();
  return name.toUpperCase();
}

/// Deterministic color from a string (company name or ID).
Color colorFromString(String s) {
  const palette = [
    Color(0xFF6B4EAA),
    Color(0xFF2E7D32),
    Color(0xFF795548),
    Color(0xFF1B5E20),
    Color(0xFF37474F),
    Color(0xFF0D47A1),
    Color(0xFF4A148C),
    Color(0xFFE65100),
    Color(0xFF1E88E5),
    Color(0xFF905CFF),
  ];
  final index = s.codeUnits.fold(0, (a, b) => a + b) % palette.length;
  return palette[index];
}

/// Formats salaryMin / salaryMax into a human-readable string.
String formatSalary(dynamic salaryMin, dynamic salaryMax, dynamic paymentTerm) {
  if (salaryMin == null && salaryMax == null) return '';
  final term = enumTitle(paymentTerm);
  final suffix = term.toLowerCase().contains('month')
      ? '/ month'
      : '/ ${term.toLowerCase()}';
  if (salaryMin != null && salaryMax != null && salaryMin != salaryMax) {
    return '€${salaryMin.toString()} – €${salaryMax.toString()} $suffix';
  }
  return '€${(salaryMin ?? salaryMax).toString()} $suffix';
}

/// Shared job + match fields parsed from an application or invitation envelope.
typedef JobFields = ({
  String jobId,
  String jobTitle,
  String companyName,
  String companyInitials,
  Color companyLogoColor,
  String salary,
  String location,
  String workplaceType,
  String employmentType,
  String experienceLevel,
  String category,
  int matchPercentage,
  String matchLabel,
});

/// Extracts job and match fields from an API envelope that may carry a nested
/// `job` object (applications) or a flat/top-level `company` (invitations).
JobFields parseJobFields(Map<String, dynamic> envelope) {
  final jobRaw = envelope['job'];
  final j = jobRaw is Map<String, dynamic> ? jobRaw : envelope;

  final jobId = (j['id'] ?? envelope['jobId'])?.toString() ?? '';
  final jobTitle = j['title'] as String? ?? '';

  final companyFromJob = j['company'];
  final companyFromEnvelope = envelope['company'];
  final companyRaw = companyFromJob is Map
      ? companyFromJob
      : (companyFromEnvelope is Map ? companyFromEnvelope : null);
  final companyName = companyRaw != null
      ? (companyRaw['name'] as String? ?? '')
      : (companyFromJob is String && companyFromJob.isNotEmpty
          ? companyFromJob
          : j['companyName'] as String? ??
              envelope['companyName'] as String? ??
              '');
  final companyKey = companyName.isNotEmpty ? companyName : jobTitle;

  final salary = j['salary'] as String? ??
      j['salaryRange'] as String? ??
      formatSalary(j['salaryMin'], j['salaryMax'], j['paymentTerm']);
  final location = j['location'] as String? ?? '';
  final workplaceType =
      j['workType'] as String? ?? enumTitle(j['workArrangement']);
  final employmentType =
      j['schedule'] as String? ?? enumTitle(j['employmentType']);
  final experienceLevel =
      j['level'] as String? ?? enumTitle(j['experienceLevel']);
  final category = j['category'] as String? ?? enumTitle(j['industry']);
  final matchPct = (envelope['matchPercent'] as num?)?.toInt() ??
      (envelope['matchPercentage'] as num?)?.toInt() ??
      (j['matchPercent'] as num?)?.toInt() ??
      (j['matchPercentage'] as num?)?.toInt() ??
      0;
  final matchText = envelope['matchLabel'] as String? ??
      j['matchLabel'] as String? ??
      matchLabel(matchPct);

  return (
    jobId: jobId,
    jobTitle: jobTitle,
    companyName: companyName,
    companyInitials: j['logoInitials'] as String? ??
        envelope['logoInitials'] as String? ??
        initials(companyKey),
    companyLogoColor: colorFromString(companyKey),
    salary: salary,
    location: location,
    workplaceType: workplaceType,
    employmentType: employmentType,
    experienceLevel: experienceLevel,
    category: category,
    matchPercentage: matchPct,
    matchLabel: matchText,
  );
}

/// Extracts a list from either a raw JSON array or a Spring Page { content: [] }.
List<dynamic> extractList(dynamic json) {
  if (json is List) return json;
  if (json is Map) {
    final content = json['content'];
    if (content is List) return content;
  }
  return const [];
}
