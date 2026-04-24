import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../models/profile_models.dart';

/// Renders a single WorkExperience entry.
///
/// [compact] — true for the list/edit screen (grey bg, radius 16, no outer margin).
///             false for the profile tab (white card, radius 20, with outer margin).
class WorkExperienceCard extends StatelessWidget {
  final WorkExperience exp;
  final int index;
  final VoidCallback onEditTap;
  final bool compact;

  const WorkExperienceCard({
    super.key,
    required this.exp,
    required this.index,
    required this.onEditTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final duration = exp.duration;
    final endLabel = exp.currentlyWorkHere ? 'Present' : (exp.endDate ?? '');

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row ──────────────────────────────────────
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary),
                children: [
                  TextSpan(text: exp.jobTitle),
                  const TextSpan(
                      text: '  at  ',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: IthakiTheme.textSecondary)),
                  TextSpan(text: exp.companyName),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: compact ? IthakiTheme.backgroundWhite : null,
                border: Border.all(color: IthakiTheme.borderLight),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const IthakiIcon('edit-pencil',
                  size: 16, color: IthakiTheme.textSecondary),
            ),
          ),
        ]),
        SizedBox(height: compact ? 4 : 6),
        // ── Date + duration ──────────────────────────────────
        Text(
          '${exp.startDate} – $endLabel${duration.isNotEmpty ? ' ($duration)' : ''}',
          style:
              const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 10),
        const Divider(height: 1, color: IthakiTheme.placeholderBg),
        const SizedBox(height: 10),
        // ── Metadata grid ────────────────────────────────────
        Row(children: [
          if (exp.location.isNotEmpty)
            Expanded(
                child: IthakiMetaCell('location', exp.location,
                    flexible: true, fontSize: 13)),
          if (exp.workplace.isNotEmpty)
            Expanded(
                child: IthakiMetaCell('company-profile', exp.workplace,
                    flexible: true, fontSize: 13)),
        ]),
        if (exp.jobType.isNotEmpty || exp.experienceLevel.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(children: [
            if (exp.jobType.isNotEmpty)
              Expanded(
                  child: IthakiMetaCell('clock', exp.jobType,
                      flexible: true, fontSize: 13)),
            if (exp.experienceLevel.isNotEmpty)
              Expanded(
                  child: IthakiMetaCell('level', exp.experienceLevel,
                      flexible: true, fontSize: 13)),
          ]),
        ],
        // ── Summary ──────────────────────────────────────────
        if (exp.summary != null && exp.summary!.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Divider(height: 1, color: IthakiTheme.placeholderBg),
          const SizedBox(height: 10),
          Text(exp.summary!,
              style: const TextStyle(
                  fontSize: 13, color: IthakiTheme.textPrimary, height: 1.5)),
        ],
      ],
    );

    if (compact) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: content,
      );
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }
}
