int? intFromDynamic(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? doubleFromDynamic(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

Uri? trimmedUri(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  return Uri.tryParse(text);
}

bool isHttpUrl(String? value) {
  final uri = trimmedUri(value);
  return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
}

bool isFileUri(String? value) => trimmedUri(value)?.isScheme('file') ?? false;

String? localFilePathFromSource(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  final uri = trimmedUri(text);
  if (uri != null && uri.isScheme('file')) return uri.toFilePath();
  return text;
}

Uri? uriForResourceSource(String? source) {
  final value = source?.trim();
  if (value == null || value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null &&
      (uri.isScheme('http') || uri.isScheme('https') || uri.isScheme('file'))) {
    return uri;
  }

  return Uri.file(value);
}

String lastPathSegmentOrValue(String value) {
  final uri = Uri.tryParse(value);
  final lastSegment =
      uri?.pathSegments.where((segment) => segment.isNotEmpty).lastOrNull;
  return lastSegment == null || lastSegment.isEmpty ? value : lastSegment;
}

String? dobToIsoDate(String value) {
  final raw = value.trim();
  if (raw.isEmpty) return null;
  final parts = raw.split('-');
  if (parts.length == 3) {
    if (parts[0].length == 4) {
      final yyyy = int.tryParse(parts[0]);
      final mm = int.tryParse(parts[1]);
      final dd = int.tryParse(parts[2]);
      if (yyyy != null && mm != null && dd != null) {
        return _isoDate(yyyy, mm, dd);
      }
    }

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
      return _isoDate(yyyy, mm, dd);
    }
  } else if (parts.length == 2) {
    final mm = int.tryParse(parts[0]);
    final yyyy = int.tryParse(parts[1]);
    if (mm != null && yyyy != null) {
      return _isoDate(yyyy, mm, 1);
    }
  }
  return raw;
}

String isoDateToDdMmYyyy(dynamic raw) {
  if (raw == null) return '';
  final text = raw.toString().trim();
  if (text.isEmpty) return '';
  final parsed = DateTime.tryParse(text);
  if (parsed == null) return text;
  return _displayDate(parsed.day, parsed.month, parsed.year);
}

String? mmYyyyToIsoDate(String value) {
  final raw = value.trim();
  if (raw.isEmpty) return null;
  final parts = raw.split('-');
  if (parts.length != 2) return raw;
  final mm = int.tryParse(parts[0]);
  final yyyy = int.tryParse(parts[1]);
  if (mm == null || yyyy == null || mm < 1 || mm > 12) return raw;
  return _isoDate(yyyy, mm, 1);
}

String? isoDateToMmYyyy(dynamic raw) {
  if (raw == null) return null;
  final text = raw.toString().trim();
  if (text.isEmpty) return null;
  final parsed = DateTime.tryParse(text);
  if (parsed == null) return text;
  return _displayMonthYear(parsed.month, parsed.year);
}

String yearDifferenceFromDdMmYyyy(String date, {DateTime? now}) {
  final parts = date.split('-');
  if (parts.length < 3) return '';
  final year = int.tryParse(parts[2]);
  if (year == null) return '';
  return '${(now ?? DateTime.now()).year - year}';
}

String durationBetweenMmYyyy(
  String startDate,
  String? endDate, {
  DateTime? now,
}) {
  final start = _parseMmYyyy(startDate);
  if (start == null) return '';
  final end = endDate == null ? now ?? DateTime.now() : _parseMmYyyy(endDate);
  if (end == null) return '';

  final months = (end.year - start.year) * 12 + (end.month - start.month);
  if (months < 0) return '';
  final years = months ~/ 12;
  final rem = months % 12;
  if (years == 0) return '$rem month${rem != 1 ? 's' : ''}';
  if (rem == 0) return '$years year${years != 1 ? 's' : ''}';
  return '$years year${years != 1 ? 's' : ''} $rem month${rem != 1 ? 's' : ''}';
}

DateTime? _parseMmYyyy(String value) {
  final parts = value.split('-');
  if (parts.length != 2) return null;
  final month = int.tryParse(parts[0]);
  final year = int.tryParse(parts[1]);
  if (month == null || year == null) return null;
  return DateTime(year, month);
}

String _isoDate(int year, int month, int day) =>
    '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

String _displayDate(int day, int month, int year) =>
    '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-${year.toString().padLeft(4, '0')}';

String _displayMonthYear(int month, int year) =>
    '${month.toString().padLeft(2, '0')}-${year.toString().padLeft(4, '0')}';
