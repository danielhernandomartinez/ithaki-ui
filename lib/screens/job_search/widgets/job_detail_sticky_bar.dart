import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class JobDetailStickyBar extends StatelessWidget {
  final bool isSaved;
  final bool isClosed;
  final VoidCallback onApply;
  final VoidCallback onSave;

  const JobDetailStickyBar({
    super.key,
    required this.isSaved,
    required this.isClosed,
    required this.onApply,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: IthakiTheme.borderLight.withValues(alpha: 0.9),
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              IthakiButton(
                isClosed ? l.jobClosedButton : l.applyNow,
                onPressed: isClosed ? null : onApply,
              ),
              const SizedBox(height: 8),
              IthakiButton(
                isSaved ? l.removeFromSaved : l.saveJob,
                variant: IthakiButtonVariant.outline,
                onPressed: onSave,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
