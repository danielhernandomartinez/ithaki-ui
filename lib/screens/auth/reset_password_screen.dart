import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.token});

  final String token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _passwordFocused = false;

  PasswordValidation _pwVal = PasswordValidation.of('');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
  }

  bool get _passwordValid => _pwVal.isValid;

  bool get _passwordsMatch =>
      _confirmPasswordController.text == _passwordController.text &&
      _confirmPasswordController.text.isNotEmpty;

  bool get _hasResetToken => widget.token.trim().isNotEmpty;

  bool get _canSubmit =>
      !_isLoading && _hasResetToken && _passwordValid && _passwordsMatch;

  void _onPasswordChanged(String value) {
    setState(() {
      _pwVal = PasswordValidation.of(value);
    });
  }

  Future<void> _resetPassword() async {
    final l = AppLocalizations.of(context)!;
    if (!_hasResetToken) {
      if (kDebugMode) debugPrint('[resetPassword] missing token');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.resetPasswordInvalidLink)),
      );
      return;
    }
    if (_isLoading) return;

    if (kDebugMode) debugPrint('[resetPassword] request started');
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            widget.token,
            _passwordController.text,
          );
      if (kDebugMode) debugPrint('[resetPassword] request succeeded');
      if (!mounted) return;
      context.go(Routes.loginPhone);
    } catch (e) {
      if (!mounted) return;
      final message =
          e is AuthException ? e.userMessage : l.resetPasswordFailed;
      if (kDebugMode) debugPrint('[resetPassword] request failed: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        onActionPressed: () => context.go(Routes.loginPhone),
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
            _hasResetToken
                ? l.resetPasswordDescription
                : l.resetPasswordInvalidLink,
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
            IthakiValidationRow(
                valid: _pwVal.hasUpperAndLower, text: l.passwordUpperLower),
            IthakiValidationRow(
                valid: _pwVal.hasMinLength, text: l.passwordMinLength),
            IthakiValidationRow(
                valid: _pwVal.hasNumber, text: l.passwordNumber),
            IthakiValidationRow(
                valid: _pwVal.hasSpecial, text: l.passwordSpecial),
          ],
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: l.confirmNewPasswordLabel,
            hint: l.confirmNewPasswordHint,
            controller: _confirmPasswordController,
            onChanged: (_) => setState(() {}),
          ),
          if (_confirmPasswordController.text.isNotEmpty &&
              !_passwordsMatch) ...[
            const SizedBox(height: 8),
            Text(l.passwordsDoNotMatch,
                style: const TextStyle(fontSize: 13, color: Colors.red)),
          ],
          const SizedBox(height: 24),
          IthakiButton(
            l.resetPasswordButton,
            isEnabled: _canSubmit,
            onPressed: _canSubmit ? _resetPassword : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
