import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class PhoneLoginFooter extends StatelessWidget {
  const PhoneLoginFooter({super.key});

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
            'Prefer phone? You can sign in with phone instead.',
            style: IthakiTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: IthakiButton(
            'Sign in with Phone',
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
