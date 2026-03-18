import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show TextInputFormatter, TextEditingValue, TextSelection;
import 'package:go_router/go_router.dart';
import '../../theme/ithaki_theme.dart';
import '../../widgets/ithaki_app_bar.dart';
import '../../widgets/ithaki_button.dart';
import '../../widgets/ithaki_icon.dart';
import '../../widgets/ithaki_text_field.dart';

class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r'[^\d]'), '');
    final buf = StringBuffer();
    if (digits.isNotEmpty) buf.write('+');
    for (int i = 0; i < digits.length && i < 12; i++) {
      if (i == 2 || i == 5 || i == 8 || i == 10) buf.write(' ');
      buf.write(digits[i]);
    }
    final result = buf.toString();
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool get _canContinue =>
      _nameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IthakiAppBar(showLogin: true),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 14,
                  color: IthakiTheme.textPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Ithaki!\nLet\'s create an Account!',
              style: IthakiTheme.headingLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'Just a few more details to set up your account. Your name and phone number help employers reach you!',
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 24),
            IthakiTextField(
              label: 'Name',
              hint: 'Enter your Name',
              controller: _nameController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            IthakiTextField(
              label: 'Last Name',
              hint: 'Enter your Last Name',
              controller: _lastNameController,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            IthakiTextField(
              label: 'Phone Number',
              hint: '+XX XXX XXX XX XX',
              controller: _phoneController,
              inputFormatters: [_PhoneFormatter()],
              suffixIcon: const Padding(
                padding: EdgeInsets.all(12),
                child: IthakiIcon('phone', size: 18, color: IthakiTheme.textHint),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 40),
            IthakiButton(
              'Continue',
              isEnabled: _canContinue,
              onPressed: _canContinue ? () => context.go('/choose-verify-method') : null,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
