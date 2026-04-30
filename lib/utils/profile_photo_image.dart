import 'dart:io';

import 'package:flutter/widgets.dart';

ImageProvider? profilePhotoImageProvider(String? source) {
  final value = source?.trim();
  if (value == null || value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
    return NetworkImage(value);
  }

  final file = uri != null && uri.isScheme('file')
      ? File(uri.toFilePath())
      : File(value);
  if (!file.existsSync()) return null;
  return FileImage(file);
}
