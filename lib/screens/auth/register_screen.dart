import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return IthakiIcon('google-social', size: size);
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _termsAccepted = false;
  bool _passwordFocused = false;

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });
  }

  // Password validation flags
  bool _hasUpperLower = false;
  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  bool get _emailValid {
    final email = _emailController.text;
    return email.contains('@') && email.contains('.');
  }

  bool get _passwordValid => _hasUpperLower && _hasMinLength && _hasNumber && _hasSpecial;

  bool get _canContinue => _emailValid && _passwordValid && _termsAccepted;

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
    _passwordFocus.dispose();
    super.dispose();
  }

  Widget _validationRow(bool valid, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          valid
              ? const IthakiIcon('check', size: 16, color: IthakiTheme.successGreen)
              : const IthakiIcon('alert-circle', size: 16, color: IthakiTheme.textHint),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: valid ? IthakiTheme.textPrimary : IthakiTheme.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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
            const SizedBox(height: 24),
            // Google sign-in
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
                    Text(
                      'Sign in with Google',
                      style: TextStyle(color: IthakiTheme.textPrimary, fontWeight: FontWeight.w600),
                    ),
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
            IthakiTextField(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordController,
              focusNode: _passwordFocus,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: IthakiIcon(
                  _obscurePassword ? 'eye-closed' : 'eye',
                  size: 20,
                  color: IthakiTheme.textHint,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              onChanged: _onPasswordChanged,
            ),
            if (_passwordFocused || _passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              _validationRow(_hasUpperLower, 'Includes one uppercase and one lowercase letter'),
              _validationRow(_hasMinLength, 'At least 8 characters'),
              _validationRow(_hasNumber, 'Includes at least one number'),
              _validationRow(_hasSpecial, 'Includes one special character (like !@#\$%^&)'),
            ],
            const SizedBox(height: 16),
            // Terms checkbox
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: IthakiTheme.textPrimary,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Terms of Use',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: IthakiTheme.textPrimary,
                            ),
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
              onPressed: _canContinue ? () => context.go('/verify-email') : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    );
  }
}
