import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/registration_provider.dart';
import '../../utils/jwt.dart';
import '../../utils/validators.dart';

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

  PasswordValidation _pwVal = PasswordValidation.of('');

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

  bool get _passwordValid => _pwVal.isValid;

  bool get _passwordsMatch =>
      _confirmPasswordController.text == _passwordController.text &&
      _confirmPasswordController.text.isNotEmpty;

  bool _isGoogleLoading = false;

  bool get _canContinue =>
      _emailValid && _passwordValid && _passwordsMatch && _termsAccepted;

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading) return;
    final l = AppLocalizations.of(context)!;
    if (kDebugMode) debugPrint('[googleSignIn] register flow started');
    setState(() => _isGoogleLoading = true);
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) throw AuthException(l.googleSignInFailed);
      if (kDebugMode) {
        final payload = decodeJwtPayload(idToken);
        debugPrint(
          '[googleSignIn] idToken aud=${payload?['aud']} azp=${payload?['azp']} iss=${payload?['iss']} exp=${payload?['exp']}',
        );
      }
      final session = await ref.read(authRepositoryProvider).loginWithGoogle(idToken);
      resetProfileProviders(ref);
      if (kDebugMode) debugPrint('[googleSignIn] register flow succeeded phoneVerified=${session.phoneVerified}');
      if (!mounted) return;
      if (!session.phoneVerified) {
        ref.read(registrationProvider.notifier).setFromGoogle(
              name: session.name,
              lastName: session.lastName,
              email: session.email,
            );
        context.go(Routes.personalDetails);
      } else {
        context.go(Routes.home);
      }
    } on GoogleSignInException catch (e) {
      if (!mounted) return;
      if (e.code == GoogleSignInExceptionCode.canceled) {
        if (kDebugMode) debugPrint('[googleSignIn] register flow cancelled');
        return;
      }
      if (kDebugMode) debugPrint('Google sign-in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.googleSignInFailed)),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is AuthException ? e.userMessage : l.googleSignInFailed;
      if (kDebugMode) debugPrint('Google sign-in error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _pwVal = PasswordValidation.of(value);
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
      appBar: IthakiAppBar(
          actionLabel: l.loginAction,
          onActionPressed: () => context.go(Routes.loginPhone)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiBackLink(onTap: () => context.pop()),
          const SizedBox(height: 16),
          Text(l.welcomeHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 24),
          IthakiSocialAuthButton.google(
            label: l.signInWithGoogle,
            onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          IthakiTextField(
            label: l.emailLabel,
            hint: l.emailHint,
            controller: _emailController,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: IthakiIcon('envelope',
                  size: 20,
                  color: _emailController.text.isNotEmpty
                      ? Colors.black
                      : IthakiTheme.softGraphite),
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
            IthakiValidationRow(
                valid: _pwVal.hasUpperAndLower, text: l.passwordUpperLower),
            IthakiValidationRow(
                valid: _pwVal.hasMinLength, text: l.passwordMinLength),
            IthakiValidationRow(
                valid: _pwVal.hasNumber, text: l.passwordNumber),
            IthakiValidationRow(
                valid: _pwVal.hasSpecial, text: l.passwordSpecial),
          ],
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: l.confirmPasswordLabel,
            hint: l.confirmPasswordHint,
            controller: _confirmPasswordController,
            onChanged: (_) => setState(() {}),
          ),
          if (_confirmPasswordController.text.isNotEmpty &&
              !_passwordsMatch) ...[
            const SizedBox(height: 8),
            Text(l.passwordsDoNotMatch,
                style: const TextStyle(fontSize: 13, color: Colors.red)),
          ],
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _termsAccepted,
                activeColor: IthakiTheme.primaryPurple,
                onChanged: (val) =>
                    setState(() => _termsAccepted = val ?? false),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 13, color: IthakiTheme.textSecondary),
                      children: [
                        TextSpan(text: l.termsText),
                        TextSpan(
                          text: l.privacyPolicy,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: IthakiTheme.textPrimary),
                        ),
                        TextSpan(text: l.andText),
                        TextSpan(
                          text: l.termsOfUse,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: IthakiTheme.textPrimary),
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
                    ref.read(registrationProvider.notifier).setCredentials(
                        _emailController.text, _passwordController.text);
                    context.push(Routes.personalDetails);
                  }
                : null,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
