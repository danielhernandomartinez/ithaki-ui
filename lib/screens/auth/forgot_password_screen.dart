import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  bool get _emailValid {
    final email = _emailController.text;
    return email.contains('@') && email.contains('.');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.backToLogin,
        onActionPressed: () => context.pop(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.forgotPasswordHeading,
            style: IthakiTheme.headingLarge.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.forgotPasswordDescription,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiTextField(
            label: l.emailLabel,
            hint: l.emailHint,
            controller: _emailController,
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: IthakiIcon('envelope', size: 18, color: IthakiTheme.softGraphite),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          IthakiButton(
            l.sendResetLink,
            isEnabled: _emailValid,
            onPressed: _emailValid
                ? () => context.push('/reset-link-sent')
                : null,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
