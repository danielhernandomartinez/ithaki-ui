import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Footer shown on login screens to offer switching to the other login method.
class LoginMethodFooter extends StatelessWidget {
  final String promptText;
  final String buttonLabel;
  final String route;

  const LoginMethodFooter({
    super.key,
    required this.promptText,
    required this.buttonLabel,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: IthakiTheme.borderLight,
          thickness: 1,
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            promptText,
            style: IthakiTheme.bodyRegular,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: IthakiButton(
            buttonLabel,
            variant: IthakiButtonVariant.outline,
            onPressed: () => context.pushReplacement(route),
          ),
        ),
      ],
    );
  }
}
