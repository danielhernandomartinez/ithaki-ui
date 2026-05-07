import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import '../../../providers/tour_provider.dart';
import '../../../routes.dart';
import '../../../utils/match_colors.dart';

class JobDetailShareOption extends StatelessWidget {
  final String icon;
  final String label;
  const JobDetailShareOption(
      {super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
      const SizedBox(width: 12),
      Text(label,
          style: const TextStyle(fontFamily: 'Noto Sans', fontSize: 15)),
    ]);
  }
}

// ─── Sticky bottom bar ────────────────────────────────────────────────────────

class JobDetailStickyBar extends StatelessWidget {
  final bool isSaved;
  final bool isClosed;
  final VoidCallback onApply;
  final VoidCallback onSave;

  const JobDetailStickyBar({
    super.key,
    required this.isSaved,
    required this.isClosed,
    required this.onApply,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: IthakiTheme.borderLight.withValues(alpha: 0.9),
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              IthakiButton(
                isClosed ? l.jobClosedButton : l.applyNow,
                onPressed: isClosed ? null : onApply,
              ),
              const SizedBox(height: 8),
              IthakiButton(
                isSaved ? l.removeFromSaved : l.saveJob,
                variant: IthakiButtonVariant.outline,
                onPressed: onSave,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

// ─── Scrollable body ──────────────────────────────────────────────────────────

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
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

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

// ─── Announcement banner ──────────────────────────────────────────────────────

class JobDetailAnnouncementBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  const JobDetailAnnouncementBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const IthakiIcon('rocket', size: 20, color: IthakiTheme.primaryPurple),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.newFeatureBanner,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.textPrimary,
                  height: 1.4,
                )),
            const SizedBox(height: 4),
            Text(l.readMore,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  color: IthakiTheme.textSecondary,
                  decoration: TextDecoration.underline,
                )),
          ]),
        ),
        GestureDetector(
          onTap: onDismiss,
          child: const IthakiIcon('delete',
              size: 18, color: IthakiTheme.softGraphite),
        ),
      ]),
    );
  }
}

// ─── Match banner ─────────────────────────────────────────────────────────────

class JobDetailMatchBanner extends StatelessWidget {
  final int percentage;
  final String matchLabel;
  final VoidCallback onAskCareerAssistant;

  const JobDetailMatchBanner({
    super.key,
    required this.percentage,
    required this.matchLabel,
    required this.onAskCareerAssistant,
  });

  Color get _progressColor {
    if (percentage >= 80) return IthakiTheme.matchGreen;
    if (percentage >= 60) return const Color(0xFFFFC44D);
    if (percentage >= 40) return const Color(0xFFFF8A4C);
    return const Color(0xFFFF6B6B);
  }

  String _matchCopy(AppLocalizations l) {
    if (percentage >= 80) return l.strongSkillsMatch;
    if (percentage >= 60) return l.goodSkillsMatch;
    if (percentage >= 40) return l.partialSkillsMatch;
    return l.starterSkillsMatch;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF151515),
            Color(0xFF1D1B28),
            IthakiTheme.primaryPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                ),
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: percentage.clamp(0, 100).toDouble() / 100,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _matchCopy(l),
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.45,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Divider(color: Colors.white.withValues(alpha: 0.18), height: 1),
        const SizedBox(height: 16),
        Text(
          l.curiousWhyMatch,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: onAskCareerAssistant,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.82),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const IthakiIcon('ai', size: 18, color: Colors.white),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    l.askCareerAssistant,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── Main job card ────────────────────────────────────────────────────────────

class JobDetailMainJobCard extends StatelessWidget {
  final JobDetail detail;
  final bool hasReminder;
  final bool isNotInterested;
  final VoidCallback onDeadlineReminder;
  final VoidCallback onDeleteReminder;
  final VoidCallback onReport;
  final VoidCallback onShare;
  final VoidCallback onNotInterested;

  const JobDetailMainJobCard({
    super.key,
    required this.detail,
    required this.hasReminder,
    required this.isNotInterested,
    required this.onDeadlineReminder,
    required this.onDeleteReminder,
    required this.onReport,
    required this.onShare,
    required this.onNotInterested,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Posted + menu
        Row(children: [
          Expanded(
            child: Text(l.jobPostedDate(detail.postedDate),
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
          ),
          if (detail.isClosed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(l.jobClosedLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.textPrimary,
                  )),
            )
          else
            PopupMenuButton<String>(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: IthakiTheme.borderLight),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text('···',
                    style: TextStyle(
                        fontSize: 16, color: IthakiTheme.textPrimary)),
              ),
              onSelected: (v) {
                if (v == 'reminder') onDeadlineReminder();
                if (v == 'report') onReport();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'reminder', child: Text(l.deadlineReminderLabel)),
                PopupMenuItem(value: 'report', child: Text(l.reportLabel)),
              ],
            ),
        ]),

        // Deadline banner
        if (detail.deadline.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: IthakiTheme.backgroundWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const IthakiIcon(
                    'calendar',
                    size: 18,
                    color: IthakiTheme.primaryPurple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.deadlineBannerText,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: IthakiTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          detail.deadline,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: IthakiTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // Company header
        const SizedBox(height: 14),
        Row(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: detail.companyLogoColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            alignment: Alignment.center,
            child: Text(detail.companyLogoInitials,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: detail.companyLogoColor,
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(detail.jobTitle,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.4,
                  )),
              Text(detail.companyName,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    color: IthakiTheme.softGraphite,
                  )),
            ]),
          ),
        ]),

        // Details grid
        if (_hasAnyDetail(detail)) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 10, children: [
            if (detail.location.isNotEmpty)
              JobDetailCell(
                  label: l.locationInfoLabel,
                  icon: 'location',
                  value: detail.location),
            if (detail.jobType.isNotEmpty)
              JobDetailCell(
                  label: l.jobTypeTitle, icon: 'clock', value: detail.jobType),
            if (detail.company.industry.isNotEmpty)
              JobDetailCell(
                  label: l.industryLabel, value: detail.company.industry),
            if (detail.salaryRange.isNotEmpty)
              JobDetailCell(
                  label: l.salaryRangeLabel,
                  value: detail.salaryRange,
                  bold: true),
            if (detail.workplace.isNotEmpty)
              JobDetailCell(
                  label: l.workplaceLabel,
                  icon: 'profile',
                  value: detail.workplace),
            if (detail.experienceLevel.isNotEmpty)
              JobDetailCell(
                label: l.experienceLevelLabel,
                icon: 'assessment',
                value: detail.experienceLevel,
              ),
            if (detail.languages.isNotEmpty)
              JobDetailCell(
                label: l.languageLabel,
                icon: 'globe',
                value: detail.languages,
                wide: true,
              ),
          ]),
        ],

        // Skills
        if (detail.skills.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            l.skillsRequired,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.softGraphite,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: detail.skills.map((s) => JobDetailSkillChip(s)).toList(),
          ),
        ],

        // About the role
        if (detail.description.isNotEmpty) ...[
          const SizedBox(height: 24),
          JobTextSection(title: l.aboutRoleTitle, body: detail.description),
        ],

        // Responsibilities (communication field)
        if (detail.communication.isNotEmpty) ...[
          const SizedBox(height: 26),
          JobBulletSection(
            title: l.responsibilitiesTitle,
            items: splitJobBullets(detail.communication),
          ),
        ],

        // Requirements
        if (detail.requirements.isNotEmpty) ...[
          const SizedBox(height: 24),
          JobBulletSection(
              title: l.requirementsTitle, items: detail.requirements),
        ],

        // Nice to have
        if (detail.niceToHave.isNotEmpty) ...[
          const SizedBox(height: 14),
          JobDetailSection(title: l.niceToHaveTitle, body: detail.niceToHave),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
        ],

        // We offer
        if (detail.whatWeOffer.isNotEmpty) ...[
          const SizedBox(height: 14),
          JobDetailSection(title: l.weOfferTitle, body: detail.whatWeOffer),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
        ],

        // Share + Not Interested / Job Removed
        const SizedBox(height: 14),
        if (isNotInterested)
          Row(children: [
            Expanded(
              child: IthakiButton(l.shareJob,
                  variant: IthakiButtonVariant.outline, onPressed: onShare),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton(l.jobPostRemoved,
                  variant: IthakiButtonVariant.outline, onPressed: null),
            ),
          ])
        else
          Row(children: [
            Expanded(
              child: IthakiButton(l.shareJob,
                  variant: IthakiButtonVariant.outline, onPressed: onShare),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton(l.notInterested,
                  variant: IthakiButtonVariant.outline,
                  onPressed: onNotInterested),
            ),
          ]),

        // Reminder info
        if (hasReminder) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              const IthakiIcon('calendar',
                  size: 18, color: IthakiTheme.primaryPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(l.reminderSetNotification,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      color: IthakiTheme.textPrimary,
                    )),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          IthakiButton(l.deleteReminder,
              variant: IthakiButtonVariant.outline,
              onPressed: onDeleteReminder),
        ],
      ]),
    );
  }

  bool _hasAnyDetail(JobDetail d) =>
      d.location.isNotEmpty ||
      d.jobType.isNotEmpty ||
      d.company.industry.isNotEmpty ||
      d.salaryRange.isNotEmpty ||
      d.workplace.isNotEmpty ||
      d.experienceLevel.isNotEmpty ||
      d.languages.isNotEmpty;
}

// ─── Odyssea review card ──────────────────────────────────────────────────────

class OdysseaReviewCard extends StatelessWidget {
  final String rating;
  final List<String> points;
  const OdysseaReviewCard(
      {super.key, required this.rating, required this.points});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(l.odysseaReviewLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              )),
          if (rating.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5C0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(rating,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B6B00),
                    )),
                const SizedBox(width: 4),
                const Text('✦',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B6B00))),
              ]),
            ),
        ]),
        if (points.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...points.map((p) => JobDetailBullet(p)),
        ],
      ]),
    );
  }
}

// ─── Recommended section ──────────────────────────────────────────────────────

class RecommendedJobsSection extends StatelessWidget {
  final List<RecommendedJob> jobs;
  const RecommendedJobsSection({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.recommendedForYouLabel,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            )),
        ...jobs.map((job) => Padding(
              padding: const EdgeInsets.only(top: 14),
              child: RecommendedJobTile(job: job),
            )),
      ]),
    );
  }
}

class RecommendedJobTile extends StatelessWidget {
  final RecommendedJob job;
  const RecommendedJobTile({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: job.companyColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          alignment: Alignment.center,
          child: Text(job.companyInitials,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: job.companyColor,
              )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(job.jobTitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                )),
            Text(job.companyName,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
          ]),
        ),
      ]),
      const SizedBox(height: 10),
      Text(job.salary,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          )),
      const SizedBox(height: 6),
      Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: getMatchBgColor(job.matchLabel),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(job.matchLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              )),
        ),
        const SizedBox(width: 8),
        IthakiIcon('location', size: 15, color: IthakiTheme.softGraphite),
        const SizedBox(width: 4),
        Text(job.location,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.softGraphite)),
        const SizedBox(width: 8),
        IthakiIcon('clock', size: 15, color: IthakiTheme.softGraphite),
        const SizedBox(width: 4),
        Text(job.employmentType,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.softGraphite)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: IthakiButton(l.saveJob,
              variant: IthakiButtonVariant.outline,
              onPressed: () => context.go(Routes.jobSearch)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: IthakiButton(
            l.viewJob,
            onPressed: () => context.go(Routes.jobSearch),
          ),
        ),
      ]),
    ]);
  }
}

// ─── Company card ─────────────────────────────────────────────────────────────

class JobDetailCompanyCard extends StatelessWidget {
  final JobDetailCompany company;
  const JobDetailCompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.aboutCompanyTitle,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            )),
        const SizedBox(height: 12),
        Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: company.logoColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            alignment: Alignment.center,
            child: Text(company.logoInitials,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: company.logoColor,
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(company.name,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                  )),
              Text(company.industry,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  )),
            ]),
          ),
        ]),
        if (company.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
              )),
        ],
        const SizedBox(height: 12),
        IthakiButton(l.companyProfile,
            variant: IthakiButtonVariant.outline,
            onPressed: company.id.isNotEmpty
                ? () => context.push(Routes.companyProfileFor(company.id))
                : null),
      ]),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class JobDetailCell extends StatelessWidget {
  final String label;
  final String? icon;
  final String value;
  final bool bold;
  final bool wide;
  const JobDetailCell({
    super.key,
    required this.label,
    this.icon,
    required this.value,
    this.bold = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 155,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.softGraphite,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 5),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (icon != null) ...[
            IthakiIcon(icon!, size: 16, color: IthakiTheme.softGraphite),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: bold ? 17 : 14,
                height: 1.35,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

class JobDetailSkillChip extends StatelessWidget {
  final String label;
  const JobDetailSkillChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text(
          '✓',
          style: TextStyle(
            fontSize: 11,
            color: IthakiTheme.softGraphite,
            height: 1,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            height: 1.1,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }
}

class JobDetailSectionTitle extends StatelessWidget {
  final String text;
  const JobDetailSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: IthakiTheme.textPrimary,
        ));
  }
}

class JobDetailSection extends StatelessWidget {
  final String title;
  final String body;
  const JobDetailSection({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      JobDetailSectionTitle(title),
      const SizedBox(height: 8),
      Text(body,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.textPrimary,
            height: 1.5,
          )),
    ]);
  }
}

class JobTextSection extends StatelessWidget {
  final String title;
  final String body;
  const JobTextSection({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: jobSectionTitleStyle),
      const SizedBox(height: 7),
      Text(body, style: jobSectionBodyStyle),
    ]);
  }
}

class JobBulletSection extends StatelessWidget {
  final String title;
  final List<String> items;
  const JobBulletSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: jobSectionTitleStyle),
      const SizedBox(height: 9),
      ...items.where((item) => item.trim().isNotEmpty).map(JobBullet.new),
    ]);
  }
}

class JobBullet extends StatelessWidget {
  final String text;
  const JobBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7, right: 8),
          decoration: const BoxDecoration(
            color: IthakiTheme.borderLight,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: Text(text, style: jobSectionBodyStyle)),
      ]),
    );
  }
}

class JobDetailBullet extends StatelessWidget {
  final String text;
  const JobDetailBullet(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('• ',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary)),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
              )),
        ),
      ]),
    );
  }
}

List<String> splitJobBullets(String value) {
  final lines = value
      .split(RegExp(r'\r?\n|•|- '))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  return lines.length > 1 ? lines : [value.trim()];
}

const jobSectionTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: IthakiTheme.textPrimary,
);

const jobSectionBodyStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  height: 1.48,
  color: IthakiTheme.textPrimary,
);
