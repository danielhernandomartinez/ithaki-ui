import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/registration_provider.dart';
import '../../repositories/auth_repository.dart';

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
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: l.loginAction),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.verifyPhoneHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 12),
          Text(
            l.verifyPhoneDescription,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          Text(l.selectMethodTitle, style: IthakiTheme.sectionTitle),
          const SizedBox(height: 16),
          IthakiOptionCard(
            icon: 'envelope',
            label: l.sendViaSms,
            isSelected: _selectedMethod == 'sms',
            onTap: () => setState(() => _selectedMethod = 'sms'),
            backgroundColor: IthakiTheme.cardBackground,
            axis: Axis.vertical,
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            icon: 'whatsapp',
            label: l.sendViaWhatsapp,
            isSelected: _selectedMethod == 'whatsapp',
            onTap: () => setState(() => _selectedMethod = 'whatsapp'),
            backgroundColor: IthakiTheme.cardBackground,
            axis: Axis.vertical,
          ),
          const SizedBox(height: 20),
          IthakiCheckbox(
            value: _rememberChoice,
            onChanged: (val) => setState(() => _rememberChoice = val),
            child: Text(l.rememberChoice, style: IthakiTheme.bodyRegular),
          ),
          const SizedBox(height: 24),
          IthakiButton(
            l.continueButton,
            isEnabled: _selectedMethod != null,
            onPressed: _selectedMethod != null
                ? () async {
                    try {
                      final method = _selectedMethod!;
                      ref.read(registrationProvider.notifier)
                          .setVerifyMethod(method, remember: _rememberChoice);
                      final state = ref.read(registrationProvider);
                      await ref.read(authRepositoryProvider).register(
                            email: state.email,
                            password: state.password,
                            name: state.name,
                            lastName: state.lastName,
                            phone: state.phone,
                            verifyMethod: method,
                            techComfort: state.techLevel,
                            systemLanguage: state.language.isNotEmpty ? state.language : 'en',
                          );
                      if (context.mounted) {
                        context.push(Routes.verifyOtpWith(method: method));
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
