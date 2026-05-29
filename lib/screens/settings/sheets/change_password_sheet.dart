import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/auth_provider.dart';
import '../../../utils/validators.dart';

class ChangePasswordSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const ChangePasswordSheet({super.key, required this.parentContext});

  @override
  ConsumerState<ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<ChangePasswordSheet> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _submitting = false;
  String? _currentError; // inline error under the current-password field
  String? _formError; // general error shown above the button

  PasswordValidation get _pwVal => PasswordValidation.of(_newCtrl.text);
  bool get _allRules => _pwVal.isValid;
  bool get _passwordsMatch =>
      _newCtrl.text.isNotEmpty && _newCtrl.text == _confirmCtrl.text;
  bool get _canSubmit =>
      _currentCtrl.text.isNotEmpty &&
      _allRules &&
      _passwordsMatch &&
      !_submitting;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    setState(() {
      _submitting = true;
      _currentError = null;
      _formError = null;
    });

    try {
      await ref.read(authRepositoryProvider).changePassword(
            currentPassword: _currentCtrl.text,
            newPassword: _newCtrl.text,
            confirmPassword: _confirmCtrl.text,
          );
      if (!mounted) return;
      Navigator.pop(context);
      if (!widget.parentContext.mounted) return;
      SuccessBanner.show(widget.parentContext, l.passwordUpdated);
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        switch (e.field) {
          case 'currentPassword':
            _currentError = l.currentPasswordIncorrect;
            break;
          case 'social':
            _formError = l.changePasswordSocialLogin;
            break;
          default:
            _formError = l.changePasswordFailed;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _formError = l.changePasswordFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BottomSheetBase(
      title: l.changePasswordTitle,
      onClose: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.changePasswordDescription,
              style: const TextStyle(
                  fontSize: 13, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            IthakiPasswordField(
              label: l.currentPasswordLabel,
              hint: l.currentPasswordHint,
              controller: _currentCtrl,
              onChanged: (_) => setState(() {
                if (_currentError != null) _currentError = null;
              }),
            ),
            if (_currentError != null) ...[
              const SizedBox(height: 6),
              Text(_currentError!, style: IthakiTheme.errorCaption),
            ],
            const SizedBox(height: 16),
            IthakiPasswordField(
              label: l.newPasswordLabel,
              hint: l.newPasswordHint,
              controller: _newCtrl,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            IthakiValidationRow(
              text: l.passwordUpperLower,
              valid: _pwVal.hasUpperAndLower,
            ),
            IthakiValidationRow(
              text: l.passwordMinLength,
              valid: _pwVal.hasMinLength,
            ),
            IthakiValidationRow(
              text: l.passwordNumber,
              valid: _pwVal.hasNumber,
            ),
            IthakiValidationRow(
              text: l.passwordSpecial,
              valid: _pwVal.hasSpecial,
            ),
            const SizedBox(height: 12),
            IthakiPasswordField(
              label: l.repeatNewPasswordLabel,
              hint: l.repeatNewPasswordHint,
              controller: _confirmCtrl,
              onChanged: (_) => setState(() {}),
            ),
            if (_formError != null) ...[
              const SizedBox(height: 12),
              Text(_formError!, style: IthakiTheme.errorCaption),
            ],
            const SizedBox(height: 20),
            IthakiButton(
              l.updateButton,
              onPressed: _canSubmit ? _submit : null,
              isEnabled: _canSubmit,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
