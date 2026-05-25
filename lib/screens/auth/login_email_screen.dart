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

class LoginEmailScreen extends ConsumerStatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  ConsumerState<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends ConsumerState<LoginEmailScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  bool get _emailValid {
    final email = _emailController.text;
    return email.contains('@') && email.contains('.');
  }

  bool get _canSignIn =>
      !_isLoading && _emailValid && _passwordController.text.isNotEmpty;

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    final l = AppLocalizations.of(context)!;
    if (kDebugMode) debugPrint('[googleSignIn] login flow started');
    setState(() => _isLoading = true);
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
      if (kDebugMode) debugPrint('[googleSignIn] login flow succeeded phoneVerified=${session.phoneVerified}');
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
        if (kDebugMode) debugPrint('[googleSignIn] login flow cancelled');
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
        onActionPressed: () => context.go(Routes.techComfort),
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
              child: IthakiIcon('envelope',
                  size: 18, color: IthakiTheme.softGraphite),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                      Flexible(
                        child: Text(
                          l.rememberMe,
                          style: IthakiTheme.bodyRegular,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => context.push(Routes.forgotPassword),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: IthakiTheme.textPrimary, width: 1),
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
                  ? () async {
                      if (_isLoading) return;
                      setState(() => _isLoading = true);
                      try {
                        await ref.read(authRepositoryProvider).loginWithEmail(
                              _emailController.text,
                              _passwordController.text,
                            );
                        resetProfileProviders(ref);
                        if (context.mounted) {
                          context.go(Routes.home);
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        final message = e is AuthException
                            ? e.userMessage
                            : 'Something went wrong. Please try again.';
                        if (kDebugMode) debugPrint('Login error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      } finally {
                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    }
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // Sign in with Google button
          IthakiSocialAuthButton.google(
            label: l.signInWithGoogle,
            onPressed: _isLoading ? null : _handleGoogleSignIn,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
