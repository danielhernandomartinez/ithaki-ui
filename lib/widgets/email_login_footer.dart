import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../l10n/app_localizations.dart';

class EmailLoginFooter extends StatelessWidget {
  const EmailLoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      children: [
        const Divider(
          color: IthakiTheme.borderLight,
          thickness: 1,
        ),

        const SizedBox(height: 24),

        Center(
          child: Text(
            l.preferEmail,
            style: IthakiTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: IthakiButton(
            l.signInWithEmail,
            variant: IthakiButtonVariant.outline,
            onPressed: () {
              // TODO: Navigate to email login
            },
          ),
        ),
      ],
    );
  }
}
