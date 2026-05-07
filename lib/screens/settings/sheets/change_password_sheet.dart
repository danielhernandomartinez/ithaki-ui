import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/validators.dart';

class ChangePasswordSheet extends StatefulWidget {
  final BuildContext parentContext;
  const ChangePasswordSheet({super.key, required this.parentContext});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  PasswordValidation get _pwVal => PasswordValidation.of(_newCtrl.text);
  bool get _allRules => _pwVal.isValid;
  bool get _passwordsMatch =>
      _newCtrl.text.isNotEmpty && _newCtrl.text == _confirmCtrl.text;

  @override
  void dispose() {
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
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
            const SizedBox(height: 20),
            IthakiButton(
              l.updateButton,
              onPressed: _allRules && _passwordsMatch
                  ? () {
                      Navigator.pop(context);
                      SuccessBanner.show(
                        widget.parentContext,
                        l.passwordUpdated,
                      );
                    }
                  : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
