import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/router.dart';

void main() {
  group('IthakiRouter deep-link validation', () {
    test('normalizes OTP methods to the supported set', () {
      expect(IthakiRouter.normalizeOtpMethod('sms'), 'sms');
      expect(IthakiRouter.normalizeOtpMethod(' WhatsApp '), 'whatsapp');
      expect(IthakiRouter.normalizeOtpMethod('email'), 'sms');
      expect(IthakiRouter.normalizeOtpMethod(null), 'sms');
    });

    test('only accepts phone-shaped query text for OTP subtitles', () {
      expect(IthakiRouter.sanitizePhoneQuery('+30 210 1234567'),
          '+30 210 1234567');
      expect(IthakiRouter.sanitizePhoneQuery('  +30   210 1234567  '),
          '+30 210 1234567');
      expect(IthakiRouter.sanitizePhoneQuery('Call this fake support line'),
          isNull);
      expect(IthakiRouter.sanitizePhoneQuery('555<script>'), isNull);
      expect(IthakiRouter.sanitizePhoneQuery('12+34'), isNull);
    });
  });
}
