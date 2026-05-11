import '../models/applications_models.dart';
import '../models/job_detail_models.dart';

/// Merges sparse API-level [JobDetail] fields with richer cached data from a
/// local [Application] or [Invitation], favouring non-empty values in order.
JobDetail enrichJobDetail(
  JobDetail apiDetail, {
  Application? application,
  Invitation? invitation,
}) {
  final companyName = _pickString(
    apiDetail.companyName,
    application?.companyName,
    invitation?.companyName,
  );
  final companyInitials = _pickString(
    apiDetail.companyLogoInitials,
    application?.companyInitials,
    invitation?.companyInitials,
  );
  final companyColor = apiDetail.companyName.isNotEmpty
      ? apiDetail.companyLogoColor
      : application?.companyLogoColor ??
          invitation?.companyLogoColor ??
          apiDetail.companyLogoColor;
  final postedDate = _pickString(
    apiDetail.postedDate,
    application?.postedAgo,
    invitation?.postedAgo,
  );
  final salary = _pickString(
    apiDetail.salary,
    application?.salary,
    invitation?.salary,
    apiDetail.salaryRange,
  );

  return JobDetail(
    id: apiDetail.id,
    appliedAt: _pickString(
      apiDetail.appliedAt,
      application?.appliedAt,
      invitation?.postedAgo,
    ),
    statusLabel: _pickString(
      apiDetail.statusLabel,
      application?.status.label,
    ),
    deadline: apiDetail.deadline,
    postedDate: postedDate,
    jobTitle: _pickString(
      apiDetail.jobTitle,
      application?.jobTitle,
      invitation?.jobTitle,
    ),
    companyName: companyName,
    companyLogoColor: companyColor,
    companyLogoInitials: companyInitials,
    matchPercentage: _pickInt(
      apiDetail.matchPercentage,
      application?.matchPercentage,
      invitation?.matchPercentage,
    ),
    matchLabel: _pickString(
      apiDetail.matchLabel,
      application?.matchLabel,
      invitation?.matchLabel,
    ),
    location: _pickString(
      apiDetail.location,
      application?.location,
      invitation?.location,
    ),
    jobType: _pickString(
      apiDetail.jobType,
      application?.employmentType,
      invitation?.employmentType,
    ),
    salaryRange: _pickString(
      apiDetail.salaryRange,
      application?.salary,
      invitation?.salary,
    ),
    workplace: _pickString(
      apiDetail.workplace,
      application?.workplaceType,
      invitation?.workplaceType,
    ),
    experienceLevel: _pickString(
      apiDetail.experienceLevel,
      application?.experienceLevel,
      invitation?.experienceLevel,
    ),
    languages: apiDetail.languages,
    description: apiDetail.description,
    requirements: apiDetail.requirements,
    skills: apiDetail.skills,
    communication: apiDetail.communication,
    niceToHave: apiDetail.niceToHave,
    whatWeOffer: apiDetail.whatWeOffer,
    reviews: apiDetail.reviews,
    recommended: apiDetail.recommended,
    company: JobDetailCompany(
      name: _pickString(apiDetail.company.name, companyName),
      industry: apiDetail.company.industry,
      logoColor: apiDetail.company.name.isNotEmpty
          ? apiDetail.company.logoColor
          : companyColor,
      logoInitials:
          _pickString(apiDetail.company.logoInitials, companyInitials),
      totalReviews: apiDetail.company.totalReviews,
      averageRating: apiDetail.company.averageRating,
      description: apiDetail.company.description,
    ),
    salary: salary,
  );
}

String _pickString(String? first,
    [String? second, String? third, String? fourth]) {
  for (final value in [first, second, third, fourth]) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return '';
}

int _pickInt(int first, [int? second, int? third]) {
  for (final value in [first, second, third]) {
    if (value != null && value > 0) return value;
  }
  return 0;
}
