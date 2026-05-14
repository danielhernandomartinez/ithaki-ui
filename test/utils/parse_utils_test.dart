import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/utils/parse_utils.dart';

void main() {
  group('intFromDynamic', () {
    test('parses numeric and string ids', () {
      expect(intFromDynamic(12), 12);
      expect(intFromDynamic(12.7), 12);
      expect(intFromDynamic('42'), 42);
      expect(intFromDynamic('abc'), isNull);
      expect(intFromDynamic(null), isNull);
    });
  });

  group('resource URLs', () {
    test('identifies remote http URLs', () {
      expect(isHttpUrl('https://example.com/file.pdf'), isTrue);
      expect(isHttpUrl('http://example.com/file.pdf'), isTrue);
      expect(isHttpUrl('file:///tmp/file.pdf'), isFalse);
      expect(isHttpUrl('/tmp/file.pdf'), isFalse);
    });

    test('keeps supported URI sources and converts paths to file URIs', () {
      expect(uriForResourceSource('https://example.com')?.scheme, 'https');
      expect(uriForResourceSource('file:///tmp/file.pdf')?.scheme, 'file');
      expect(uriForResourceSource('/tmp/file.pdf')?.scheme, 'file');
      expect(uriForResourceSource('   '), isNull);
    });

    test('extracts the final path segment for display names', () {
      expect(
        lastPathSegmentOrValue('https://example.com/files/cv.pdf'),
        'cv.pdf',
      );
      expect(lastPathSegmentOrValue('not a url'), 'not a url');
    });
  });

  group('profile dates', () {
    test('normalizes supported date inputs to API dates', () {
      expect(dobToIsoDate('07-05-1994'), '1994-05-07');
      expect(dobToIsoDate('1994-05-07'), '1994-05-07');
      expect(dobToIsoDate('05-1994'), '1994-05-01');
      expect(dobToIsoDate('bad-date'), 'bad-date');
      expect(dobToIsoDate('   '), isNull);
    });

    test('formats API dates for display', () {
      expect(isoDateToDdMmYyyy('1994-05-07'), '07-05-1994');
      expect(isoDateToMmYyyy('1994-05-07'), '05-1994');
      expect(isoDateToDdMmYyyy('not-a-date'), 'not-a-date');
      expect(isoDateToMmYyyy(null), isNull);
    });

    test('converts month-year display values to API dates', () {
      expect(mmYyyyToIsoDate('05-1994'), '1994-05-01');
      expect(mmYyyyToIsoDate('13-1994'), '13-1994');
      expect(mmYyyyToIsoDate(''), isNull);
    });

    test('calculates year difference and month-year duration', () {
      expect(
        yearDifferenceFromDdMmYyyy('07-05-1994', now: DateTime(2026, 5, 14)),
        '32',
      );
      expect(
        durationBetweenMmYyyy(
          '05-2024',
          '08-2025',
          now: DateTime(2026, 5, 14),
        ),
        '1 year 3 months',
      );
      expect(durationBetweenMmYyyy('bad', null), '');
    });
  });
}
