/// Calculates a human-readable duration string between two MM-YYYY date strings.
/// [endDate] defaults to today when null (i.e. current position).
String calcDuration(String startDate, String? endDate) {
  try {
    final parts = startDate.split('-');
    if (parts.length != 2) return '';
    final start = DateTime(int.parse(parts[1]), int.parse(parts[0]));
    final end = endDate != null
        ? () {
            final ep = endDate.split('-');
            return DateTime(int.parse(ep[1]), int.parse(ep[0]));
          }()
        : DateTime.now();
    final months = (end.year - start.year) * 12 + (end.month - start.month);
    if (months < 0) return '';
    final years = months ~/ 12;
    final rem = months % 12;
    if (years == 0) return '$rem month${rem != 1 ? 's' : ''}';
    if (rem == 0) return '$years year${years != 1 ? 's' : ''}';
    return '$years year${years != 1 ? 's' : ''} $rem month${rem != 1 ? 's' : ''}';
  } catch (_) {
    return '';
  }
}
