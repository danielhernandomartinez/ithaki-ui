import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/application_detail_models.dart';
import '../../providers/application_detail_provider.dart';
import '../../utils/match_colors.dart';

class ApplicationDetailsScreen extends ConsumerWidget {
  final String applicationId;

  const ApplicationDetailsScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(applicationDetailProvider(applicationId));

    if (detail == null) {
      return const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: _DetailAppBar(onBack: () => context.pop()),
      bottomNavigationBar: _StickyBottomBar(
        onTap: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
            ),

            // ── Application status ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ApplicationStatusCard(detail: detail),
            ),
            const SizedBox(height: 8),

            // ── Job post basics ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _JobPostBasicsCard(detail: detail),
            ),
            const SizedBox(height: 8),

            // ── Candidate profile ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _TalentProfileCard(candidate: detail.candidate),
            ),
            const SizedBox(height: 8),

            // ── Cover letter ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CoverLetterCard(text: detail.coverLetter),
            ),
            const SizedBox(height: 8),

            // ── Screening questions ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ScreeningQuestionsCard(
                questions: detail.screeningQuestions,
              ),
            ),
            const SizedBox(height: 8),

            // ── Company ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CompanyCard(company: detail.company),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const _DetailAppBar({required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        margin: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 16,
          right: 16,
        ),
        height: 52,
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E1E1E).withValues(alpha:0.06),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            // Back
            GestureDetector(
              onTap: onBack,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  IthakiIcon('back-chevron', size: 20,
                      color: IthakiTheme.textPrimary),
                  const SizedBox(width: 4),
                  const Text(
                    'Back',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.textPrimary,
                      height: 1.4,
                      letterSpacing: -0.32,
                    ),
                  ),
                ],
              ),
            ),
            // Logo centered
            const Expanded(
              child: Center(
                child: Text(
                  'Ithaki',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                    height: 1.43,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),
            // Right actions
            IthakiIcon('notifications bell', size: 24,
                color: IthakiTheme.textPrimary),
            const SizedBox(width: 16),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: IthakiTheme.badgeLime,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'CI',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Application status card ──────────────────────────────────────────────────

class _ApplicationStatusCard extends StatelessWidget {
  final ApplicationDetail detail;
  const _ApplicationStatusCard({required this.detail});

  static Color _badgeColor(String label) {
    switch (label) {
      case 'Submitted':
        return const Color(0xFFE9DEFF); // purple
      case 'Viewed':
        return const Color(0xFFE9E9E9); // neutral grey
      case 'Interview':
        return const Color(0xFFD8E5F9); // blue
      case 'Offer':
        return const Color(0xFFD6F5D0); // green
      case 'Rejected':
        return const Color(0xFFFFE0E0); // red
      default:
        return const Color(0xFFE9E9E9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2).withValues(alpha:0.7),
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
                    height: 1.5,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeColor(detail.statusLabel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  detail.statusLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: IthakiTheme.textPrimary,
                    height: 1.5,
                    letterSpacing: -0.32,
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
              height: 1.4,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Job post basics card ─────────────────────────────────────────────────────

class _JobPostBasicsCard extends StatelessWidget {
  final ApplicationDetail detail;
  const _JobPostBasicsCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final matchBg = getMatchBgColor(detail.matchLabel);

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted date
          Text(
            detail.postedDate,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B4B4B),
              height: 1.4,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 12),

          // Company + title
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: detail.companyLogoColor.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(
                  detail.companyLogoInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: detail.companyLogoColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.jobTitle,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                        height: 1.5,
                        letterSpacing: -0.48,
                      ),
                    ),
                    Text(
                      detail.companyName,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: IthakiTheme.textPrimary,
                        height: 1.5,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Match badge
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: matchBg,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${detail.matchPercentage}%',
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  detail.matchLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    height: 1.5,
                    letterSpacing: -0.32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Details grid
          Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _JobDetailCell(
                  label: 'Location',
                  icon: 'location',
                  value: detail.location),
              _JobDetailCell(
                  label: 'Job Type', icon: 'clock', value: detail.jobType),
              _JobDetailCell(
                  label: 'Industry', value: detail.industry),
              _JobDetailCell(
                  label: 'Salary Range', value: detail.salaryRange,
                  valueSemibold: true),
              _JobDetailCell(
                  label: 'Workplace',
                  icon: 'company-profile',
                  value: detail.workplace),
              _JobDetailCell(
                  label: 'Experience Level',
                  icon: 'level',
                  value: detail.experienceLevel),
              _JobDetailCell(
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

class _JobDetailCell extends StatelessWidget {
  final String label;
  final String? icon;
  final String value;
  final bool valueSemibold;
  final bool wide;

  const _JobDetailCell({
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
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B4B4B),
              height: 1.4,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IthakiIcon(icon!, size: 20, color: IthakiTheme.textPrimary),
                const SizedBox(width: 4),
              ],
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: valueSemibold ? 20 : 16,
                  fontWeight: valueSemibold
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                  height: 1.5,
                  letterSpacing: valueSemibold ? -0.4 : -0.32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Talent profile card ──────────────────────────────────────────────────────

class _TalentProfileCard extends StatelessWidget {
  final CandidateProfile candidate;
  const _TalentProfileCard({required this.candidate});

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
          // Photo + name
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: IthakiTheme.badgeLime,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  candidate.name
                      .split(' ')
                      .map((e) => e[0])
                      .take(2)
                      .join(),
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
                    Text(
                      candidate.name,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                        height: 1.5,
                        letterSpacing: -0.32,
                      ),
                    ),
                    Text(
                      candidate.title,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B4B4B),
                        height: 1.4,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Availability badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD8E5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              candidate.availabilityLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Contact
          _ContactRow(icon: 'email', value: candidate.email),
          const SizedBox(height: 8),
          _ContactRow(icon: 'phone', value: candidate.phone),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Personal info grid
          Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _InfoCell(label: 'Gender', value: candidate.gender),
              _InfoCell(label: 'Age', value: candidate.age),
              _InfoCell(label: 'Citizenship', value: candidate.citizenship),
              _InfoCell(label: 'Location', value: candidate.location),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Work preferences grid
          Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _IconInfoCell(
                icon: 'company-profile',
                value: candidate.workplacePreference,
              ),
              _IconInfoCell(
                icon: 'clock',
                value: candidate.employmentPreference,
              ),
              _IconInfoCell(
                icon: 'level',
                value: candidate.experienceLevel,
              ),
              _IconInfoCell(
                icon: 'bank-note',
                value: candidate.salaryExpectation,
                semibold: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Show full CV link
          _TextLink(label: 'Show full CV', onTap: () {}),
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
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.32,
          ),
        ),
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
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B4B4B),
              height: 1.4,
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            ),
          ),
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
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight:
                    semibold ? FontWeight.w600 : FontWeight.w400,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _TextLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            ),
          ),
          Container(height: 1, color: IthakiTheme.textPrimary),
        ],
      ),
    );
  }
}

// ─── Cover letter card ────────────────────────────────────────────────────────

class _CoverLetterCard extends StatelessWidget {
  final String text;
  const _CoverLetterCard({required this.text});

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
          const Text(
            'Cover Letter',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textPrimary,
              height: 1.45,
              letterSpacing: -0.36,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Screening questions card ─────────────────────────────────────────────────

class _ScreeningQuestionsCard extends StatelessWidget {
  final List<ScreeningQuestion> questions;
  const _ScreeningQuestionsCard({required this.questions});

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
          const Text(
            'Screening Questions',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textPrimary,
              height: 1.45,
              letterSpacing: -0.36,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Here are your answers to a few questions from the employer',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            ),
          ),
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
        Text(
          question.question,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: IthakiTheme.textPrimary,
            height: 1.45,
            letterSpacing: -0.36,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          question.answer,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.32,
          ),
        ),
      ],
    );
  }
}

// ─── Company card ─────────────────────────────────────────────────────────────

class _CompanyCard extends StatelessWidget {
  final CompanyInfo company;
  const _CompanyCard({required this.company});

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
          const Text(
            'About the Company',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textPrimary,
              height: 1.45,
              letterSpacing: -0.36,
            ),
          ),
          const SizedBox(height: 12),

          // Company name row
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: company.logoColor.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(
                  company.logoInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: company.logoColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                        height: 1.5,
                        letterSpacing: -0.32,
                      ),
                    ),
                    Text(
                      company.industry,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: IthakiTheme.softGraphite,
                        height: 1.4,
                        letterSpacing: -0.28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Team
          const Text(
            'Team',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B4B4B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              IthakiIcon('team', size: 20, color: IthakiTheme.textPrimary),
              const SizedBox(width: 4),
              Text(
                company.teamSize,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                  height: 1.5,
                  letterSpacing: -0.32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Location
          const Text(
            'Location',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B4B4B),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              IthakiIcon('location', size: 20,
                  color: IthakiTheme.textPrimary),
              const SizedBox(width: 4),
              Text(
                company.location,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                  height: 1.5,
                  letterSpacing: -0.32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Description
          Text(
            company.description,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 12),

          // Company profile button
          IthakiOutlineButton(
            'Company Profile',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ─── Sticky bottom bar ────────────────────────────────────────────────────────

class _StickyBottomBar extends StatelessWidget {
  final VoidCallback onTap;
  const _StickyBottomBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E1E).withValues(alpha:0.15),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: IthakiButton(
        'To Job Details',
        onPressed: onTap,
      ),
    );
  }
}
