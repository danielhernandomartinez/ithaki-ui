import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../l10n/app_localizations.dart';

class PhoneLoginFooter extends StatelessWidget {
  const PhoneLoginFooter({super.key});

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
            l.preferPhone,
            style: IthakiTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: IthakiButton(
            l.signInWithPhone,
            variant: IthakiButtonVariant.outline,
            onPressed: () {
              context.pushReplacement('/login-phone');
            },
          ),
        ),
      ],
    );
  }
}
