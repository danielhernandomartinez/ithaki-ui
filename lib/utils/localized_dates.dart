import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

String formatAssessmentDate(BuildContext context, DateTime date) {
  return MaterialLocalizations.of(context).formatMediumDate(date);
}

String formatAssessmentMonthYear(BuildContext context, DateTime date) {
  return MaterialLocalizations.of(context).formatMonthYear(date);
}

String formatPostedAgo(BuildContext context, String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  final localDate = date.toLocal();

  final l = AppLocalizations.of(context)!;
  final diff = DateTime.now().difference(localDate);
  if (diff.inDays == 0) return l.postedToday;
  if (diff.inDays == 1) return l.postedOneDayAgo;
  if (diff.inDays < 7) return l.postedDaysAgo(diff.inDays);

  final weeks = diff.inDays ~/ 7;
  if (diff.inDays < 30) return l.postedWeeksAgo(weeks);

  final months = diff.inDays ~/ 30;
  return l.postedMonthsAgo(months);
}

String formatAppliedAt(BuildContext context, String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  final localDate = date.toLocal();

  final l = AppLocalizations.of(context)!;
  final localizations = MaterialLocalizations.of(context);
  final time = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(localDate),
    alwaysUse24HourFormat: true,
  );
  final diff = DateTime.now().difference(localDate);

  if (diff.inDays == 0) return l.appliedToday(time);
  if (diff.inDays == 1) return l.appliedYesterday(time);

  return l.appliedOnDate(localizations.formatMediumDate(localDate), time);
}

String formatPostedDate(BuildContext context, String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return MaterialLocalizations.of(context).formatMediumDate(date.toLocal());
}
