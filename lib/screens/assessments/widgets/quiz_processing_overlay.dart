import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class QuizProcessingOverlay extends StatelessWidget {
  const QuizProcessingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: IthakiTheme.accentPurpleLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IthakiIcon('assessment', size: 22, color: IthakiTheme.primaryPurple),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.assessmentProcessingTitle,
              style: IthakiTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.assessmentProcessingSubtitle,
              style: IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                backgroundColor: IthakiTheme.borderLight,
                color: IthakiTheme.primaryPurple,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
