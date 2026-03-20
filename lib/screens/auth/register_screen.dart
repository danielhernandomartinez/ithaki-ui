import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/registration_provider.dart';

class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return IthakiIcon('google-social', size: size);
  }
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _termsAccepted = false;
  bool _passwordFocused = false;

  bool _hasUpperLower = false;
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
  }

  bool get _emailValid {
    final email = _emailController.text;
    return email.contains('@') && email.contains('.');
  }

  bool get _passwordValid => _hasUpperLower && _hasMinLength && _hasNumber && _hasSpecial;

  bool get _passwordsMatch =>
      _confirmPasswordController.text == _passwordController.text &&
      _confirmPasswordController.text.isNotEmpty;

  bool get _canContinue => _emailValid && _passwordValid && _passwordsMatch && _termsAccepted;

  void _onPasswordChanged(String value) {
    setState(() {
      _hasUpperLower = value.contains(RegExp(r'[A-Z]')) && value.contains(RegExp(r'[a-z]'));
      _hasMinLength = value.length >= 8;
      _hasNumber = value.contains(RegExp(r'[0-9]'));
      _hasSpecial = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: l.loginAction, onActionPressed: () => context.go('/login-phone')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiBackLink(onTap: () => context.go('/tech-comfort')),
          const SizedBox(height: 16),
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: IthakiTheme.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleLogo(size: 22),
                  const SizedBox(width: 12),
                  Text(l.signInWithGoogle, style: const TextStyle(color: IthakiTheme.textPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          IthakiTextField(
            label: l.emailLabel,
            hint: l.emailHint,
            controller: _emailController,
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: IthakiIcon('envelope', size: 18, color: IthakiTheme.textHint),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: l.passwordLabel,
            hint: l.passwordHint,
            controller: _passwordController,
            focusNode: _passwordFocus,
            onChanged: _onPasswordChanged,
          ),
          if (_passwordFocused || _passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            IthakiValidationRow(valid: _hasUpperLower, text: l.passwordUpperLower),
            IthakiValidationRow(valid: _hasMinLength, text: l.passwordMinLength),
            IthakiValidationRow(valid: _hasNumber, text: l.passwordNumber),
            IthakiValidationRow(valid: _hasSpecial, text: l.passwordSpecial),
          ],
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: l.confirmPasswordLabel,
            hint: l.confirmPasswordHint,
            controller: _confirmPasswordController,
            onChanged: (_) => setState(() {}),
          ),
          if (_confirmPasswordController.text.isNotEmpty && !_passwordsMatch) ...[
            const SizedBox(height: 8),
            Text(l.passwordsDoNotMatch, style: const TextStyle(fontSize: 13, color: Colors.red)),
          ],
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _termsAccepted,
                activeColor: IthakiTheme.primaryPurple,
                onChanged: (val) => setState(() => _termsAccepted = val ?? false),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
                      children: [
                        TextSpan(text: l.termsText),
                        TextSpan(
                          text: l.privacyPolicy,
                          style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: IthakiTheme.textPrimary),
                        ),
                        TextSpan(text: l.andText),
                        TextSpan(
                          text: l.termsOfUse,
                          style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: IthakiTheme.textPrimary),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          IthakiButton(
            l.continueButton,
            isEnabled: _canContinue,
            onPressed: _canContinue
                ? () {
                    ref.read(registrationProvider.notifier)
                        .setCredentials(_emailController.text, _passwordController.text);
                    context.go('/personal-details');
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
