import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String method;
  final String? title;
  final String? subtitle;
  final String? backLabel;
  final String backRoute;
  final String? actionLabel;
  final String actionRoute;
  final String successRoute;
  final String? resendLabel;

  const VerifyOtpScreen({
    super.key,
    this.method = 'sms',
    this.title,
    this.subtitle,
    this.backLabel,
    this.backRoute = Routes.personalDetails,
    this.actionLabel,
    this.actionRoute = Routes.loginPhone,
    this.successRoute = Routes.welcome,
    this.resendLabel,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> with CountdownMixin {
  final _otpController = PinInputController();
  String _otp = '';

  bool get _otpComplete => _otp.length == 6;

  @override
  void initState() {
    super.initState();
    startCountdown(24);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = widget.title ?? l.verifyAccountTitle;
    final subtitle = widget.subtitle ?? l.verifyAccountSubtitle;
    final backLabel = widget.backLabel ?? l.notYourPhone;
    final actionLabel = widget.actionLabel ?? l.loginAction;
    final resendLabel = widget.resendLabel ?? l.resendCode;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: actionLabel,
        onActionPressed: () => context.go(widget.actionRoute),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: IthakiTheme.headingLarge),
          const SizedBox(height: 12),
          Text(subtitle, style: IthakiTheme.bodyRegular),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  '$backLabel  ',
                  style: IthakiTheme.bodyRegular,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Text(
                  l.goBack,
                  style: const TextStyle(
                    fontSize: 14,
                    color: IthakiTheme.primaryPurple,
                    decoration: TextDecoration.underline,
                    decorationColor: IthakiTheme.primaryPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          MaterialPinField(
            length: 6,
            pinController: _otpController,
            keyboardType: TextInputType.number,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              borderRadius: BorderRadius.circular(14),
              cellSize: const Size(46, 52),
              borderColor: IthakiTheme.borderLight,
              fillColor: Colors.white,
              focusedBorderColor: IthakiTheme.primaryPurple,
              focusedFillColor: const Color(0xFFF0EAFA),
              filledBorderColor: IthakiTheme.primaryPurple,
              filledFillColor: Colors.white,
              textStyle: const TextStyle(color: IthakiTheme.textPrimary),
            ),
            onChanged: (value) => setState(() => _otp = value),
            onCompleted: (value) => setState(() => _otp = value),
          ),
          const SizedBox(height: 20),
          IthakiResendTimer(
            canResend: countdownCanResend,
            secondsLeft: countdownSeconds,
            label: resendLabel,
            onResend: () => startCountdown(24),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _otpComplete,
            onPressed: _otpComplete
                ? () => context.go(widget.successRoute)
                : null,
          ),
        ],
      ),
    );
  }
}
