import '../models/profile_models.dart';

Uri? uriForResourceSource(String? source) {
  final value = source?.trim();
  if (value == null || value.isEmpty) {
    return null;
  }

  final parsed = Uri.tryParse(value);
  if (parsed != null &&
      (parsed.isScheme('http') ||
          parsed.isScheme('https') ||
          parsed.isScheme('file'))) {
    return parsed;
  }

  return Uri.file(value);
}

Uri? uriForUploadedFile(UploadedFile file) {
  return uriForResourceSource(file.url);
}
