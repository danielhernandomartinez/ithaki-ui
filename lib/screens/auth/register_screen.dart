import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: 'Login', onActionPressed: () => context.go('/login-phone')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiBackLink(onTap: () => context.go('/tech-comfort')),
          const SizedBox(height: 16),
          const Text('Welcome to Ithaki!\nLet\'s create an Account!', style: IthakiTheme.headingLarge),
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleLogo(size: 22),
                  SizedBox(width: 12),
                  Text('Sign in with Google', style: TextStyle(color: IthakiTheme.textPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          IthakiTextField(
            label: 'Email',
            hint: 'Enter your email',
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
            label: 'Password',
            hint: 'Enter your password',
            controller: _passwordController,
            focusNode: _passwordFocus,
            onChanged: _onPasswordChanged,
          ),
          if (_passwordFocused || _passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            IthakiValidationRow(valid: _hasUpperLower, text: 'Includes one uppercase and one lowercase letter'),
            IthakiValidationRow(valid: _hasMinLength, text: 'At least 8 characters'),
            IthakiValidationRow(valid: _hasNumber, text: 'Includes at least one number'),
            IthakiValidationRow(valid: _hasSpecial, text: 'Includes one special character (like !@#\$%^&)'),
          ],
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: 'Confirm Password',
            hint: 'Repeat your password',
            controller: _confirmPasswordController,
            onChanged: (_) => setState(() {}),
          ),
          if (_confirmPasswordController.text.isNotEmpty && !_passwordsMatch) ...[
            const SizedBox(height: 8),
            const Text('Passwords do not match', style: TextStyle(fontSize: 13, color: Colors.red)),
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
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
                      children: [
                        TextSpan(text: 'By continuing, you acknowledge that you have read and accepted our '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: IthakiTheme.textPrimary),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: IthakiTheme.textPrimary),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          IthakiButton(
            'Continue',
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
