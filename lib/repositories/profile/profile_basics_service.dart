import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../data/countries.dart';
import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import 'profile_api_mapper.dart';
import 'profile_response_parser.dart';

class ProfileBasicsService {
  ProfileBasicsService(this._api);

  final ApiClient _api;

  Future<ProfileBasics> save(ProfileBasics basics) async {
    final citizenship =
        _countryPayload(basics.citizenshipCode, basics.citizenship);
    final residence = _countryPayload(basics.residenceCode, basics.residence);
    final uploadedPhotoUrl = await _uploadPhotoIfNeeded(basics.photoUrl);
    final photoForPayload =
        ProfileResponseParser.isRemotePhoto(uploadedPhotoUrl)
            ? null
            : uploadedPhotoUrl;
    final locationStatus = ProfileApiMapper.locationStatusDto(basics.status);

    final jobSeekerPayload = {
      'basics': {
        'name': '${basics.firstName} ${basics.lastName}'.trim(),
        'email': basics.email,
        'phone': basics.phone,
        'gender': ProfileApiMapper.enumDto(basics.gender),
        if (citizenship != null) 'citizenship': citizenship,
        if (residence != null) 'residence': residence,
        if (photoForPayload != null) 'photo': photoForPayload,
        if (basics.dateOfBirth.isNotEmpty)
          'dateOfBirth': ProfileApiMapper.dobToIsoDate(basics.dateOfBirth),
      },
      'location': {
        if (locationStatus != null) 'status': locationStatus,
        if (basics.relocationReadiness.isNotEmpty)
          'relocationReadiness': ProfileApiMapper.relocationReadinessDto(
            basics.relocationReadiness,
          ),
      },
    };
    if (kDebugMode) {
      debugPrint('[saveBasics] payload ->\n${_prettyJson(jobSeekerPayload)}');
    }
    await _api.postJson('/user/me', {
      'firstName': basics.firstName,
      'lastName': basics.lastName,
      'phone': basics.phone,
    });
    await _api.postJson('/job-seeker/me', jobSeekerPayload);
    try {
      await _api.postJson(
        '/job-seeker/me/onboarding',
        {
          'location': {
            if (citizenship != null) 'citizenship': citizenship['id'],
            if (residence != null) 'residence': residence['id'],
            if (locationStatus != null) 'status': locationStatus,
            if (basics.relocationReadiness.isNotEmpty)
              'relocationReadiness': ProfileApiMapper.relocationReadinessDto(
                basics.relocationReadiness,
              ),
          },
        },
        params: const {'step': 'location'},
      );
    } catch (e) {
      _debugLog('[saveBasics] onboarding location save skipped -> $e');
    }

    return basics.copyWith(photoUrl: uploadedPhotoUrl);
  }

  Future<String?> _uploadPhotoIfNeeded(String? photoUrl) async {
    final localPath = ProfileResponseParser.normalizePhotoUrl(photoUrl);
    if (localPath == null ||
        localPath.isEmpty ||
        ProfileResponseParser.isRemotePhoto(localPath)) {
      return localPath;
    }

    final file = File(localPath);
    if (!await file.exists()) {
      _debugLog(
        '[saveBasics] photo upload skipped; file does not exist -> $localPath',
      );
      return photoUrl;
    }

    _debugLog('[saveBasics] photo upload file -> $localPath');
    final body = await _api.uploadMultipart(
      '/files/me/upload/photo',
      'file',
      localPath,
    );
    final uploadedPhoto = _readUploadedPhoto(body);
    _debugLog('[saveBasics] uploaded photo -> $uploadedPhoto');
    return uploadedPhoto;
  }

  static String _readUploadedPhoto(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) {
      throw Exception('Photo upload response was empty');
    }
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is String && decoded.trim().isNotEmpty) {
        return decoded.trim();
      }
      if (decoded is Map<String, dynamic>) {
        final rawUrl =
            decoded['url'] ?? decoded['signedUrl'] ?? decoded['photo'];
        if (rawUrl is String && rawUrl.trim().isNotEmpty) {
          return rawUrl.trim();
        }
      }
    } catch (_) {}
    return trimmed;
  }

  static Map<String, dynamic>? _countryPayload(String code, String name) {
    if (code.isEmpty || name.trim().isEmpty) return null;
    final countryId = countryIdByCode[code.toUpperCase()];
    if (countryId == null) return null;
    final trimmedName = name.trim();
    final capitalizedName =
        trimmedName[0].toUpperCase() + trimmedName.substring(1);
    return {
      'id': countryId,
      'name': capitalizedName,
      'code': code.toUpperCase(),
    };
  }

  static String _prettyJson(Object value) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }

  static void _debugLog(String message) {
    if (kDebugMode) debugPrint(message);
  }
}
