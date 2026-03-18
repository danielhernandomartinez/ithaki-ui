import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ithaki_theme.dart';
import '../../widgets/ithaki_app_bar.dart';
import '../../widgets/ithaki_button.dart';
import '../../widgets/ithaki_icon.dart';

class ChooseVerifyMethodScreen extends StatefulWidget {
  const ChooseVerifyMethodScreen({super.key});

  @override
  State<ChooseVerifyMethodScreen> createState() => _ChooseVerifyMethodScreenState();
}

class _ChooseVerifyMethodScreenState extends State<ChooseVerifyMethodScreen> {
  String? _selectedMethod;
  bool _rememberChoice = false;

  Widget _methodCard({
    required String method,
    required String icon,
    required String label,
    required Color iconColor,
  }) {
    final isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0EAFA) : IthakiTheme.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? IthakiTheme.primaryPurple : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            IthakiIcon(icon, size: 28, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IthakiAppBar(showLogin: false),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you!\nYour Account is created!',
              style: IthakiTheme.headingLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'We\'ll send a code to your phone number to complete account creation and verify your phone number. '
              'Choose how you\'d like to receive it and request the code.',
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 24),
            const Text('Select a method to receive the code', style: IthakiTheme.sectionTitle),
            const SizedBox(height: 16),
            _methodCard(
              method: 'sms',
              icon: 'phone',
              label: 'Send secured code via SMS',
              iconColor: IthakiTheme.primaryPurple,
            ),
            const SizedBox(height: 12),
            _methodCard(
              method: 'whatsapp',
              icon: 'whatsapp',
              label: 'Send secured code via WhatsApp',
              iconColor: const Color(0xFF25D366),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _rememberChoice,
                  activeColor: IthakiTheme.primaryPurple,
                  onChanged: (val) => setState(() => _rememberChoice = val ?? false),
                ),
                const Expanded(child: Text('Remember my choice', style: IthakiTheme.bodyRegular, overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 24),
            IthakiButton(
              'Continue',
              isEnabled: _selectedMethod != null,
              onPressed: _selectedMethod != null
                  ? () => context.go('/verify-otp?method=$_selectedMethod')
                  : null,
            ),
          ],
        ),
      ),
    ),
    );
  }
}
