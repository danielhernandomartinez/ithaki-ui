import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class QuizLeaveSheet extends StatelessWidget {
  final VoidCallback onLeave;
  final VoidCallback onContinue;

  const QuizLeaveSheet(
      {super.key, required this.onLeave, required this.onContinue});

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
                  l.assessmentLeaveTitle,
                  style: IthakiTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onContinue,
                child: IthakiIcon('delete',
                    size: 24, color: IthakiTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.assessmentLeaveSubtitle,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: IthakiOutlineButton(l.assessmentLeaveButton,
                    onPressed: onLeave),
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
