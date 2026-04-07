import 'package:flutter/material.dart';

// ─── String helpers ──────────────────────────────────────────────────────────

String enumTitle(dynamic field) =>
    field is Map ? (field['title'] as String? ?? '') : (field as String? ?? '');

String enumValue(dynamic field) =>
    field is Map ? (field['value'] as String? ?? '') : (field as String? ?? '');

String countryName(dynamic field) =>
    field is Map ? (field['name'] as String? ?? '') : (field as String? ?? '');

String countryCode(dynamic field) =>
    field is Map ? ((field['code'] as String? ?? '')).toLowerCase() : '';

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
  final suffix = term.toLowerCase().contains('month') ? '/ month' : '/ ${term.toLowerCase()}';
  if (salaryMin != null && salaryMax != null && salaryMin != salaryMax) {
    return '€${salaryMin.toString()} – €${salaryMax.toString()} $suffix';
  }
  return '€${(salaryMin ?? salaryMax).toString()} $suffix';
}

/// Relative "posted X ago" string from an ISO date string.
String postedAgo(dynamic dateStr) {
  if (dateStr == null) return '';
  try {
    final date = DateTime.parse(dateStr.toString());
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Posted today';
    if (diff.inDays == 1) return 'Posted 1 day ago';
    if (diff.inDays < 7) return 'Posted ${diff.inDays} days ago';
    final weeks = diff.inDays ~/ 7;
    if (diff.inDays < 30) return 'Posted $weeks week${weeks != 1 ? 's' : ''} ago';
    final months = diff.inDays ~/ 30;
    return 'Posted $months month${months != 1 ? 's' : ''} ago';
  } catch (_) {
    return '';
  }
}

/// "Applied today 09:30" / "Applied on 16 November, 11:30" from an ISO date.
String appliedAt(dynamic dateStr) {
  if (dateStr == null) return '';
  try {
    final date = DateTime.parse(dateStr.toString());
    final diff = DateTime.now().difference(date);
    final time =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (diff.inDays == 0) return 'Applied today $time';
    if (diff.inDays == 1) return 'Applied yesterday $time';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return 'Applied on ${date.day} ${months[date.month - 1]}, $time';
  } catch (_) {
    return dateStr.toString();
  }
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
