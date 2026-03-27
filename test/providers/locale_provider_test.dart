// test/providers/locale_provider_test.dart
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_ui/providers/locale_provider.dart';

void main() {
  // ─── localeProvider ───────────────────────────────────────────────────────

  group('localeProvider', () {
    test('initial state is null (no locale set)', () {
      expect(ProviderContainer.test().read(localeProvider), isNull);
    });

    test('setLocale creates a Locale with the given language code', () {
      final c = ProviderContainer.test();
      c.read(localeProvider.notifier).setLocale('es');
      expect(c.read(localeProvider), const Locale('es'));
    });

    test('setLocale overwrites a previously set locale', () {
      final c = ProviderContainer.test();
      c.read(localeProvider.notifier).setLocale('es');
      c.read(localeProvider.notifier).setLocale('en');
      expect(c.read(localeProvider), const Locale('en'));
    });

    test('setLocale with Greek locale stores correct language code', () {
      final c = ProviderContainer.test();
      c.read(localeProvider.notifier).setLocale('el');
      expect(c.read(localeProvider)?.languageCode, 'el');
    });

    test('setLocale with Arabic locale stores correct language code', () {
      final c = ProviderContainer.test();
      c.read(localeProvider.notifier).setLocale('ar');
      expect(c.read(localeProvider)?.languageCode, 'ar');
    });

    test('two containers are fully isolated from each other', () {
      final c1 = ProviderContainer.test();
      final c2 = ProviderContainer.test();
      c1.read(localeProvider.notifier).setLocale('es');
      expect(c2.read(localeProvider), isNull);
    });
  });
}
