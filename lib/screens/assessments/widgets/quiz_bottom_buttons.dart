import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class QuizBottomButtons extends StatelessWidget {
  final bool showBack;
  final bool canNext;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const QuizBottomButtons({
    super.key,
    required this.showBack,
    required this.canNext,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
                child: IthakiOutlineButton(l.backButton, onPressed: onBack)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child:
                IthakiButton(l.nextButton, onPressed: canNext ? onNext : null),
          ),
        ],
      ),
    );
  }
}
