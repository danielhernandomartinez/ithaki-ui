import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeLanguageCodeKey = 'locale_language_code';
const _supportedLocaleCodes = {'en', 'el', 'ar', 'es'};

final localeProvider = AsyncNotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class LocaleNotifier extends AsyncNotifier<Locale?> {
  @override
  Future<Locale?> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _localeFromCode(prefs.getString(_localeLanguageCodeKey));
  }

  Future<void> setLocale(String languageCode) async {
    final locale = _localeFromCode(languageCode);
    if (locale == null) return;

    state = AsyncData(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeLanguageCodeKey, locale.languageCode);
  }

  Future<void> clearLocale() async {
    state = const AsyncData(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeLanguageCodeKey);
  }

  Locale? _localeFromCode(String? languageCode) {
    final code = languageCode?.trim().toLowerCase().split(RegExp('[-_]')).first;
    if (code == null || !_supportedLocaleCodes.contains(code)) return null;
    return Locale(code);
  }
}
