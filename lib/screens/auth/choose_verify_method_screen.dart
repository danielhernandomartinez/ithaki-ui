import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class ChooseVerifyMethodScreen extends StatefulWidget {
  const ChooseVerifyMethodScreen({super.key});

  @override
  State<ChooseVerifyMethodScreen> createState() => _ChooseVerifyMethodScreenState();
}

class _ChooseVerifyMethodScreenState extends State<ChooseVerifyMethodScreen> {
  String? _selectedMethod;
  bool _rememberChoice = false;


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
              IthakiOptionCard(
                icon: 'envelope',
                label: 'Send secured code via SMS',
                isSelected: _selectedMethod == 'sms',
                onTap: () => setState(() => _selectedMethod = 'sms'),
                backgroundColor: IthakiTheme.cardBackground,
                layout: IthakiOptionCardLayout.column,
              ),
              const SizedBox(height: 12),
              IthakiOptionCard(
                icon: 'whatsapp',
                label: 'Send secured code via WhatsApp',
                isSelected: _selectedMethod == 'whatsapp',
                onTap: () => setState(() => _selectedMethod = 'whatsapp'),
                backgroundColor: IthakiTheme.cardBackground,
                layout: IthakiOptionCardLayout.column,
              ),
              const SizedBox(height: 20),
              IthakiCheckbox(
                value: _rememberChoice,
                onChanged: (val) => setState(() => _rememberChoice = val),
                child: const Text('Remember my choice', style: IthakiTheme.bodyRegular),
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
