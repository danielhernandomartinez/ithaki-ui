import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String method;

  const VerifyOtpScreen({super.key, this.method = 'sms'});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> with CountdownMixin {
  final _otpController = TextEditingController();
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
    return IthakiScreenLayout(
      appBar: IthakiAppBar(actionLabel: 'Login', onActionPressed: () => context.go('/login')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Let\'s verify your Account', style: IthakiTheme.headingLarge),
          const SizedBox(height: 12),
          const Text(
            'We\'ve sent a verification code to +30 123 456 789',
            style: IthakiTheme.bodyRegular,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Flexible(
                child: Text('This is not your phone?  ', style: IthakiTheme.bodyRegular, overflow: TextOverflow.ellipsis),
              ),
              GestureDetector(
                onTap: () => context.go('/personal-details'),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
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
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: _otpController,
            keyboardType: TextInputType.number,
            animationType: AnimationType.none,
            enableActiveFill: true,
            textStyle: const TextStyle(color: IthakiTheme.textPrimary),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(14),
              fieldHeight: 52,
              fieldWidth: 46,
              activeColor: IthakiTheme.primaryPurple,
              inactiveColor: IthakiTheme.borderLight,
              selectedColor: IthakiTheme.primaryPurple,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: const Color(0xFFF0EAFA),
            ),
            onChanged: (value) => setState(() => _otp = value),
            onCompleted: (value) => setState(() => _otp = value),
          ),
          const SizedBox(height: 20),
          IthakiResendTimer(
            canResend: countdownCanResend,
            secondsLeft: countdownSeconds,
            label: 'Resend code',
            onResend: () => startCountdown(24),
          ),
          const SizedBox(height: 40),
          IthakiButton(
            'Continue',
            isEnabled: _otpComplete,
            onPressed: _otpComplete ? () => context.push('/welcome') : null,
          ),
        ],
      ),
    );
  }
}
