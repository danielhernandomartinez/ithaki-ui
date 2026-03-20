import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/registration_provider.dart';

class ChooseVerifyMethodScreen extends ConsumerStatefulWidget {
  const ChooseVerifyMethodScreen({super.key});

  @override
  ConsumerState<ChooseVerifyMethodScreen> createState() => _ChooseVerifyMethodScreenState();
}

class _ChooseVerifyMethodScreenState extends ConsumerState<ChooseVerifyMethodScreen> {
  String? _selectedMethod;
  bool _rememberChoice = false;

  @override
  Widget build(BuildContext context) {
    return IthakiScreenLayout(
      appBar: const IthakiAppBar(actionLabel: 'Login'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Verify your phone number', style: IthakiTheme.headingLarge),
          const SizedBox(height: 12),
          const Text(
            'We\'ll send a verification code to your phone number. Choose how you\'d like to receive it.',
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
            axis: Axis.vertical,
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            icon: 'whatsapp',
            label: 'Send secured code via WhatsApp',
            isSelected: _selectedMethod == 'whatsapp',
            onTap: () => setState(() => _selectedMethod = 'whatsapp'),
            backgroundColor: IthakiTheme.cardBackground,
            axis: Axis.vertical,
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
                ? () {
                    ref.read(registrationProvider.notifier)
                        .setVerifyMethod(_selectedMethod!, remember: _rememberChoice);
                    context.push('/verify-otp?method=$_selectedMethod');
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
