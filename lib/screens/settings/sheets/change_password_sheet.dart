import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
    return BottomSheetBase(
      title: 'Change Password',
      onClose: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'Change your password to keep your account secure',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: 'New Password',
            hint: 'Enter your new password',
            controller: _newCtrl,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          IthakiValidationRow(
            text: 'Includes one uppercase and one lowercase letter',
            valid: _pwVal.hasUpperAndLower,
          ),
          IthakiValidationRow(
            text: 'At least 8 characters',
            valid: _pwVal.hasMinLength,
          ),
          IthakiValidationRow(
            text: 'Includes at least one number',
            valid: _pwVal.hasNumber,
          ),
          IthakiValidationRow(
            text: r'Includes one special character (like !@#$%^&)',
            valid: _pwVal.hasSpecial,
          ),
          const SizedBox(height: 12),
          IthakiPasswordField(
            label: 'Repeat New Password',
            hint: 'Repeat your new password',
            controller: _confirmCtrl,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Update',
            onPressed: _allRules && _passwordsMatch
                ? () {
                    Navigator.pop(context);
                    SuccessBanner.show(
                      widget.parentContext,
                      'Your password has been updated.',
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
