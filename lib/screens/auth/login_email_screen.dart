import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/phone_login_footer.dart';

class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return IthakiIcon('google-social', size: size);
  }
}

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  bool get _emailValid {
    final email = _emailController.text;
    return email.contains('@') && email.contains('.');
  }

  bool get _canSignIn => _emailValid && _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.signUpAction,
        onActionPressed: () => context.push('/tech-comfort'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // Title
          Text(
            l.loginHeading,
            style: IthakiTheme.headingLarge.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 32),

          // Email field
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

          // Password field
          IthakiPasswordField(
            label: l.passwordLabel,
            hint: l.passwordHint,
            controller: _passwordController,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 16),

          // Remember me + Forgot password
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _rememberMe,
                  activeColor: IthakiTheme.primaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (bool? newValue) {
                    setState(() {
                      _rememberMe = newValue ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l.rememberMe,
                style: IthakiTheme.bodyRegular
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/forgot-password'),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: IthakiTheme.textPrimary, width: 1),
                    ),
                  ),
                  child: Text(
                    l.forgotPassword,
                    style: IthakiTheme.bodyRegular,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Sign In button
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              l.signInButton,
              onPressed: _canSignIn
                  ? () {
                      // TODO: Handle email sign in
                    }
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // Sign in with Google button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Handle Google sign in
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                side: const BorderSide(color: IthakiTheme.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _GoogleLogo(size: 22),
                  const SizedBox(width: 12),
                  Text(
                    l.signInWithGoogle,
                    style: const TextStyle(
                      color: IthakiTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const PhoneLoginFooter(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
