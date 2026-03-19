import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
      appBar: IthakiAppBar(showLogin: true, onLoginPressed: () => context.go('/login')),
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
              child: Container(
                padding: const EdgeInsets.only(bottom: 3),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: IthakiTheme.textPrimary, width: 1.2)),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
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
            IthakiPhoneField(
              controller: _phoneController,
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
