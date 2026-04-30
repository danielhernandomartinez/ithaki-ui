import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

class BoostJobPostSheet extends StatefulWidget {
  final JobPost jobPost;
  final VoidCallback? onConfirm;

  const BoostJobPostSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<BoostJobPostSheet> createState() => _BoostJobPostSheetState();
}

class _BoostJobPostSheetState extends State<BoostJobPostSheet> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(l10n.boostJobPostTitle, style: IthakiTheme.headingMedium),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ]),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: IthakiTheme.bodySmall,
                children: [
                  const TextSpan(text: 'Boost your job '),
                  TextSpan(
                    text: '"${widget.jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: ' to keep it at the top of search results and increase visibility to candidates.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: IthakiTheme.softGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                Text(l10n.availableCredits, style: IthakiTheme.bodySmallBold),
                const Spacer(),
                Text('50 credits', style: IthakiTheme.bodySmall),
              ]),
            ),
            const SizedBox(height: 16),
            OptionCard(
              label: l10n.weeklyBoostLabel,
              subtitle: '1 week',
              credits: 5,
              selected: _selected == 'weekly',
              onTap: () => setState(() => _selected = 'weekly'),
            ),
            const SizedBox(height: 8),
            OptionCard(
              label: l10n.fullTermBoostLabel,
              subtitle: 'Until job post expires',
              credits: 15,
              selected: _selected == 'full',
              onTap: () => setState(() => _selected = 'full'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selected != null ? () => widget.onConfirm?.call() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  disabledBackgroundColor:
                      IthakiTheme.primaryPurple.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.changeStatusButton,
                    style: IthakiTheme.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final int credits;
  final bool selected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.label,
    required this.subtitle,
    required this.credits,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          border: Border.all(
            color: selected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: IthakiTheme.bodySmallBold),
              Text(subtitle, style: IthakiTheme.captionRegular),
            ],
          ),
          const Spacer(),
          Text('$credits Credits', style: IthakiTheme.bodySmallBold),
        ]),
      ),
    );
  }
}
