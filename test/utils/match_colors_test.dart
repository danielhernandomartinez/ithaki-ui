// test/utils/match_colors_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/utils/match_colors.dart';

void main() {
  // ─── getMatchGradientColors ───────────────────────────────────────────────

  group('getMatchGradientColors', () {
    test('always returns exactly 2 colors for every known label', () {
      const labels = [
        'STRONG MATCH',
        'GREAT MATCH',
        'GOOD MATCH',
        'WEAK MATCH',
        'NO BENEFICIARIES MATCH',
      ];
      for (final label in labels) {
        expect(getMatchGradientColors(label).length, 2,
            reason: '$label should return 2 colors');
      }
    });

    test('STRONG MATCH returns the primary green gradient', () {
      expect(getMatchGradientColors('STRONG MATCH'),
          [const Color(0xFF50C948), const Color(0xFF75E767)]);
    });

    test('GREAT MATCH returns the same gradient as STRONG MATCH', () {
      expect(getMatchGradientColors('GREAT MATCH'),
          getMatchGradientColors('STRONG MATCH'));
    });

    test('GOOD MATCH returns a lighter green gradient', () {
      expect(getMatchGradientColors('GOOD MATCH'),
          [const Color(0xFFA8D84E), const Color(0xFFC8E86E)]);
    });

    test('WEAK MATCH returns a yellow gradient', () {
      expect(getMatchGradientColors('WEAK MATCH'),
          [const Color(0xFFE8C84E), const Color(0xFFF0DD6E)]);
    });

    test('NO BENEFICIARIES MATCH returns a grey gradient', () {
      expect(getMatchGradientColors('NO BENEFICIARIES MATCH'),
          [const Color(0xFFBDBDBD), const Color(0xFFD0D0D0)]);
    });

    test('unknown label falls back to the STRONG MATCH green gradient', () {
      expect(getMatchGradientColors('UNKNOWN'),
          getMatchGradientColors('STRONG MATCH'));
    });

    test('gradient colors differ between GOOD and WEAK match', () {
      expect(getMatchGradientColors('GOOD MATCH'),
          isNot(equals(getMatchGradientColors('WEAK MATCH'))));
    });

    test('grey gradient differs from the green gradient', () {
      expect(getMatchGradientColors('NO BENEFICIARIES MATCH'),
          isNot(equals(getMatchGradientColors('STRONG MATCH'))));
    });
  });

  // ─── getMatchBgColor ──────────────────────────────────────────────────────

  group('getMatchBgColor', () {
    test('GOOD MATCH returns its specific background color', () {
      expect(getMatchBgColor('GOOD MATCH'), const Color(0xFFF5F9E8));
    });

    test('WEAK MATCH returns its specific background color', () {
      expect(getMatchBgColor('WEAK MATCH'), const Color(0xFFFDF8E4));
    });

    test('STRONG MATCH and GREAT MATCH share the same background color', () {
      expect(getMatchBgColor('STRONG MATCH'), getMatchBgColor('GREAT MATCH'));
    });

    test('unknown label falls back to the STRONG MATCH background color', () {
      expect(getMatchBgColor('RANDOM'), getMatchBgColor('STRONG MATCH'));
    });

    test('NO BENEFICIARIES MATCH background differs from STRONG MATCH', () {
      expect(getMatchBgColor('NO BENEFICIARIES MATCH'),
          isNot(equals(getMatchBgColor('STRONG MATCH'))));
    });

    test('GOOD MATCH background differs from WEAK MATCH background', () {
      expect(getMatchBgColor('GOOD MATCH'),
          isNot(equals(getMatchBgColor('WEAK MATCH'))));
    });

    test('all known labels return a non-transparent color', () {
      const labels = [
        'STRONG MATCH',
        'GREAT MATCH',
        'GOOD MATCH',
        'WEAK MATCH',
        'NO BENEFICIARIES MATCH',
      ];
      for (final label in labels) {
        expect((getMatchBgColor(label).a * 255.0).round().clamp(0, 255), greaterThan(0),
            reason: '$label background should not be transparent');
      }
    });
  });
}
