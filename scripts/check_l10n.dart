import 'dart:convert';
import 'dart:io';

void main() {
  // Load all ARB keys
  final en = _load('lib/l10n/app_en.arb');
  final el = _load('lib/l10n/app_el.arb');
  final ar = _load('lib/l10n/app_ar.arb');

  final enKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
  final elKeys = el.keys.where((k) => !k.startsWith('@')).toSet();
  final arKeys = ar.keys.where((k) => !k.startsWith('@')).toSet();

  // Summary
  print('EN keys: ${enKeys.length}');
  print('EL keys: ${elKeys.length}');
  print('AR keys: ${arKeys.length}');

  final missingEl = enKeys.difference(elKeys).toList()..sort();
  final missingAr = enKeys.difference(arKeys).toList()..sort();
  final extraEl = elKeys.difference(enKeys).toList()..sort();
  final extraAr = arKeys.difference(enKeys).toList()..sort();

  print('\n=== Missing in Greek (el) [${missingEl.length}] ===');
  for (final k in missingEl) print('  $k  →  ${en[k]}');

  print('\n=== Missing in Arabic (ar) [${missingAr.length}] ===');
  for (final k in missingAr) print('  $k  →  ${en[k]}');

  print('\n=== Extra in Greek (not in EN) [${extraEl.length}] ===');
  for (final k in extraEl) print('  $k  →  ${el[k]}');

  print('\n=== Extra in Arabic (not in EN) [${extraAr.length}] ===');
  for (final k in extraAr) print('  $k  →  ${ar[k]}');

  // Scan Dart files for l10n references
  print('\n=== Scanning Dart files for l10n key references ===');
  final dartFiles = _findDartFiles('lib');
  final referencedKeys = <String>{};
  final keyRefRegex = RegExp(r'l10n\.(\w+)');

  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    final matches = keyRefRegex.allMatches(content);
    for (final m in matches) {
      referencedKeys.add(m.group(1)!);
    }
  }

  final usedButMissingEN = referencedKeys.difference(enKeys).toList()..sort();
  print('\n=== Used in code but MISSING from app_en.arb [${usedButMissingEN.length}] ===');
  for (final k in usedButMissingEN) {
    // find where it's referenced
    for (final file in dartFiles) {
      if (file.readAsStringSync().contains('l10n.$k')) {
        print('  $k  (in ${file.path})');
        break;
      }
    }
  }

  // Screens WITHOUT AppLocalizations import (potential hardcoded strings)
  print('\n=== Screen/widget Dart files NOT importing AppLocalizations ===');
  final screenFiles = _findDartFiles('lib/screens') + _findDartFiles('lib/widgets');
  for (final file in screenFiles) {
    final content = file.readAsStringSync();
    if (!content.contains('AppLocalizations') && content.contains('Text(')) {
      print('  ${file.path}');
    }
  }
}

Map<String, dynamic> _load(String path) {
  final content = File(path).readAsStringSync();
  return jsonDecode(content) as Map<String, dynamic>;
}

List<File> _findDartFiles(String dir) {
  final d = Directory(dir);
  if (!d.existsSync()) return [];
  return d
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}
