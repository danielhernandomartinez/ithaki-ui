// test/providers/locale_provider_test.dart
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ithaki_ui/providers/locale_provider.dart';

void main() {
  // ─── localeProvider ───────────────────────────────────────────────────────

  group('localeProvider', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    test('initial state is null when no locale is saved', () async {
      final c = ProviderContainer.test();
      addTearDown(c.dispose);

      expect(await c.read(localeProvider.future), isNull);
    });

    test('initial state restores a saved locale', () async {
      SharedPreferences.setMockInitialValues({'locale_language_code': 'es'});
      final c = ProviderContainer.test();
      addTearDown(c.dispose);

      expect(await c.read(localeProvider.future), const Locale('es'));
    });

    test('setLocale creates and persists a Locale with the given language code',
        () async {
      final c = ProviderContainer.test();
      addTearDown(c.dispose);
      await c.read(localeProvider.future);

      await c.read(localeProvider.notifier).setLocale('es');

      final prefs = await SharedPreferences.getInstance();
      expect(c.read(localeProvider).value, const Locale('es'));
      expect(prefs.getString('locale_language_code'), 'es');
    });

    test('setLocale overwrites a previously set locale', () async {
      final c = ProviderContainer.test();
      addTearDown(c.dispose);
      await c.read(localeProvider.future);

      await c.read(localeProvider.notifier).setLocale('es');
      await c.read(localeProvider.notifier).setLocale('en');

      expect(c.read(localeProvider).value, const Locale('en'));
    });

    test('setLocale with Greek locale stores correct language code', () async {
      final c = ProviderContainer.test();
      addTearDown(c.dispose);
      await c.read(localeProvider.future);

      await c.read(localeProvider.notifier).setLocale('el');

      expect(c.read(localeProvider).value?.languageCode, 'el');
    });

    test('setLocale with Arabic locale stores correct language code', () async {
      final c = ProviderContainer.test();
      addTearDown(c.dispose);
      await c.read(localeProvider.future);

      await c.read(localeProvider.notifier).setLocale('ar');

      expect(c.read(localeProvider).value?.languageCode, 'ar');
    });

    test('saved locale is restored in a new container', () async {
      final c1 = ProviderContainer.test();
      addTearDown(c1.dispose);
      await c1.read(localeProvider.future);

      await c1.read(localeProvider.notifier).setLocale('es');

      final c2 = ProviderContainer.test();
      addTearDown(c2.dispose);
      expect(await c2.read(localeProvider.future), const Locale('es'));
    });

    test('unsupported saved locale falls back to system locale mode', () async {
      SharedPreferences.setMockInitialValues({'locale_language_code': 'fr'});
      final c = ProviderContainer.test();
      addTearDown(c.dispose);

      expect(await c.read(localeProvider.future), isNull);
    });
  });
}
