import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import '../../../utils/coming_soon.dart';
import '../../../utils/localized_dates.dart';
import '../../../utils/match_colors.dart';

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
              Text(formatPostedDate(context, detail.postedDate),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    color: IthakiTheme.graphite,
                    letterSpacing: -0.28,
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
          const Divider(height: 1, thickness: 1, color: IthakiTheme.hatchBackgroundMuted),
          const SizedBox(height: 12),
          IthakiMatchBar(
            percentage: detail.matchPercentage,
            label: detail.matchLabel,
            gradientColors: getMatchGradientColors(detail.matchLabel),
            backgroundColor: getMatchBgColor(detail.matchLabel),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: IthakiTheme.hatchBackgroundMuted),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.curiousWhyMatch,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.32,
              )),
          const SizedBox(height: 8),
          IthakiButton(AppLocalizations.of(context)!.askCareerAssistant,
              variant: IthakiButtonVariant.outline,
              onPressed: () => showComingSoonSnackBar(context)),
          const _Divider(),
          Builder(builder: (ctx) {
            final l = AppLocalizations.of(ctx)!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionContent(
                    title: l.aboutRoleTitle, body: detail.description),
                const _Divider(),
                _SectionTitle(l.requirementsTitle),
                const SizedBox(height: 8),
                ...detail.requirements.map((r) => _BulletItem(text: r)),
                const _Divider(),
                _SectionTitle(l.profileSkillsTitle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      detail.skills.map((s) => _SkillChip(label: s)).toList(),
                ),
                const _Divider(),
                _SectionContent(
                    title: l.communicationHeading, body: detail.communication),
                const _Divider(),
                _SectionContent(
                    title: l.niceToHaveTitle, body: detail.niceToHave),
                const _Divider(),
                _SectionContent(
                    title: l.whatWeOfferTitle, body: detail.whatWeOffer),
              ],
            );
          }),
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: detail.companyLogoColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          alignment: Alignment.center,
          child: Text(detail.companyLogoInitials,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: detail.companyLogoColor,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detail.jobTitle,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.44,
                  )),
              Text(detail.companyName,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    color: IthakiTheme.softGraphite,
                    letterSpacing: -0.32,
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

  const _DetailCell(
      {this.icon,
      required this.value,
      this.semibold = false,
      this.wide = false});

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
          fontFamily: 'Noto Sans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: IthakiTheme.textPrimary,
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
              fontFamily: 'Noto Sans',
              fontSize: 15,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.3,
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
          const Text('• ',
              style: TextStyle(fontSize: 15, color: IthakiTheme.textPrimary)),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 15,
                  color: IthakiTheme.textPrimary,
                  height: 1.5,
                  letterSpacing: -0.3,
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
            fontFamily: 'Noto Sans',
            fontSize: 14,
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
      Divider(height: 1, thickness: 1, color: IthakiTheme.hatchBackgroundMuted),
      SizedBox(height: 16),
    ]);
  }
}
