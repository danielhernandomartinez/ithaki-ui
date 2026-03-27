// test/providers/settings_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_ui/providers/settings_provider.dart';

void main() {
  // ─── settingsProvider ─────────────────────────────────────────────────────

  group('settingsProvider – initial state', () {
    test('whatsapp and push start enabled, sms starts disabled', () {
      final c = ProviderContainer.test();
      final s = c.read(settingsProvider);
      expect(s.whatsappEnabled, true);
      expect(s.smsEnabled, false);
      expect(s.pushEnabled, true);
    });

    test('newsletter is inactive with empty types on start', () {
      final c = ProviderContainer.test();
      final s = c.read(settingsProvider);
      expect(s.emailNewsletterActive, false);
      expect(s.newsletterTypes, isEmpty);
    });
  });

  group('settingsProvider – toggleChannel', () {
    test('toggling whatsapp flips it to false', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleChannel('whatsapp');
      expect(c.read(settingsProvider).whatsappEnabled, false);
    });

    test('double-toggling whatsapp restores it to true', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleChannel('whatsapp');
      c.read(settingsProvider.notifier).toggleChannel('whatsapp');
      expect(c.read(settingsProvider).whatsappEnabled, true);
    });

    test('toggling sms flips it to true', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleChannel('sms');
      expect(c.read(settingsProvider).smsEnabled, true);
    });

    test('toggling push flips it to false', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleChannel('push');
      expect(c.read(settingsProvider).pushEnabled, false);
    });

    test('toggling one channel does not affect the others', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleChannel('sms');
      expect(c.read(settingsProvider).whatsappEnabled, true);
      expect(c.read(settingsProvider).pushEnabled, true);
    });

    test('unknown channel name is silently ignored', () {
      final c = ProviderContainer.test();
      final before = c.read(settingsProvider);
      c.read(settingsProvider.notifier).toggleChannel('email');
      final after = c.read(settingsProvider);
      expect(after.whatsappEnabled, before.whatsappEnabled);
      expect(after.smsEnabled, before.smsEnabled);
      expect(after.pushEnabled, before.pushEnabled);
    });
  });

  group('settingsProvider – newsletter subscription', () {
    test('subscribeNewsletter activates email newsletter', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).subscribeNewsletter();
      expect(c.read(settingsProvider).emailNewsletterActive, true);
    });

    test('unsubscribeNewsletter deactivates newsletter and clears types', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).subscribeNewsletter();
      c.read(settingsProvider.notifier).toggleNewsletterType('jobs');
      c.read(settingsProvider.notifier).unsubscribeNewsletter();
      final s = c.read(settingsProvider);
      expect(s.emailNewsletterActive, false);
      expect(s.newsletterTypes, isEmpty);
    });

    test('toggleNewsletterType adds a new type', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleNewsletterType('jobs');
      expect(c.read(settingsProvider).newsletterTypes, contains('jobs'));
    });

    test('toggleNewsletterType removes an existing type', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleNewsletterType('jobs');
      c.read(settingsProvider.notifier).toggleNewsletterType('jobs');
      expect(c.read(settingsProvider).newsletterTypes, isNot(contains('jobs')));
    });

    test('multiple newsletter types can coexist', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleNewsletterType('jobs');
      c.read(settingsProvider.notifier).toggleNewsletterType('news');
      expect(c.read(settingsProvider).newsletterTypes,
          containsAll(['jobs', 'news']));
    });
  });

  group('settingsProvider – orthogonality', () {
    test('channel toggles do not affect newsletter state', () {
      final c = ProviderContainer.test();
      c.read(settingsProvider.notifier).toggleChannel('sms');
      c.read(settingsProvider.notifier).subscribeNewsletter();
      c.read(settingsProvider.notifier).toggleNewsletterType('jobs');
      expect(c.read(settingsProvider).smsEnabled, true);
      expect(c.read(settingsProvider).emailNewsletterActive, true);
      expect(c.read(settingsProvider).newsletterTypes, contains('jobs'));
      expect(c.read(settingsProvider).whatsappEnabled, true);
    });

    test('two containers are fully isolated from each other', () {
      final c1 = ProviderContainer.test();
      final c2 = ProviderContainer.test();
      c1.read(settingsProvider.notifier).toggleChannel('whatsapp');
      expect(c2.read(settingsProvider).whatsappEnabled, true);
    });
  });
}
