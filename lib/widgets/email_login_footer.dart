import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class EmailLoginFooter extends StatelessWidget {
  const EmailLoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: IthakiTheme.borderLight,
          thickness: 1,
        ),

        const SizedBox(height: 24),

        const Center(
          child: Text(
            'Prefer email? You can sign in with email instead.',
            style:  IthakiTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: IthakiButton(
            'Sign in with Email',
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
