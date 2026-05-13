import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import 'job_detail_primitives.dart';

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
