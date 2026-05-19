import '../models/job_search_models.dart';
import '../utils/api_mappers.dart' as mapper;

class JobSearchParser {
  const JobSearchParser._();

  static JobListing parseJob(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final title = json['title'] as String? ?? '';
    final companyName = json['company'] as String? ?? '';
    final companyKey = companyName.isNotEmpty ? companyName : title;
    final companyInitials =
        json['logoInitials'] as String? ?? mapper.initials(companyKey);
    final salary = json['salary'] as String? ?? '';
    final location = json['location'] as String?;
    final workMode = json['workType'] as String?;
    final employmentType = json['schedule'] as String?;
    final level = json['level'] as String?;
    final category = json['category'] as String? ?? '';
    final posted = json['postedAgo'] as String? ??
        mapper.apiDateString(json['postedAt'] ?? json['createdAt']);
    final matchPct = (json['matchPercent'] as num?)?.toInt() ?? 0;
    final matchLabel =
        json['matchLabel'] as String? ?? mapper.matchLabel(matchPct);
    final isSaved = json['saved'] == true;

    return JobListing(
      id: id,
      jobTitle: title,
      companyName: companyName,
      companyInitials: companyInitials,
      companyColor: mapper.colorFromString(companyKey),
      salary: salary,
      matchPercentage: matchPct,
      matchLabel: matchLabel,
      category: category,
      location: location,
      workMode: workMode,
      employmentType: employmentType,
      level: level,
      postedAgo: posted,
      isSaved: isSaved,
    );
  }
}
