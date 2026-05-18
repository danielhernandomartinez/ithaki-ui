import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../services/api_client.dart';
import '../profile_repository.dart';
import 'profile_documents_service.dart';
import 'profile_local_store.dart';
import 'profile_response_parser.dart';
import 'profile_session_cache.dart';
import 'profile_skill_resolver.dart';

class ProfileLoader {
  const ProfileLoader({
    required ApiClient api,
    required ProfileSessionCache cache,
    required ProfileDocumentsService documentsService,
    required ProfileSkillResolver skillResolver,
  })  : _api = api,
        _cache = cache,
        _documentsService = documentsService,
        _skillResolver = skillResolver;

  final ApiClient _api;
  final ProfileSessionCache _cache;
  final ProfileDocumentsService _documentsService;
  final ProfileSkillResolver _skillResolver;

  Future<ProfileLoadResult> refreshAll() async {
    final userRes = await _api.get('/user/me');
    if (userRes.statusCode != 200) {
      throw Exception('Failed to load user: ${userRes.statusCode}');
    }

    final Map<String, dynamic> userData;
    try {
      userData = (jsonDecode(userRes.body) as Map).cast<String, dynamic>();
    } on FormatException {
      throw Exception('Failed to load user: server returned non-JSON response');
    }
    if (kDebugMode) {
      debugPrint('[refreshAll] userInfo ->\n${_prettyJson(userData)}');
    }

    final phoneVerified = userData['phoneVerified'] as bool? ?? false;
    if (phoneVerified) {
      await ProfileLocalStore.savePhoneVerified(true);
    }

    var basics = ProfileResponseParser.parseBasicsFromUser(userData);
    final onboarding = ProfileResponseParser.stringMap(userData['onboarding']);
    final onboardingPrefs = ProfileResponseParser.parseJobPreferences(
      onboarding?['preferences'],
      onboarding?['jobInterests'],
    );
    if (onboardingPrefs != null) {
      await _cache.saveJobPreferences(onboardingPrefs);
    }

    final onboardingValues =
        ProfileResponseParser.titleList(onboarding?['values']);
    if (onboardingValues.isNotEmpty) {
      await _cache.saveValues(onboardingValues);
    }

    try {
      final profileRes = await _api.get('/job-seeker/me');
      if (profileRes.statusCode == 200) {
        final profileData = _decodeProfile(profileRes.body);

        basics = ProfileResponseParser.applyProfileBasics(basics, profileData);

        final parsedAboutMe = ProfileResponseParser.parseAboutMe(profileData);
        final parsedSkills = await _skillResolver.resolveSkillNames(
          ProfileResponseParser.parseSkills(
            profileData,
            _cache.snapshot.skills,
          ),
        );
        final parsedWork =
            ProfileResponseParser.parseWorkExperiences(profileData);
        final parsedEducations =
            ProfileResponseParser.parseEducations(profileData);
        final parsedPrefs = ProfileResponseParser.parseJobPreferences(
              profileData['jobPreferences'] ?? profileData['preferences'],
              profileData['jobInterests'],
            ) ??
            onboardingPrefs;
        final profileValues =
            ProfileResponseParser.titleList(profileData['values']);
        final parsedValues =
            profileValues.isNotEmpty ? profileValues : onboardingValues;

        if (parsedAboutMe != null) {
          await _cache.saveAboutMe(parsedAboutMe);
        }
        await _cache.saveSkills(parsedSkills);
        await _cache.saveWorkExperiences(parsedWork);
        await _cache.saveEducations(parsedEducations);
        if (parsedPrefs != null) {
          await _cache.saveJobPreferences(parsedPrefs);
        }
        if (parsedValues.isNotEmpty) {
          await _cache.saveValues(parsedValues);
        }
      }
    } catch (e) {
      _debugLog('[refreshAll] jobSeeker profile partial load -> $e');
      await _cache.saveBasics(basics);
      return ProfileLoadResult(
        basics: _cache.snapshot.basics,
        isPartial: true,
        partialError: e,
      );
    }

    try {
      await _cache.saveFiles(await _documentsService.fetchRemoteDocuments());
    } catch (e) {
      _debugLog('[refreshAll] documents load skipped -> $e');
    }

    await _cache.saveBasics(basics);
    return ProfileLoadResult(basics: _cache.snapshot.basics);
  }

  Map<String, dynamic> _decodeProfile(String body) {
    try {
      return (jsonDecode(body) as Map).cast<String, dynamic>();
    } on FormatException {
      throw Exception(
        'Failed to load profile: server returned non-JSON response',
      );
    }
  }

  static String _prettyJson(Object value) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }
}

void _debugLog(String message) {
  if (kDebugMode) debugPrint(message);
}
