import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
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
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with CountdownMixin {
  final _otpController = PinInputController();
  String _otp = '';
  bool _isSending = false;

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
              fillColor: IthakiTheme.backgroundWhite,
              focusedBorderColor: IthakiTheme.primaryPurple,
              focusedFillColor: const Color(0xFFF0EAFA),
              filledBorderColor: IthakiTheme.primaryPurple,
              filledFillColor: IthakiTheme.backgroundWhite,
              textStyle: const TextStyle(color: IthakiTheme.textPrimary),
            ),
            onChanged: (value) => setState(() => _otp = value),
            onCompleted: (value) => setState(() => _otp = value),
          ),
          const SizedBox(height: 20),
          IthakiResendTimer(
            canResend: countdownCanResend && !_isSending,
            secondsLeft: countdownSeconds,
            label: resendLabel,
            onResend: () async {
              if (_isSending) return;
              setState(() => _isSending = true);
              try {
                await ref.read(authRepositoryProvider).sendOtp();
              } catch (_) {}
              if (mounted) setState(() => _isSending = false);
              startCountdown(24);
            },
          ),
          const SizedBox(height: 40),
          IthakiButton(
            l.continueButton,
            isEnabled: _otpComplete,
            onPressed: _otpComplete
                ? () async {
                    try {
                      await ref.read(authRepositoryProvider).verifyOtp(_otp);
                      resetProfileProviders(ref);
                      if (!context.mounted) return;
                      if (widget.successRoute == Routes.welcome) {
                        context.push(widget.successRoute);
                      } else {
                        context.go(widget.successRoute);
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      final message = e is AuthException
                          ? e.userMessage
                          : 'Something went wrong. Please try again.';
                      debugPrint('OTP error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
