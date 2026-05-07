import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class SwitchLiteSheet extends StatelessWidget {
  final BuildContext parentContext;
  const SwitchLiteSheet({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BottomSheetBase(
      title: l.switchToLite,
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.switchLiteDescription,
            style:
                const TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: IthakiTheme.softGraphite),
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: IthakiTheme.textPrimary,
              ),
              child: Text(l.cancel),
            ),
          ),
          const SizedBox(height: 10),
          IthakiButton(
            l.switchLiteButton,
            onPressed: () {
              Navigator.pop(context);
              SuccessBanner.show(parentContext, l.switchedToLite);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
