import 'package:flutter/material.dart';

import '../../../models/job_detail_models.dart';
import '../../../providers/tour_provider.dart';
import '../../../utils/layout_offsets.dart';
import 'job_detail_announcement_banner.dart';
import 'job_detail_company_card.dart';
import 'job_detail_main_card.dart';
import 'job_detail_match_banner.dart';
import 'job_detail_odyssea_review_card.dart';
import 'job_detail_recommended_section.dart';

class JobDetailBody extends StatelessWidget {
  final JobDetail detail;
  final TourState? tourState;
  final Map<int, GlobalKey> tourKeys;
  final bool isSaved;
  final bool hasReminder;
  final bool isNotInterested;
  final bool announcementDismissed;
  final VoidCallback onDismissAnnouncement;
  final VoidCallback onSave;
  final VoidCallback onApply;
  final VoidCallback onNotInterested;
  final VoidCallback onUndoNotInterested;
  final VoidCallback onDeadlineReminder;
  final VoidCallback onDeleteReminder;
  final VoidCallback onReport;
  final VoidCallback onShare;
  final VoidCallback onAskCareerAssistant;

  const JobDetailBody({
    super.key,
    required this.detail,
    required this.tourState,
    required this.tourKeys,
    required this.isSaved,
    required this.hasReminder,
    required this.isNotInterested,
    required this.announcementDismissed,
    required this.onDismissAnnouncement,
    required this.onSave,
    required this.onApply,
    required this.onNotInterested,
    required this.onUndoNotInterested,
    required this.onDeadlineReminder,
    required this.onDeleteReminder,
    required this.onReport,
    required this.onShare,
    required this.onAskCareerAssistant,
  });

  @override
  Widget build(BuildContext context) {
    final topOffset = context.ithakiTopOffset;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: topOffset),

        // Announcement banner
        if (!announcementDismissed)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child:
                JobDetailAnnouncementBanner(onDismiss: onDismissAnnouncement),
          ),

        // Match banner
        if (detail.matchPercentage > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: KeyedSubtree(
              key: tourState?.currentStep == 4 ? tourKeys[4] : null,
              child: JobDetailMatchBanner(
                percentage: detail.matchPercentage,
                matchLabel: detail.matchLabel,
                onAskCareerAssistant: onAskCareerAssistant,
              ),
            ),
          ),

        // Main job card
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: KeyedSubtree(
            key: tourState?.currentStep == 5 ? tourKeys[5] : null,
            child: JobDetailMainJobCard(
              detail: detail,
              hasReminder: hasReminder,
              isNotInterested: isNotInterested,
              onDeadlineReminder: onDeadlineReminder,
              onDeleteReminder: onDeleteReminder,
              onReport: onReport,
              onShare: onShare,
              onNotInterested: onNotInterested,
            ),
          ),
        ),

        // Odyssea review
        if (detail.odysseaRating.isNotEmpty || detail.odysseaPoints.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: OdysseaReviewCard(
              rating: detail.odysseaRating,
              points: detail.odysseaPoints,
            ),
          ),

        // Recommended
        if (detail.recommended.jobTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: RecommendedJobsSection(jobs: [detail.recommended]),
          ),

        // Company
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: JobDetailCompanyCard(company: detail.company),
        ),

        SizedBox(height: MediaQuery.paddingOf(context).bottom + 140),
      ]),
    );
  }
}
