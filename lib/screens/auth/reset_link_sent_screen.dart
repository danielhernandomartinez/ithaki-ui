import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';

class ResetLinkSentScreen extends StatefulWidget {
  const ResetLinkSentScreen({super.key});

  @override
  State<ResetLinkSentScreen> createState() => _ResetLinkSentScreenState();
}

class _ResetLinkSentScreenState extends State<ResetLinkSentScreen>
    with CountdownMixin {
  @override
  void initState() {
    super.initState();
    startCountdown(24);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.backToLogin,
        onActionPressed: () => context.go(Routes.loginEmail),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.resetLinkSentHeading,
            style: IthakiTheme.headingLarge.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.resetLinkSentDescription,
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 24),
          IthakiResendTimer(
            canResend: countdownCanResend,
            secondsLeft: countdownSeconds,
            label: l.resendResetLinkEmail,
            onResend: () => startCountdown(24),
            variant: IthakiResendTimerVariant.card,
            icon: 'envelope',
          ),
          const SizedBox(height: 12),
          IthakiOptionCard(
            icon: 'whatsapp',
            label: l.sendResetViaWhatsapp,
            isSelected: false,
            onTap: () {
              // TODO: Navigate to send reset via WhatsApp screen
            },
            backgroundColor: IthakiTheme.cardBackground,
            axis: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
