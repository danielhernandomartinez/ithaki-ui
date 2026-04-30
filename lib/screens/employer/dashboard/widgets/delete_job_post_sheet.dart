import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

class DeleteJobPostSheet extends StatelessWidget {
  final JobPost jobPost;
  final VoidCallback? onConfirm;

  const DeleteJobPostSheet({super.key, required this.jobPost, this.onConfirm});

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
              Text(l10n.deleteJobPostTitle, style: IthakiTheme.headingMedium),
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
                  const TextSpan(text: 'Are you ready to delete '),
                  TextSpan(
                    text: '"${jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: '?\n\nThis job post will be hidden and marked as Archived, but you can reactivate it later if required.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => onConfirm?.call(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
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
