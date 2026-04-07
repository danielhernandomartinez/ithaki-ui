import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: l.loginAction, onActionPressed: () => context.go(Routes.loginPhone)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.verifyEmailHeading, style: IthakiTheme.headingLarge),
          const SizedBox(height: 16),
          Text(
            l.verifyEmailDescription,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 12),
          Text(
            l.verifyEmailSpamHint,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiButton(
            l.verifiedEmailButton,
            onPressed: () => context.go(Routes.home),
          ),
          const SizedBox(height: 12),
          IthakiButton(
            l.backButton,
            variant: IthakiButtonVariant.outline,
            onPressed: () => context.go(Routes.loginEmail),
          ),
          const SizedBox(height: 16),
          IthakiResendTimer(
            canResend: countdownCanResend,
            secondsLeft: countdownSeconds,
            label: l.resendEmailLabel,
            onResend: () => startCountdown(24),
            variant: IthakiResendTimerVariant.card,
            icon: 'envelope',
          ),
        ],
      ),
    );
  }
}
