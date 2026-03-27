// test/providers/tour_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ithaki_ui/providers/tour_provider.dart';

void main() {
  // SharedPreferences must be mocked before each test so the async
  // build() reads from the in-memory store rather than a real channel.
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  // ─── tourProvider ─────────────────────────────────────────────────────────

  group('tourProvider – initial state from empty prefs', () {
    test('tour is not completed, step is 0, welcome is visible', () async {
      final c = ProviderContainer.test();
      final s = await c.read(tourProvider.future);
      expect(s.tourCompleted, false);
      expect(s.currentStep, 0);
      expect(s.welcomeVisible, true);
      expect(s.skipConfirmVisible, false);
      expect(s.completionVisible, false);
    });
  });

  group('tourProvider – initial state from saved prefs', () {
    test('completed tour: welcome is hidden', () async {
      SharedPreferences.setMockInitialValues({'tour_completed': true});
      final c = ProviderContainer.test();
      final s = await c.read(tourProvider.future);
      expect(s.tourCompleted, true);
      expect(s.welcomeVisible, false);
    });

    test('saved step is restored on init', () async {
      SharedPreferences.setMockInitialValues({'tour_step': 5});
      final c = ProviderContainer.test();
      final s = await c.read(tourProvider.future);
      expect(s.currentStep, 5);
    });
  });

  group('tourProvider – startTour', () {
    test('startTour sets step to 1 and hides the welcome modal', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).startTour();
      final s = c.read(tourProvider).requireValue;
      expect(s.currentStep, 1);
      expect(s.welcomeVisible, false);
    });

    test('startTour persists step 1 to SharedPreferences', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).startTour();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('tour_step'), 1);
    });
  });

  group('tourProvider – nextStep', () {
    test('nextStep from step 1 advances to step 2', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).startTour();
      await c.read(tourProvider.notifier).nextStep();
      expect(c.read(tourProvider).requireValue.currentStep, 2);
    });

    test('nextStep from step 13 completes the tour and shows completion modal',
        () async {
      SharedPreferences.setMockInitialValues({'tour_step': 13});
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).nextStep();
      final s = c.read(tourProvider).requireValue;
      expect(s.currentStep, 0);
      expect(s.completionVisible, true);
    });

    test('nextStep from step 13 persists tour_completed to prefs', () async {
      SharedPreferences.setMockInitialValues({'tour_step': 13});
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).nextStep();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('tour_completed'), true);
    });
  });

  group('tourProvider – skip flow', () {
    test('showSkipConfirm makes skip confirm visible', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      c.read(tourProvider.notifier).showSkipConfirm();
      expect(c.read(tourProvider).requireValue.skipConfirmVisible, true);
    });

    test('cancelSkip hides skip confirm without completing tour', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      c.read(tourProvider.notifier).showSkipConfirm();
      c.read(tourProvider.notifier).cancelSkip();
      final s = c.read(tourProvider).requireValue;
      expect(s.skipConfirmVisible, false);
      expect(s.tourCompleted, false);
    });

    test('confirmSkip marks tour completed and clears skip confirm', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      c.read(tourProvider.notifier).showSkipConfirm();
      await c.read(tourProvider.notifier).confirmSkip();
      final s = c.read(tourProvider).requireValue;
      expect(s.tourCompleted, true);
      expect(s.currentStep, 0);
      expect(s.skipConfirmVisible, false);
    });

    test('confirmSkip persists tour_completed to SharedPreferences', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).confirmSkip();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('tour_completed'), true);
      expect(prefs.getInt('tour_step'), 0);
    });
  });

  group('tourProvider – completeTour', () {
    test('completeTour hides completion modal and marks tour done', () async {
      SharedPreferences.setMockInitialValues({'tour_step': 13});
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).nextStep(); // sets completionVisible
      await c.read(tourProvider.notifier).completeTour();
      final s = c.read(tourProvider).requireValue;
      expect(s.tourCompleted, true);
      expect(s.completionVisible, false);
    });

    test('completeTour persists tour_completed to SharedPreferences', () async {
      final c = ProviderContainer.test();
      await c.read(tourProvider.future);
      await c.read(tourProvider.notifier).completeTour();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('tour_completed'), true);
    });
  });

  // ─── tourKeysProvider ─────────────────────────────────────────────────────

  group('tourKeysProvider', () {
    test('provides exactly 13 keys', () {
      final c = ProviderContainer.test();
      expect(c.read(tourKeysProvider).length, 13);
    });

    test('keys are indexed 1 through 13', () {
      final c = ProviderContainer.test();
      final keys = c.read(tourKeysProvider);
      for (int i = 1; i <= 13; i++) {
        expect(keys.containsKey(i), true, reason: 'key $i should exist');
      }
    });

    test('same container returns the same key instances (stable references)',
        () {
      final c = ProviderContainer.test();
      final first = c.read(tourKeysProvider);
      final second = c.read(tourKeysProvider);
      expect(identical(first, second), true);
    });
  });
}
