import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> with CountdownMixin {
  @override
  void initState() {
    super.initState();
    startCountdown(24);
  }

  @override
  Widget build(BuildContext context) {
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: 'Login', onActionPressed: () => context.go('/login')),
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
          const SizedBox(height: 12),
          IthakiButton(
            'Back',
            variant: IthakiButtonVariant.outline,
            onPressed: () => context.go('/register'),
          ),
          const SizedBox(height: 16),
          IthakiResendTimer(
            canResend: countdownCanResend,
            secondsLeft: countdownSeconds,
            label: 'Resend link via email',
            onResend: () => startCountdown(24),
            variant: IthakiResendTimerVariant.card,
            icon: 'envelope',
          ),
        ],
      ),
    );
  }
}
