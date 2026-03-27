// test/utils/language_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/utils/language_utils.dart';

void main() {
  // ─── langCode ─────────────────────────────────────────────────────────────

  group('langCode', () {
    test('known European languages return correct ISO 639-1 code', () {
      expect(langCode('Spanish'), 'es');
      expect(langCode('French'), 'fr');
      expect(langCode('German'), 'de');
      expect(langCode('Italian'), 'it');
      expect(langCode('Portuguese'), 'pt');
      expect(langCode('Dutch'), 'nl');
      expect(langCode('Swedish'), 'se');
      expect(langCode('Norwegian'), 'no');
      expect(langCode('Danish'), 'dk');
      expect(langCode('Finnish'), 'fi');
      expect(langCode('Polish'), 'pl');
      expect(langCode('Greek'), 'gr');
    });

    test('English maps to gb (flag code)', () {
      expect(langCode('English'), 'gb');
    });

    test('Asian languages return correct codes', () {
      expect(langCode('Chinese'), 'cn');
      expect(langCode('Japanese'), 'jp');
      expect(langCode('Korean'), 'kr');
      expect(langCode('Hindi'), 'in');
    });

    test('Arabic maps to ae', () {
      expect(langCode('Arabic'), 'ae');
    });

    test('Russian and Turkish return correct codes', () {
      expect(langCode('Russian'), 'ru');
      expect(langCode('Turkish'), 'tr');
    });

    test('Catalan, Basque, and Galician all map to es', () {
      expect(langCode('Catalan'), 'es');
      expect(langCode('Basque'), 'es');
      expect(langCode('Galician'), 'es');
    });

    test('unknown language returns first two chars lowercased', () {
      expect(langCode('Ukrainian'), 'uk');
      expect(langCode('Vietnamese'), 'vi');
      expect(langCode('Swahili'), 'sw');
    });

    test('unknown two-char name returns both chars lowercased', () {
      expect(langCode('Zz'), 'zz');
    });
  });
}
