import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/job_detail_models.dart';
import 'match_bar.dart';

// ─── Status card ──────────────────────────────────────────────────────────────

class JobStatusCard extends StatelessWidget {
  final JobDetail detail;
  const JobStatusCard({super.key, required this.detail});

  static Color _badgeColor(String label) {
    switch (label) {
      case 'Submitted':  return const Color(0xFFE9DEFF);
      case 'Viewed':     return const Color(0xFFE9E9E9);
      case 'Interview':  return const Color(0xFFD8E5F9);
      case 'Offer':      return const Color(0xFFD6F5D0);
      case 'Rejected':   return const Color(0xFFFFE0E0);
      default:           return const Color(0xFFE9E9E9);
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
                child: Text(detail.appliedAt,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 16,
                      fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                      letterSpacing: -0.32,
                    )),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeColor(detail.statusLabel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(detail.statusLabel,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 14,
                      color: IthakiTheme.textPrimary,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(detail.deadline,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 14,
                color: IthakiTheme.softGraphite, letterSpacing: -0.28,
              )),
        ],
      ),
    );
  }
}

// ─── Main job card (description, requirements, skills, etc.) ─────────────────

class JobMainCard extends StatelessWidget {
  final JobDetail detail;
  final Widget? trailingAction;
  const JobMainCard({super.key, required this.detail, this.trailingAction});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(detail.postedDate,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 14,
                    color: Color(0xFF4B4B4B), letterSpacing: -0.28,
                  )),
              if (trailingAction != null) trailingAction!,
            ],
          ),
          const SizedBox(height: 12),
          _JobHeader(detail: detail),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 12, children: [
            _DetailCell(icon: 'location', value: detail.location),
            _DetailCell(icon: 'clock', value: detail.jobType),
            _DetailCell(value: detail.salaryRange, semibold: true),
            _DetailCell(icon: 'company-profile', value: detail.workplace),
            _DetailCell(icon: 'level', value: detail.experienceLevel),
            _DetailCell(icon: 'globe', value: detail.languages, wide: true),
          ]),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          MatchBar(percentage: detail.matchPercentage, label: detail.matchLabel),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          const Text('Curious why you match this job?',
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 16,
                fontWeight: FontWeight.w500, color: IthakiTheme.textPrimary,
                letterSpacing: -0.32,
              )),
          const SizedBox(height: 8),
          IthakiButton('Ask Career Assistant',
              variant: IthakiButtonVariant.outline, onPressed: () {}),
          const _Divider(),
          _SectionContent(title: 'About the role', body: detail.description),
          const _Divider(),
          _SectionTitle('Requirements'),
          const SizedBox(height: 8),
          ...detail.requirements.map((r) => _BulletItem(text: r)),
          const _Divider(),
          _SectionTitle('Skills'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: detail.skills.map((s) => _SkillChip(label: s)).toList(),
          ),
          const _Divider(),
          _SectionContent(title: 'Communication', body: detail.communication),
          const _Divider(),
          _SectionContent(title: 'Nice to have', body: detail.niceToHave),
          const _Divider(),
          _SectionContent(title: 'What we offer', body: detail.whatWeOffer),
        ],
      ),
    );
  }
}

class _JobHeader extends StatelessWidget {
  final JobDetail detail;
  const _JobHeader({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: detail.companyLogoColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          alignment: Alignment.center,
          child: Text(detail.companyLogoInitials,
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 18,
                fontWeight: FontWeight.w600, color: detail.companyLogoColor,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detail.jobTitle,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 22,
                    fontWeight: FontWeight.w700, color: IthakiTheme.textPrimary,
                    letterSpacing: -0.44,
                  )),
              Text(detail.companyName,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 16,
                    color: IthakiTheme.softGraphite, letterSpacing: -0.32,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String? icon;
  final String value;
  final bool semibold;
  final bool wide;

  const _DetailCell({this.icon, required this.value, this.semibold = false, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 160,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IthakiIcon(icon!, size: 18, color: IthakiTheme.softGraphite),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(value,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: semibold ? 18 : 15,
                  fontWeight: semibold ? FontWeight.w600 : FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: semibold ? -0.36 : -0.3,
                )),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          fontFamily: 'Noto Sans', fontSize: 18,
          fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
          letterSpacing: -0.36,
        ));
  }
}

class _SectionContent extends StatelessWidget {
  final String title;
  final String body;
  const _SectionContent({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        const SizedBox(height: 8),
        Text(body,
            style: const TextStyle(
              fontFamily: 'Noto Sans', fontSize: 15,
              color: IthakiTheme.textPrimary,
              height: 1.5, letterSpacing: -0.3,
            )),
      ],
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 15, color: IthakiTheme.textPrimary)),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 15,
                  color: IthakiTheme.textPrimary,
                  height: 1.5, letterSpacing: -0.3,
                )),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: IthakiTheme.chipActive,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: const TextStyle(
            fontFamily: 'Noto Sans', fontSize: 14,
            color: IthakiTheme.textPrimary,
          )),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      SizedBox(height: 16),
      Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
      SizedBox(height: 16),
    ]);
  }
}

// ─── Reviews card ─────────────────────────────────────────────────────────────

class ReviewsCard extends StatelessWidget {
  final JobDetail detail;
  const ReviewsCard({super.key, required this.detail});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Employee Reviews',
                  style: TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 18,
                    fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                    letterSpacing: -0.36,
                  )),
              Text(detail.company.totalReviews,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(detail.company.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 32,
                    fontWeight: FontWeight.w700, color: IthakiTheme.textPrimary,
                  )),
              const SizedBox(width: 8),
              StarRow(rating: detail.company.averageRating),
            ],
          ),
          const SizedBox(height: 12),
          ...detail.reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ReviewItem(review: r),
              )),
        ],
      ),
    );
  }
}

class StarRow extends StatelessWidget {
  final double rating;
  const StarRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        return IthakiIcon(
          filled ? 'star-filled' : 'star',
          size: 18,
          color: filled ? const Color(0xFFFFB800) : IthakiTheme.borderLight,
        );
      }),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final JobReview review;
  const ReviewItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: review.authorColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(review.authorInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 13,
                      fontWeight: FontWeight.w600, color: review.authorColor,
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.authorName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans', fontSize: 14,
                          fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                        )),
                    Text(review.authorRole,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans', fontSize: 12,
                          color: IthakiTheme.softGraphite,
                        )),
                  ],
                ),
              ),
              StarRow(rating: review.rating),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.text,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 14,
                color: IthakiTheme.textPrimary, height: 1.5,
              )),
        ],
      ),
    );
  }
}

// ─── Recommended card ─────────────────────────────────────────────────────────

class RecommendedCard extends StatelessWidget {
  final RecommendedJob job;
  const RecommendedCard({super.key, required this.job});

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
          const Text('Recommended for you',
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 18,
                fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: job.companyColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(job.companyInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 16,
                      fontWeight: FontWeight.w600, color: job.companyColor,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans', fontSize: 16,
                          fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(job.companyName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans', fontSize: 13,
                          color: IthakiTheme.softGraphite,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(job.salary,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 18,
                fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 8),
          MatchBar(percentage: job.matchPercentage, label: job.matchLabel),
          const SizedBox(height: 8),
          Row(
            children: [
              IthakiIcon('location', size: 16, color: IthakiTheme.softGraphite),
              const SizedBox(width: 4),
              Text(job.location,
                  style: const TextStyle(fontFamily: 'Noto Sans', fontSize: 14, color: IthakiTheme.softGraphite)),
              const SizedBox(width: 12),
              IthakiIcon('clock', size: 16, color: IthakiTheme.softGraphite),
              const SizedBox(width: 4),
              Text(job.employmentType,
                  style: const TextStyle(fontFamily: 'Noto Sans', fontSize: 14, color: IthakiTheme.softGraphite)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: IthakiButton('Save Job',
                    variant: IthakiButtonVariant.outline, onPressed: () {}),
              ),
              const SizedBox(width: 8),
              Expanded(child: IthakiButton('View Job', onPressed: () {})),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Company card ─────────────────────────────────────────────────────────────

class JobDetailCompanyCard extends StatelessWidget {
  final JobDetailCompany company;
  const JobDetailCompanyCard({super.key, required this.company});

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
          const Text('About the Company',
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 18,
                fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: company.logoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(company.logoInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 16,
                      fontWeight: FontWeight.w600, color: company.logoColor,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans', fontSize: 16,
                          fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(company.industry,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans', fontSize: 13,
                          color: IthakiTheme.softGraphite,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 15,
                color: IthakiTheme.textPrimary,
                height: 1.5, letterSpacing: -0.3,
              )),
          const SizedBox(height: 12),
          IthakiButton('Company Profile', variant: IthakiButtonVariant.outline, onPressed: () {}),
        ],
      ),
    );
  }
}

// ─── Sticky bar ───────────────────────────────────────────────────────────────

class JobDetailStickyBar extends StatelessWidget {
  final JobDetail detail;
  const JobDetailStickyBar({super.key, required this.detail});

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
            color: const Color(0xFF1E1E1E).withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              detail.salary,
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
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: IthakiButton(
                    'Save Job',
                    variant: IthakiButtonVariant.outline,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: IthakiButton('Apply', onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
