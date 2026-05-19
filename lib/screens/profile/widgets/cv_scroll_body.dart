import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../config/app_config.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/assessment_provider.dart';
import '../../../providers/cv_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../utils/profile_competency_display.dart';
import 'cv_assistant_card.dart';
import 'cv_atoms.dart';
import 'cv_data.dart';
import 'cv_assessment_card.dart';
import 'cv_education_card.dart';
import 'cv_experience_card.dart';
import 'cv_file_card.dart';
import 'cv_header_card.dart';
import 'cv_overlays.dart';
import 'cv_section_card.dart';

class CvScrollBody extends ConsumerWidget {
  const CvScrollBody({
    super.key,
    required this.cvData,
    required this.isPublished,
    required this.topOffset,
    required this.onAskCareerAssistant,
  });

  final MyCvData cvData;
  final bool isPublished;
  final double topOffset;
  final VoidCallback onAskCareerAssistant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        topOffset + 8,
        16,
        MediaQuery.viewPaddingOf(context).bottom + 148,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isPublished) ...[
            const DraftReviewBanner(),
            const SizedBox(height: 12),
          ],
          CvHeaderCard(
            data: cvData,
            isPublished: isPublished,
            onLearnMorePressed: AppConfig.showCareerAssistantInProfile
                ? onAskCareerAssistant
                : null,
            onPublishPressed: () =>
                ref.read(cvPublishedProvider.notifier).setPublished(true),
            onReturnToProfilePressed: () => context.push(Routes.profile),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.profileAboutMeTitle,
            actionLabel: isPublished
                ? null
                : (AppConfig.showVideoIntroductionInProfile
                    ? l.editAboutMeVideo
                    : '${l.edit} ${l.profileAboutMeTitle}'),
            onActionPressed:
                isPublished ? null : () => context.push(Routes.profileAboutMe),
            child: Text(
              cvData.aboutMe,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.profileSkillsTitle,
            actionLabel: isPublished ? null : l.editSkillsTitle,
            onActionPressed:
                isPublished ? null : () => context.push(Routes.profileSkills),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  cvData.skills.map((s) => CvSkillChip(label: s)).toList(),
            ),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.competenciesTitle,
            actionLabel: isPublished ? null : l.editCompetenciesTitle,
            onActionPressed: isPublished
                ? null
                : () => context.push(Routes.profileCompetencies),
            child: Column(
              children: profileCompetencyDisplayRows(cvData.competencies, l)
                  .map((e) => CvKeyValueRow(label: e.label, value: e.value))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.profileWorkExperienceTitle,
            actionLabel: isPublished ? null : l.addWorkExperience,
            onActionPressed: isPublished
                ? null
                : () => context.push(Routes.profileWorkExperience),
            child: Column(
              children: cvData.workExperiences
                  .map(
                    (exp) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CvExperienceCard(
                        experience: exp,
                        showEditButton: !isPublished,
                        onEditPressed: () =>
                            context.push(Routes.profileWorkExperience),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.profileEducationTitle,
            actionLabel: isPublished ? null : l.addEducation,
            onActionPressed: isPublished
                ? null
                : () => context.push(Routes.profileEducation),
            child: Column(
              children: cvData.educations
                  .map(
                    (edu) => CvEducationCard(
                      education: edu,
                      showEditButton: !isPublished,
                      onEditPressed: () =>
                          context.push(Routes.profileEducation),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.languagesTitle,
            actionLabel: isPublished ? null : l.editLanguagesTitle,
            onActionPressed: isPublished
                ? null
                : () => context.push(Routes.profileLanguages),
            child: Column(
              children: cvData.languages
                  .map((lang) => CvLanguageRow(language: lang))
                  .toList(),
            ),
          ),
          const SizedBox(height: 12),
          CvSectionCard(
            title: l.profileMyFilesTitle,
            child: Column(
              children: cvData.files
                  .map(
                    (file) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CvFileCard(
                        file: file,
                        isPublished: isPublished,
                        onDelete:
                            isPublished ? null : () => _deleteFile(ref, file),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (!isPublished) ...[
            const SizedBox(height: 12),
            if (AppConfig.showCareerAssistantInProfile)
              CvAssistantCard(onAskPressed: onAskCareerAssistant),
          ],
          if (AppConfig.showAssessmentsInProfile &&
              isPublished &&
              cvData.assessmentCards.isNotEmpty) ...[
            const SizedBox(height: 12),
            CvSectionCard(
              title: l.assessmentsResultsTitle,
              child: Column(
                children: cvData.assessmentCards
                    .map(
                      (assessment) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CvAssessmentCard(
                          assessment: assessment,
                          onToggle: () => ref
                              .read(assessmentResultProvider(assessment.id)
                                  .notifier)
                              .toggleCV(
                                show: !(assessment.lastResult?.shownInCV ??
                                    false),
                              ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _deleteFile(WidgetRef ref, UploadedFile file) {
    final current =
        ref.read(profileFilesProvider).value ?? const <UploadedFile>[];
    final index =
        current.indexWhere((currentFile) => currentFile.name == file.name);
    if (index != -1) {
      ref.read(profileFilesProvider.notifier).delete(index);
    }
  }
}
