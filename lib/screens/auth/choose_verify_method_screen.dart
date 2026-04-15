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
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _rememberChoice = !_rememberChoice),
            child: IthakiCheckbox(
              value: _rememberChoice,
              onChanged: (val) => setState(() => _rememberChoice = val),
              child: Text(l.rememberChoice, style: IthakiTheme.bodyRegular),
            ),
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
                      final regState = ref.read(registrationProvider);
                      final repo = ref.read(authRepositoryProvider);

                      try {
                        await repo.register(
                          email: regState.email,
                          password: regState.password,
                          name: regState.name,
                          lastName: regState.lastName,
                          phone: regState.phone,
                          verifyMethod: method,
                          techComfort: regState.techLevel,
                          systemLanguage: regState.language.isNotEmpty ? regState.language : 'en',
                        );
                      } catch (signupError) {
                        // Account already created in a previous attempt — the JWT is
                        // still in SharedPreferences. Just resend the OTP and proceed.
                        final detail = signupError is AuthException
                            ? (signupError.internalDetail ?? '').toLowerCase()
                            : signupError.toString().toLowerCase();
                        if (detail.contains('already') || detail.contains('exists') || detail.contains('duplicate')) {
                          try { await repo.updatePhone(regState.phone); } catch (_) {}
                          try { await repo.sendOtp(); } catch (_) {}
                        } else {
                          rethrow;
                        }
                      }

                      if (context.mounted) {
                        context.push(Routes.verifyOtpWith(method: method));
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      final message = e is AuthException
                          ? e.userMessage
                          : 'Something went wrong. Please try again.';
                      debugPrint('Registration error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
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
