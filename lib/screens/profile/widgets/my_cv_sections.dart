import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../config/app_config.dart';
import '../../../data/mock_profile_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/assessment_models.dart';
import '../../../models/profile_models.dart';
import '../../company/widgets/company_cultural_fit_gauge.dart';

class MyCvData {
  const MyCvData({
    required this.avatarInitials,
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.photoPath,
    required this.gender,
    required this.age,
    required this.citizenship,
    required this.location,
    required this.workplace,
    required this.jobType,
    required this.experienceLevel,
    required this.salary,
    required this.aboutMe,
    required this.skills,
    required this.competencies,
    required this.workExperiences,
    required this.educations,
    required this.languages,
    required this.files,
    required this.assessmentCards,
  });

  final String avatarInitials;
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String? photoPath;
  final String gender;
  final String age;
  final String citizenship;
  final String location;
  final String workplace;
  final String jobType;
  final String experienceLevel;
  final String salary;
  final String aboutMe;
  final List<String> skills;
  final Map<String, String> competencies;
  final List<WorkExperience> workExperiences;
  final List<Education> educations;
  final List<Language> languages;
  final List<UploadedFile> files;
  final List<Assessment> assessmentCards;

  factory MyCvData.fromSources({
    required ProfileBasics basics,
    required ProfileAboutMe aboutMe,
    required ProfileSkills skills,
    required List<WorkExperience> workExperiences,
    required List<Education> educations,
    required List<UploadedFile> files,
    required ProfileJobPreferences jobPreferences,
    required List<Assessment> assessments,
  }) {
    const fallbackEducations = [
      Education(
        institutionName: 'National Technical University of Athens',
        fieldOfStudy: 'Computer Science',
        location: 'Athens, Greece',
        degreeType: 'Bachelor’s Degree',
        startDate: '09-2017',
        endDate: '07-2021',
      ),
    ];

    final fullName = _value(
      '${basics.firstName} ${basics.lastName}'.trim(),
      'Christos Ioannides',
    );
    final avatarInitials = basics.initials == '??' ? 'CI' : basics.initials;
    final combinedSkills = [
      ...skills.hardSkills,
      ...skills.softSkills,
    ];
    final salaryValue = jobPreferences.preferNotToSpecifySalary
        ? ''
        : jobPreferences.expectedSalary == null
            ? ''
            : '${jobPreferences.expectedSalary!.toStringAsFixed(0)} € / month';
    final completedAssessments = assessments
        .where((assessment) => assessment.status == AssessmentStatus.completed)
        .take(3)
        .toList();

    return MyCvData(
      avatarInitials: avatarInitials,
      fullName: fullName,
      jobTitle: _value(
        jobPreferences.jobInterests.firstOrNull?.title,
        'Frontend Developer',
      ),
      email: _value(basics.email, 'c.ioanidis@gmail.com'),
      phone: _value(basics.phone, '+30 123 456 78 90'),
      photoPath: basics.photoUrl,
      gender: _value(basics.gender, 'Male'),
      age: _value(_ageFromDate(basics.dateOfBirth), '29'),
      citizenship: _value(basics.citizenship, 'Greek'),
      location: _value(basics.residence, 'Chalkidiki, Greece'),
      workplace: _value(jobPreferences.workplace, 'On-site'),
      jobType: _value(jobPreferences.jobType, 'Full-Time'),
      experienceLevel: _value(jobPreferences.positionLevel, 'Middle (3 years)'),
      salary: _value(salaryValue, '21,500 € / month'),
      aboutMe: _value(
        aboutMe.bio,
        mockProfileAboutMe.bio,
      ),
      skills: combinedSkills.isEmpty ? mockCvSkills : combinedSkills,
      competencies: skills.competencies.isEmpty
          ? mockProfileCompetencies
          : skills.competencies,
      workExperiences: workExperiences.isEmpty
          ? mockProfileWorkExperiences
          : workExperiences,
      educations: educations.isEmpty ? fallbackEducations : educations,
      languages:
          skills.languages.isEmpty ? mockProfileLanguages : skills.languages,
      files: files.isEmpty ? mockProfileFiles : files,
      assessmentCards: completedAssessments,
    );
  }

  static String _value(String? current, String fallback) {
    if (current != null && current.trim().isNotEmpty) {
      return current.trim();
    }

    if (AppConfig.shouldUseMockData) {
      return fallback;
    }

    return '';
  }

  static String _ageFromDate(String dateOfBirth) {
    final parts = dateOfBirth.split('-');
    if (parts.length < 3) {
      return '';
    }

    final year = int.tryParse(parts[2]);
    if (year == null) {
      return '';
    }

    return '${DateTime.now().year - year}';
  }
}

class DraftReviewBanner extends StatelessWidget {
  const DraftReviewBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Center(
              child: IthakiIcon(
                'help',
                size: 18,
                color: IthakiTheme.primaryPurple,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.cvDraftReviewTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l.cvDraftReviewBody,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CvHeaderCard extends StatelessWidget {
  const CvHeaderCard({
    super.key,
    required this.data,
    required this.isPublished,
    required this.onLearnMorePressed,
    required this.onPublishPressed,
    required this.onReturnToProfilePressed,
  });

  final MyCvData data;
  final bool isPublished;
  final VoidCallback onLearnMorePressed;
  final VoidCallback onPublishPressed;
  final VoidCallback onReturnToProfilePressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final badgeLabel = isPublished ? l.publishedBadge : l.draftModeBadge;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CvAvatarBadge(
                initials: data.avatarInitials,
                photoPath: data.photoPath,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.jobTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.softGraphite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          CvContactRow(icon: 'envelope', value: data.email),
          const SizedBox(height: 8),
          CvContactRow(icon: 'phone', value: data.phone),
          const SizedBox(height: 12),
          Text(
            l.contactVisibilityNote,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: IthakiTheme.softGray.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(24),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useVerticalLayout = constraints.maxWidth < 340;
                final gaugeWidth = useVerticalLayout
                    ? constraints.maxWidth * 0.64
                    : constraints.maxWidth * 0.42;
                final gaugeHeight = gaugeWidth * 0.62;

                final gauge = CompanyCulturalFitGauge(
                  label: l.highLabel,
                  width: gaugeWidth.clamp(150.0, 186.0),
                  height: gaugeHeight.clamp(92.0, 112.0),
                  titleFontSize: 20,
                  subtitleFontSize: 10,
                  labelWidthFactor: 0.92,
                  textAlignment: const Alignment(0, 0.43),
                );

                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.youBothShareSameValues,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: onLearnMorePressed,
                      child: Text(
                        l.learnMore,
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                );

                if (useVerticalLayout) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: gauge,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DefaultTextStyle.merge(
                          textAlign: TextAlign.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l.youBothShareSameValues,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  color: IthakiTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: onLearnMorePressed,
                                child: Text(
                                  l.learnMore,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: IthakiTheme.textPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    gauge,
                    const SizedBox(width: 12),
                    Expanded(
                      child: details,
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child:
                      CvInfoCell(label: l.genderInfoLabel, value: data.gender)),
              Expanded(
                  child: CvInfoCell(label: l.ageInfoLabel, value: data.age)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: CvInfoCell(
                    label: l.citizenshipLabel, value: data.citizenship),
              ),
              Expanded(
                child: CvInfoCell(
                    label: l.locationInfoLabel, value: data.location),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'location',
                    value: data.workplace,
                  ),
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'clock',
                    value: data.jobType,
                  ),
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'resume',
                    value: data.experienceLevel,
                  ),
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'jobs',
                    value: data.salary,
                    isStrong: true,
                  ),
                ],
              );
            },
          ),
          if (!isPublished) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: IthakiButton(
                l.publishCv,
                onPressed: onPublishPressed,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: IthakiOutlineButton(
                l.returnToProfileSetup,
                icon: const IthakiIcon('edit-pencil', size: 18),
                onPressed: onReturnToProfilePressed,
                borderRadius: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CvSectionCard extends StatelessWidget {
  const CvSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 12),
            IthakiOutlineButton(
              actionLabel!,
              icon: const IthakiIcon('edit-pencil', size: 18),
              onPressed: onActionPressed,
              borderRadius: 22,
            ),
          ],
        ],
      ),
    );
  }
}

class CvAssistantCard extends StatelessWidget {
  const CvAssistantCard({super.key, required this.onAskPressed});

  final VoidCallback onAskPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF232124),
            const Color(0xFF232124),
            IthakiTheme.primaryPurple.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.greatJob,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.backgroundWhite,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.cvLevelLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    color: IthakiTheme.backgroundWhite,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: IthakiTheme.matchGreen,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l.strongLevel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l.cvAssistantImprovementSummary,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: IthakiTheme.backgroundWhite,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: IthakiOutlineButton(
              l.askCareerAssistant,
              icon: const IthakiIcon(
                'ai',
                size: 18,
                color: IthakiTheme.backgroundWhite,
              ),
              onPressed: onAskPressed,
              borderRadius: 24,
              foregroundColor: IthakiTheme.backgroundWhite,
              borderColor: IthakiTheme.backgroundWhite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class CvExperienceCard extends StatelessWidget {
  const CvExperienceCard({
    super.key,
    required this.experience,
    required this.showEditButton,
    this.onEditPressed,
  });

  final WorkExperience experience;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final endDate =
        experience.currentlyWorkHere ? l.present : experience.endDate ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: IthakiTheme.textPrimary,
                height: 1.35,
              ),
              text: l.experienceAtCompany(
                experience.jobTitle,
                experience.companyName,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.periodWithDuration(
              experience.startDate,
              endDate,
              experience.duration,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CvMetaValue(
                    width: width,
                    icon: 'location',
                    value: experience.location,
                  ),
                  CvMetaValue(
                    width: width,
                    icon: 'jobs',
                    value: experience.workplace,
                  ),
                  CvMetaValue(
                    width: width,
                    icon: 'clock',
                    value: experience.jobType,
                  ),
                  CvMetaValue(
                    width: width,
                    icon: 'resume',
                    value: experience.experienceLevel,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          Text(
            experience.summary ?? '',
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: IthakiTheme.textPrimary,
            ),
          ),
          if (showEditButton && onEditPressed != null) ...[
            const SizedBox(height: 14),
            IthakiOutlineButton(
              l.editWorkExperience,
              icon: const IthakiIcon('edit-pencil', size: 18),
              onPressed: onEditPressed,
              borderRadius: 22,
            ),
          ],
        ],
      ),
    );
  }
}

class CvEducationCard extends StatelessWidget {
  const CvEducationCard({
    super.key,
    required this.education,
    required this.showEditButton,
    this.onEditPressed,
  });

  final Education education;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final endDate =
        education.currentlyStudyHere ? l.present : education.endDate ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: IthakiTheme.textPrimary,
                height: 1.45,
              ),
              text: l.educationAtInstitution(
                education.fieldOfStudy,
                education.institutionName,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.periodWithDuration(
              education.startDate,
              endDate,
              education.duration,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          CvMetaValue(
            width: double.infinity,
            icon: 'location',
            value: education.location,
          ),
          const SizedBox(height: 12),
          CvMetaValue(
            width: double.infinity,
            icon: 'resume',
            value: education.degreeType,
          ),
          if (showEditButton && onEditPressed != null) ...[
            const SizedBox(height: 14),
            IthakiOutlineButton(
              l.editEducation,
              icon: const IthakiIcon('edit-pencil', size: 18),
              onPressed: onEditPressed,
              borderRadius: 22,
            ),
          ],
        ],
      ),
    );
  }
}

class CvFileCard extends StatelessWidget {
  const CvFileCard({
    super.key,
    required this.file,
    required this.isPublished,
    this.onDelete,
  });

  final UploadedFile file;
  final bool isPublished;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: IthakiTheme.softGray.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.softGraphite,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.size,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: IthakiOutlineButton(
                  l.open,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.openingFile(file.name))),
                    );
                  },
                  borderRadius: 22,
                ),
              ),
              if (!isPublished && onDelete != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: IthakiOutlineButton(
                    l.delete,
                    icon: const IthakiIcon('delete', size: 18),
                    onPressed: onDelete,
                    borderRadius: 22,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class CvAssessmentCard extends StatelessWidget {
  const CvAssessmentCard({
    super.key,
    required this.assessment,
    required this.onToggle,
  });

  final Assessment assessment;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final result = assessment.lastResult;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Center(
                  child: IthakiIcon(
                    assessment.iconName,
                    size: 22,
                    color: IthakiTheme.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.assessmentCategoryLabel(assessment.category),
                      style: const TextStyle(
                        fontSize: 14,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                result.level,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: IthakiOutlineButton(
                result.shownInCV
                    ? l.assessmentHideFromCV
                    : l.assessmentShowInCV,
                icon: const IthakiIcon('eye-closed', size: 18),
                onPressed: onToggle,
                borderRadius: 22,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CareerAssistantSheet extends StatelessWidget {
  const CareerAssistantSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: IthakiTheme.softGraphite,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: IthakiIcon(
                      'ai',
                      size: 22,
                      color: IthakiTheme.backgroundWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.pathfinderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.careerAssistantTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const IthakiIcon(
                    'x-close',
                    size: 20,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        IthakiTheme.primaryPurpleLight.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    l.pathfinderAdviceText,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.askCareerPathHint,
                          style: const TextStyle(
                            fontSize: 15,
                            color: IthakiTheme.textSecondary,
                          ),
                        ),
                      ),
                      const IthakiIcon(
                        'rocket',
                        size: 20,
                        color: IthakiTheme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveWithoutPublishingSheet extends StatelessWidget {
  const LeaveWithoutPublishingSheet({
    super.key,
    required this.onLeaveWithoutSaving,
    required this.onSaveAndLeave,
  });

  final VoidCallback onLeaveWithoutSaving;
  final VoidCallback onSaveAndLeave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.leaveWithoutPublishingTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const IthakiIcon(
                  'x-close',
                  size: 20,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l.leaveWithoutPublishingMessage,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: IthakiOutlineButton(
              l.leaveWithoutSaving,
              onPressed: onLeaveWithoutSaving,
              borderRadius: 24,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              l.saveAndLeave,
              onPressed: onSaveAndLeave,
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingActionShelf extends StatelessWidget {
  const FloatingActionShelf({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: IthakiTheme.backgroundWhite.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: IthakiTheme.borderLight.withValues(alpha: 0.85),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class CvAvatarBadge extends StatelessWidget {
  const CvAvatarBadge({super.key, required this.initials, this.photoPath});

  final String initials;
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.trim().isNotEmpty;
    return CircleAvatar(
      radius: 24,
      backgroundColor: IthakiTheme.softGraphite,
      backgroundImage: hasPhoto ? FileImage(File(photoPath!)) : null,
      child: hasPhoto
          ? null
          : Text(
              initials,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: IthakiTheme.backgroundWhite,
              ),
            ),
    );
  }
}

class CvContactRow extends StatelessWidget {
  const CvContactRow({super.key, required this.icon, required this.value});

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: IthakiTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class CvInfoCell extends StatelessWidget {
  const CvInfoCell({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: IthakiTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class CvMetaValue extends StatelessWidget {
  const CvMetaValue({
    super.key,
    required this.width,
    required this.icon,
    required this.value,
    this.isStrong = false,
  });

  final double width;
  final String icon;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isStrong ? FontWeight.w700 : FontWeight.w500,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CvSkillChip extends StatelessWidget {
  const CvSkillChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: IthakiTheme.textPrimary,
        ),
      ),
    );
  }
}

class CvKeyValueRow extends StatelessWidget {
  const CvKeyValueRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.softGraphite,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CvLanguageRow extends StatelessWidget {
  const CvLanguageRow({super.key, required this.language});

  final Language language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          IthakiLanguageFlag(language.language, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              language.language,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
          Text(
            language.proficiency,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
