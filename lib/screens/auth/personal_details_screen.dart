import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/registration_provider.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool get _canContinue =>
      _nameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: 'Login', onActionPressed: () => context.go('/login-phone')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiBackLink(onTap: () => context.pop()),
          const SizedBox(height: 16),
          const Text('Almost there!\nTell us about yourself', style: IthakiTheme.headingLarge),
          const SizedBox(height: 12),
          const Text(
            'Your name and phone number help employers reach you directly.',
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiTextField(
            label: 'Name',
            hint: 'Enter your Name',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          IthakiTextField(
            label: 'Last Name',
            hint: 'Enter your Last Name',
            controller: _lastNameController,
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
            onPressed: _canContinue
                ? () {
                    ref.read(registrationProvider.notifier).setPersonalDetails(
                      _nameController.text.trim(),
                      _lastNameController.text.trim(),
                      _phoneController.text.trim(),
                    );
                    context.push('/choose-verify-method');
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
