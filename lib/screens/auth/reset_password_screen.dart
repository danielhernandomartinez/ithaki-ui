import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _passwordFocused = false;

  bool _hasUpperLower = false;
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
  }

  bool get _passwordValid =>
      _hasUpperLower && _hasMinLength && _hasNumber && _hasSpecial;

  bool get _passwordsMatch =>
      _confirmPasswordController.text == _passwordController.text &&
      _confirmPasswordController.text.isNotEmpty;

  bool get _canSubmit => _passwordValid && _passwordsMatch;

  void _onPasswordChanged(String value) {
    setState(() {
      _hasUpperLower =
          value.contains(RegExp(r'[A-Z]')) && value.contains(RegExp(r'[a-z]'));
      _hasMinLength = value.length >= 8;
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasSpecial = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.backToLogin,
        onActionPressed: () => context.go('/login-phone'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.resetPasswordHeading,
            style: IthakiTheme.headingLarge.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.resetPasswordDescription,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiPasswordField(
            label: l.newPasswordLabel,
            hint: l.newPasswordHint,
            controller: _passwordController,
            focusNode: _passwordFocus,
            onChanged: _onPasswordChanged,
          ),
          if (_passwordFocused || _passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            IthakiValidationRow(valid: _hasUpperLower, text: l.passwordUpperLower),
            IthakiValidationRow(valid: _hasMinLength, text: l.passwordMinLength),
            IthakiValidationRow(valid: _hasNumber, text: l.passwordNumber),
            IthakiValidationRow(valid: _hasSpecial, text: l.passwordSpecial),
          ],
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: l.confirmNewPasswordLabel,
            hint: l.confirmNewPasswordHint,
            controller: _confirmPasswordController,
            onChanged: (_) => setState(() {}),
          ),
          if (_confirmPasswordController.text.isNotEmpty && !_passwordsMatch) ...[
            const SizedBox(height: 8),
            Text(l.passwordsDoNotMatch,
                style: const TextStyle(fontSize: 13, color: Colors.red)),
          ],
          const SizedBox(height: 24),
          IthakiButton(
            l.resetPasswordButton,
            isEnabled: _canSubmit,
            onPressed: _canSubmit
                ? () {
                    // TODO: call reset password API
                    context.go('/login-phone');
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
