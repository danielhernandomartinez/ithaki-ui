import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/application_detail_models.dart';
import '../../../routes.dart';
import '../../../utils/match_colors.dart';

// ─── Status card ──────────────────────────────────────────────────────────────

class ApplicationStatusCard extends StatelessWidget {
  final ApplicationDetail detail;
  const ApplicationStatusCard({super.key, required this.detail});

  static Color badgeColor(String label) {
    switch (label) {
      case 'Submitted':
        return const Color(0xFFE9DEFF);
      case 'Viewed':
        return const Color(0xFFE9E9E9);
      case 'Interview':
        return const Color(0xFFD8E5F9);
      case 'Offer':
        return const Color(0xFFD6F5D0);
      case 'Rejected':
        return const Color(0xFFFFE0E0);
      default:
        return const Color(0xFFE9E9E9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  detail.appliedAt,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor(detail.statusLabel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  detail.statusLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail.appliedWithNote,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Job post basics card ─────────────────────────────────────────────────────

class JobPostBasicsCard extends StatelessWidget {
  final ApplicationDetail detail;
  const JobPostBasicsCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detail.postedDate,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: Color(0xFF4B4B4B),
                letterSpacing: -0.28,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              _CompanyLogo(
                  color: detail.companyLogoColor,
                  initials: detail.companyLogoInitials,
                  size: 60),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.48,
                        )),
                    Text(detail.companyName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IthakiMatchBar(
            percentage: detail.matchPercentage,
            label: detail.matchLabel,
            gradientColors: getMatchGradientColors(detail.matchLabel),
            backgroundColor: getMatchBgColor(detail.matchLabel),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _DetailCell(
                  label: 'Location', icon: 'location', value: detail.location),
              _DetailCell(
                  label: 'Job Type', icon: 'clock', value: detail.jobType),
              _DetailCell(label: 'Industry', value: detail.industry),
              _DetailCell(
                  label: 'Salary Range',
                  value: detail.salaryRange,
                  valueSemibold: true),
              _DetailCell(
                  label: 'Workplace',
                  icon: 'company-profile',
                  value: detail.workplace),
              _DetailCell(
                  label: 'Experience Level',
                  icon: 'level',
                  value: detail.experienceLevel),
              _DetailCell(
                  label: 'Language',
                  icon: 'globe',
                  value: detail.languages,
                  wide: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String? icon;
  final String value;
  final bool valueSemibold;
  final bool wide;

  const _DetailCell({
    required this.label,
    this.icon,
    required this.value,
    this.valueSemibold = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: Color(0xFF4B4B4B),
                letterSpacing: -0.28,
              )),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IthakiIcon(icon!, size: 20, color: IthakiTheme.textPrimary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(value,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: valueSemibold ? 20 : 16,
                      fontWeight:
                          valueSemibold ? FontWeight.w600 : FontWeight.w400,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: valueSemibold ? -0.4 : -0.32,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Talent profile card ──────────────────────────────────────────────────────

class TalentProfileCard extends StatelessWidget {
  final CandidateProfile candidate;
  const TalentProfileCard({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: IthakiTheme.badgeLime,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  candidate.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(candidate.name,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(candidate.title,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B4B4B),
                          letterSpacing: -0.28,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD8E5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(candidate.availabilityLabel,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.32,
                )),
          ),
          const SizedBox(height: 12),
          _ContactRow(icon: 'envelope', value: candidate.email),
          const SizedBox(height: 8),
          _ContactRow(icon: 'phone', value: candidate.phone),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 12, children: [
            _InfoCell(label: 'Gender', value: candidate.gender),
            _InfoCell(label: 'Age', value: candidate.age),
            _InfoCell(label: 'Citizenship', value: candidate.citizenship),
            _InfoCell(label: 'Location', value: candidate.location),
          ]),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 12, children: [
            _IconInfoCell(
                icon: 'company-profile', value: candidate.workplacePreference),
            _IconInfoCell(icon: 'clock', value: candidate.employmentPreference),
            _IconInfoCell(icon: 'level', value: candidate.experienceLevel),
            _IconInfoCell(
                icon: 'bank-note',
                value: candidate.salaryExpectation,
                semibold: true),
          ]),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push(Routes.profile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Show full CV',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.32,
                    )),
                Container(height: 1, color: IthakiTheme.textPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String icon;
  final String value;
  const _ContactRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
        const SizedBox(width: 4),
        Text(value,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.32,
            )),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: Color(0xFF4B4B4B),
                letterSpacing: -0.28,
              )),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.32,
              )),
        ],
      ),
    );
  }
}

class _IconInfoCell extends StatelessWidget {
  final String icon;
  final String value;
  final bool semibold;
  const _IconInfoCell(
      {required this.icon, required this.value, this.semibold = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(value,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: semibold ? FontWeight.w600 : FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.32,
                )),
          ),
        ],
      ),
    );
  }
}

// ─── Cover letter card ────────────────────────────────────────────────────────

class CoverLetterCard extends StatelessWidget {
  final String text;
  const CoverLetterCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cover Letter',
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 12),
          Text(text,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              )),
        ],
      ),
    );
  }
}

// ─── Screening questions card ─────────────────────────────────────────────────

class ScreeningQuestionsCard extends StatelessWidget {
  final List<ScreeningQuestion> questions;
  const ScreeningQuestionsCard({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Screening Questions',
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 4),
          const Text(
              'Here are your answers to a few questions from the employer',
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              )),
          const SizedBox(height: 20),
          ...questions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _QaItem(question: q),
              )),
        ],
      ),
    );
  }
}

class _QaItem extends StatelessWidget {
  final ScreeningQuestion question;
  const _QaItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.36,
            )),
        const SizedBox(height: 12),
        Text(question.answer,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            )),
      ],
    );
  }
}

// ─── Company card ─────────────────────────────────────────────────────────────

class ApplicationDetailCompanyCard extends StatelessWidget {
  final CompanyInfo company;
  const ApplicationDetailCompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About the Company',
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              _CompanyLogo(
                  color: company.logoColor,
                  initials: company.logoInitials,
                  size: 64),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(company.industry,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 14,
                          color: IthakiTheme.softGraphite,
                          letterSpacing: -0.28,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          const Text('Team',
              style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: Color(0xFF4B4B4B))),
          const SizedBox(height: 2),
          Row(children: [
            IthakiIcon('team', size: 20, color: IthakiTheme.textPrimary),
            const SizedBox(width: 4),
            Text(company.teamSize,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.32,
                )),
          ]),
          const SizedBox(height: 8),
          const Text('Location',
              style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: Color(0xFF4B4B4B))),
          const SizedBox(height: 2),
          Row(children: [
            IthakiIcon('location', size: 20, color: IthakiTheme.textPrimary),
            const SizedBox(width: 4),
            Text(company.location,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.32,
                )),
          ]),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              )),
          const SizedBox(height: 12),
          IthakiButton('Company Profile',
              variant: IthakiButtonVariant.outline,
              onPressed: company.id.isNotEmpty
                  ? () => context.push(Routes.companyProfileFor(company.id))
                  : null),
        ],
      ),
    );
  }
}

// ─── Sticky bottom bar ────────────────────────────────────────────────────────

class ApplicationDetailStickyBar extends StatelessWidget {
  final String applicationId;
  const ApplicationDetailStickyBar({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: IthakiTheme.borderLight.withValues(alpha: 0.9),
              ),
            ),
            child: IthakiButton(
              'To Job Details',
              onPressed: () => context.push(Routes.jobDetailFor(applicationId)),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Shared company logo ──────────────────────────────────────────────────────

class _CompanyLogo extends StatelessWidget {
  final Color color;
  final String initials;
  final double size;
  const _CompanyLogo(
      {required this.color, required this.initials, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      alignment: Alignment.center,
      child: Text(initials,
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: size * 0.3,
            fontWeight: FontWeight.w600,
            color: color,
          )),
    );
  }
}
