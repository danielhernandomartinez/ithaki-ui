/// Formats [n] with thousand separators.
///
/// [separator] defaults to comma. Use `' '` for European-style spacing.
/// Example: formatNumber(1500) → '1,500'
/// Example: formatNumber(20000, separator: ' ') → '20 000'
String formatNumber(int n, {String separator = ','}) {
  if (n < 1000) return '$n';
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(separator);
    buf.write(s[i]);
  }
  return buf.toString();
}
