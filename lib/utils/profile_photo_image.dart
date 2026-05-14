import 'dart:io';

import 'package:flutter/widgets.dart';

import 'parse_utils.dart';

ImageProvider? profilePhotoImageProvider(String? source) {
  final value = source?.trim();
  if (value == null || value.isEmpty) return null;

  if (isHttpUrl(value)) {
    return NetworkImage(value);
  }

  final path = localFilePathFromSource(value);
  if (path == null) return null;
  final file = File(path);
  if (!file.existsSync()) return null;
  return FileImage(file);
}
