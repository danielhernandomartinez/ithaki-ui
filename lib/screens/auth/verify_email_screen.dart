import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with CountdownMixin {
  @override
  void initState() {
    super.initState();
    startCountdown(24);
  }

  String get _timerLabel {
    if (countdownCanResend) return 'Resend link via email';
    final secs = countdownSeconds;
    return 'Resend link via email in 0:${secs.toString().padLeft(2, '0')}';
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
            const Text('Verify your email address', style: IthakiTheme.headingLarge),
            const SizedBox(height: 16),
            const Text(
              'We\'ve sent a verification link to your email address.\nPlease check your inbox and follow the link to complete your account setup.',
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 12),
            const Text(
              'Didn\'t receive the email? Check your spam folder or resend it.',
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 24),
            IthakiButton(
              'I\'ve verified my email',
              onPressed: () => context.go('/personal-details'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: countdownCanResend ? () => startCountdown(24) : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: IthakiTheme.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IthakiIcon('envelope', size: 22, color: IthakiTheme.textPrimary),
                    const SizedBox(height: 8),
                    Text(
                      _timerLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: countdownCanResend
                            ? IthakiTheme.primaryPurple
                            : IthakiTheme.textSecondary,
                        decoration: countdownCanResend ? TextDecoration.underline : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
