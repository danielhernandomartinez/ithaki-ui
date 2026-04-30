import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';
import 'boost_job_post_sheet.dart' show OptionCard;

class PublishAgainSheet extends StatefulWidget {
  final JobPost jobPost;
  final VoidCallback? onConfirm;

  const PublishAgainSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<PublishAgainSheet> createState() => _PublishAgainSheetState();
}

class _PublishAgainSheetState extends State<PublishAgainSheet> {
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
              Text(l10n.publishAgainTitle, style: IthakiTheme.headingMedium),
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
                  const TextSpan(text: 'You can republish the job '),
                  TextSpan(
                    text: '"${widget.jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: ' for another month to keep it active and visible to candidates.',
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
              label: l10n.publishAgainOptionLabel,
              subtitle: 'Expires in 1 month',
              credits: 3,
              selected: _selected == 'publish',
              onTap: () => setState(() => _selected = 'publish'),
            ),
            const SizedBox(height: 8),
            OptionCard(
              label: l10n.publishAndWeeklyBoostLabel,
              subtitle: '1 week boost included',
              credits: 8,
              selected: _selected == 'weekly',
              onTap: () => setState(() => _selected = 'weekly'),
            ),
            const SizedBox(height: 8),
            OptionCard(
              label: l10n.fullTermBoostLabel,
              subtitle: 'Until job post expires',
              credits: 18,
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
