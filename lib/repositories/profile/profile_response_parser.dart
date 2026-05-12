import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import 'profile_api_mapper.dart';
import 'profile_country_resolver.dart';

class ProfileResponseParser {
  static Map<String, dynamic>? stringMap(dynamic value) =>
      value is Map ? value.cast<String, dynamic>() : null;

  static List<Map<String, dynamic>> mapList(dynamic value) => value is List
      ? value
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList()
      : const [];

  static List<String> titleList(dynamic value) => value is List
      ? value
          .map((item) => ProfileApiMapper.titleOrText(item))
          .where((item) => item.isNotEmpty)
          .toList()
      : const [];

  static String firstTitle(dynamic value) {
    if (value is List) {
      for (final item in value) {
        final title = ProfileApiMapper.titleOrText(item);
        if (title.isNotEmpty) return title;
      }
      return '';
    }
    return ProfileApiMapper.titleOrText(value);
  }

  static double? doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse((value ?? '').toString());
  }

  static bool boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = ProfileApiMapper.titleOrText(value).toLowerCase();
    return text == 'true' || text == 'yes' || text == '1';
  }

  static String textValue(dynamic value) => ProfileApiMapper.titleOrText(value);

  static bool isLocalFilePath(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return false;
    final uri = Uri.tryParse(text);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return false;
    }
    return File(text).existsSync() ||
        (uri != null &&
            uri.isScheme('file') &&
            File(uri.toFilePath()).existsSync());
  }

  static String? localFilePath(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri != null && uri.isScheme('file')) return uri.toFilePath();
    return text;
  }

  static String? normalizePhotoUrl(dynamic raw) {
    final value = raw is Map
        ? textValue(raw['url'] ?? raw['signedUrl'] ?? raw['photo'])
        : textValue(raw);
    if (value.isEmpty) return null;

    for (final marker in const [
      'https%3A//',
      'https%3A%2F%2F',
      'http%3A//',
      'http%3A%2F%2F',
    ]) {
      final start = value.indexOf(marker);
      if (start <= 0) continue;
      final outerQueryStart = value.indexOf('?Expires=', start);
      final encoded = outerQueryStart == -1
          ? value.substring(start)
          : value.substring(start, outerQueryStart);
      final decoded = Uri.decodeFull(encoded);
      final uri = Uri.tryParse(decoded);
      if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
        return decoded;
      }
    }

    return value;
  }

  static bool isRemotePhoto(String? value) {
    final uri = Uri.tryParse(value?.trim() ?? '');
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  static UploadedFile documentFromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is num ? idRaw.toInt() : int.tryParse('$idRaw');
    final name = textValue(json['name']);
    final type = textValue(json['type']);
    final uploadedAt = textValue(json['uploadedAt']);
    final date =
        uploadedAt.contains('T') ? uploadedAt.split('T').first : uploadedAt;
    final url = _parseDocumentUrl(json);
    return UploadedFile(
      id: id,
      name: name.isEmpty ? 'Document' : name,
      size: date.isNotEmpty ? date : (type.isNotEmpty ? type : 'Uploaded'),
      type: type.isEmpty ? null : type,
      uploadedAt: uploadedAt.isEmpty ? null : uploadedAt,
      url: url,
    );
  }

  static String? _parseDocumentUrl(Map<String, dynamic> json) {
    for (final key in ['url', 'fileUrl', 'downloadUrl', 'path', 'filePath']) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static Future<List<UploadedFile>> fetchRemoteDocuments(ApiClient api) async {
    final response = await api.get('/files/me/documents');
    debugPrint('[documents] list status -> ${response.statusCode}');
    debugPrint('[documents] list body -> ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to load documents: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    final raw = decoded is List
        ? decoded
        : decoded is Map
            ? decoded['content'] ?? decoded['data'] ?? const []
            : const [];
    return (raw as List)
        .whereType<Map>()
        .map((item) => documentFromJson(item.cast<String, dynamic>()))
        .toList();
  }

  static ProfileJobPreferences? parseJobPreferences(
    dynamic preferences,
    dynamic interests,
  ) {
    final prefs = stringMap(preferences);
    if (prefs == null) return null;

    final parsed = ProfileJobPreferences(
      jobInterests: mapList(interests)
          .map(
            (item) => JobInterest(
              id: (item['value'] ?? item['id'] ?? '').toString(),
              title: firstTitle(
                ProfileApiMapper.titleOrText(item['title']).isNotEmpty
                    ? item['title']
                    : item,
              ),
              category: ProfileApiMapper.titleOrText(item['category']),
            ),
          )
          .where((item) => item.title.isNotEmpty)
          .toList(),
      positionLevel:
          firstTitle(prefs['experienceLevel'] ?? prefs['positionLevel']),
      jobType: firstTitle(
        prefs['employmentType'] ?? prefs['jobType'] ?? prefs['jobTypes'],
      ),
      workplace: firstTitle(
        prefs['workLocation'] ??
            prefs['workplace'] ??
            prefs['workplaceFormats'],
      ),
      expectedSalary:
          doubleValue(prefs['salaryExpected'] ?? prefs['expectedPayment']),
      preferNotToSpecifySalary: prefs['preferNotToSpecify'] as bool? ?? false,
    );

    final hasData = parsed.jobInterests.isNotEmpty ||
        parsed.positionLevel.isNotEmpty ||
        parsed.jobType.isNotEmpty ||
        parsed.workplace.isNotEmpty ||
        parsed.expectedSalary != null ||
        parsed.preferNotToSpecifySalary;
    return hasData ? parsed : null;
  }

  static ProfileBasics parseBasicsFromUser(Map<String, dynamic> userData) {
    final phoneVerified = userData['phoneVerified'] as bool? ?? false;
    ProfileBasics basics = ProfileBasics(
      firstName: textValue(userData['firstName']),
      lastName: textValue(userData['lastName']),
      email: textValue(userData['email']),
      phone: textValue(userData['phone']),
      photoUrl: normalizePhotoUrl(userData['photo']),
      phoneVerified: phoneVerified,
    );

    final onboarding = stringMap(userData['onboarding']);
    final onboardingLocation = stringMap(onboarding?['location']);
    if (onboardingLocation != null) {
      final citizenship = onboardingLocation['citizenship'];
      final residence = onboardingLocation['residence'];
      basics = basics.copyWith(
        citizenship: ProfileCountryResolver.countryNameFor(citizenship),
        citizenshipCode: ProfileCountryResolver.countryCodeFor(citizenship),
        residence: ProfileCountryResolver.countryNameFor(residence),
        residenceCode: ProfileCountryResolver.countryCodeFor(residence),
        status: ProfileApiMapper.enumTitle(onboardingLocation['status']),
        relocationReadiness: ProfileApiMapper.enumTitle(
          onboardingLocation['relocationReadiness'],
        ),
      );
    }

    return basics;
  }

  static ProfileBasics applyProfileBasics(
    ProfileBasics basics,
    Map<String, dynamic> profileData,
  ) {
    var result = basics;

    final b = stringMap(profileData['basics']);
    if (b != null) {
      final dateOfBirth = ProfileApiMapper.isoDateToDdMmYyyy(b['dateOfBirth']);
      final gender = ProfileApiMapper.enumTitle(b['gender']);
      final citizenship =
          ProfileCountryResolver.countryNameFor(b['citizenship']);
      final citizenshipCode =
          ProfileCountryResolver.countryCodeFor(b['citizenship']);
      final residence = ProfileCountryResolver.countryNameFor(b['residence']);
      final residenceCode =
          ProfileCountryResolver.countryCodeFor(b['residence']);
      debugPrint('[refreshAll] basics.photo → ${b['photo']}');
      result = result.copyWith(
        phone: textValue(b['phone']).isNotEmpty
            ? textValue(b['phone'])
            : result.phone,
        dateOfBirth: dateOfBirth.isNotEmpty ? dateOfBirth : result.dateOfBirth,
        gender: gender.isNotEmpty ? gender : result.gender,
        citizenship: citizenship.isNotEmpty ? citizenship : result.citizenship,
        citizenshipCode: citizenshipCode.isNotEmpty
            ? citizenshipCode
            : result.citizenshipCode,
        residence: residence.isNotEmpty ? residence : result.residence,
        residenceCode:
            residenceCode.isNotEmpty ? residenceCode : result.residenceCode,
        photoUrl: normalizePhotoUrl(b['photo']),
      );
    }

    final loc = stringMap(profileData['location']);
    if (loc != null) {
      final status = ProfileApiMapper.enumTitle(loc['status']);
      final relocationReadiness =
          ProfileApiMapper.enumTitle(loc['relocationReadiness']);
      result = result.copyWith(
        status: status.isNotEmpty ? status : result.status,
        relocationReadiness: relocationReadiness.isNotEmpty
            ? relocationReadiness
            : result.relocationReadiness,
      );
    }

    return result;
  }

  static ProfileAboutMe? parseAboutMe(Map<String, dynamic> profileData) {
    final about = stringMap(profileData['aboutMe']);
    if (about == null) return null;
    final bio = textValue(about['bio']);
    final text = textValue(about['text']);
    final video = textValue(about['video']);
    final videoUrl = video.isNotEmpty ? video : textValue(about['videoUrl']);
    return ProfileAboutMe(
      bio: bio.isNotEmpty ? bio : text,
      videoUrl: videoUrl.isEmpty ? null : videoUrl,
    );
  }

  static ProfileSkills parseSkills(
    Map<String, dynamic> profileData,
    ProfileSkills current,
  ) {
    final skillsMap = stringMap(profileData['skills']);
    final competencies = profileData['competencies'];
    final languageList = profileData['languages'];
    return ProfileSkills(
      hardSkills: skillsMap != null
          ? ProfileApiMapper.stringList(skillsMap['hardSkills'])
          : current.hardSkills,
      softSkills: skillsMap != null
          ? ProfileApiMapper.stringList(skillsMap['softSkills'])
          : current.softSkills,
      languages: mapList(languageList)
          .map(
            (l) => Language(
              language: ProfileApiMapper.titleOrText(l['language']).isNotEmpty
                  ? ProfileApiMapper.titleOrText(l['language'])
                  : ProfileApiMapper.titleOrText(l['languageName']),
              proficiency: ProfileApiMapper.titleOrText(l['level']).isNotEmpty
                  ? ProfileApiMapper.titleOrText(l['level'])
                  : ProfileApiMapper.titleOrText(l['proficiency']),
            ),
          )
          .where((l) => l.language.isNotEmpty)
          .toList(),
      competencies: competencies is Map
          ? competencies.cast<String, dynamic>().map(
                (key, value) =>
                    MapEntry(key, ProfileApiMapper.titleOrText(value)),
              )
          : current.competencies,
    );
  }

  static List<WorkExperience> parseWorkExperiences(
      Map<String, dynamic> profileData) {
    return mapList(
            profileData['workExperience'] ?? profileData['workExperiences'])
        .map(
          (item) => WorkExperience(
            jobTitle: textValue(item['title']),
            companyName: textValue(item['companyName']),
            location: ProfileApiMapper.titleOrText(item['city']),
            experienceLevel: ProfileApiMapper.titleOrText(item['level']),
            workplace: ProfileApiMapper.titleOrText(item['employmentType']),
            jobType: ProfileApiMapper.titleOrText(item['workType']),
            startDate:
                ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
            endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
            currentlyWorkHere: boolValue(item['current']),
            summary: textValue(item['description']).isEmpty
                ? null
                : textValue(item['description']),
          ),
        )
        .where((e) => e.jobTitle.isNotEmpty || e.companyName.isNotEmpty)
        .toList();
  }

  static List<Education> parseEducations(Map<String, dynamic> profileData) {
    return mapList(profileData['education'] ?? profileData['educations'])
        .map(
          (item) => Education(
            institutionName: textValue(item['institution']).isNotEmpty
                ? textValue(item['institution'])
                : textValue(item['institutionName']),
            fieldOfStudy: textValue(item['fieldOfStudy']),
            location: ProfileApiMapper.titleOrText(item['city']),
            degreeType: textValue(item['degree']).isNotEmpty
                ? textValue(item['degree'])
                : textValue(item['degreeType']),
            startDate:
                ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
            endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
            currentlyStudyHere: boolValue(item['currentlyStudying']),
          ),
        )
        .where((e) => e.institutionName.isNotEmpty || e.fieldOfStudy.isNotEmpty)
        .toList();
  }
}
