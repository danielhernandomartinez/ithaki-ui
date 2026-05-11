import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';

class ContinueAssessmentSheet extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onContinue;
  final VoidCallback onStartOver;

  const ContinueAssessmentSheet({
    super.key,
    required this.assessment,
    required this.onContinue,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.assessmentContinueTitle,
                  style: IthakiTheme.headingMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close',
                    size: 22, color: IthakiTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.assessmentContinueSubtitle,
            style:
                IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: IthakiOutlineButton(l.assessmentStartOver,
                    onPressed: onStartOver),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: IthakiButton(l.continueButton, onPressed: onContinue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
