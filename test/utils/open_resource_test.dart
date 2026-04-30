import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/profile_models.dart';
import 'package:ithaki_ui/utils/open_resource.dart';

void main() {
  group('uriForResourceSource', () {
    test('keeps https URLs as network URIs', () {
      final uri = uriForResourceSource('https://example.com/cv.pdf');

      expect(uri?.scheme, 'https');
      expect(uri?.host, 'example.com');
    });

    test('converts local file paths to file URIs', () {
      final uri = uriForResourceSource(r'C:\Users\User\Desktop\cv.pdf');

      expect(uri?.scheme, 'file');
      expect(uri?.pathSegments.last, 'cv.pdf');
    });

    test('returns null for blank sources', () {
      expect(uriForResourceSource('   '), isNull);
    });
  });

  group('uriForUploadedFile', () {
    test('uses the uploaded file URL when present', () {
      final uri = uriForUploadedFile(
        const UploadedFile(
          name: 'CV.pdf',
          size: '1 MB',
          url: 'https://example.com/CV.pdf',
        ),
      );

      expect(uri?.toString(), 'https://example.com/CV.pdf');
    });

    test('returns null when a file has no launchable source', () {
      expect(
        uriForUploadedFile(const UploadedFile(name: 'CV.pdf', size: '1 MB')),
        isNull,
      );
    });
  });
}
