import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../l10n/app_localizations.dart';

void showVerificationSheet(
  BuildContext context, {
  required String newValue,
  required bool isEmail,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => VerificationSheet(
      newValue: newValue,
      isEmail: isEmail,
      parentContext: context,
    ),
  );
}

class VerificationSheet extends StatefulWidget {
  final String newValue;
  final bool isEmail;
  final BuildContext parentContext;

  const VerificationSheet({
    super.key,
    required this.newValue,
    required this.isEmail,
    required this.parentContext,
  });

  @override
  State<VerificationSheet> createState() => _VerificationSheetState();
}

class _VerificationSheetState extends State<VerificationSheet>
    with CountdownMixin {
  final _pinController = PinInputController();
  String _otp = '';

  @override
  void initState() {
    super.initState();
    startCountdown(24);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final contactType = widget.isEmail ? l.emailLabel : l.phoneNumberLabel;

    return BottomSheetBase(
      title: l.verificationTitle,
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.newValueLabel(contactType),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.newValue,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            l.codeSentToContact(widget.isEmail ? l.phoneViaSms : l.emailLabel),
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          MaterialPinField(
            length: 6,
            pinController: _pinController,
            keyboardType: TextInputType.number,
            theme: MaterialPinTheme(
              shape: MaterialPinShape.outlined,
              borderRadius: BorderRadius.circular(12),
              cellSize: const Size(48, 56),
              borderColor: IthakiTheme.borderLight,
              fillColor: IthakiTheme.backgroundWhite,
              focusedBorderColor: IthakiTheme.primaryPurple,
              focusedFillColor: IthakiTheme.backgroundWhite,
              filledBorderColor: IthakiTheme.primaryPurple,
              filledFillColor: IthakiTheme.backgroundWhite,
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
            onChanged: (val) => setState(() => _otp = val),
            onCompleted: (val) => setState(() => _otp = val),
          ),
          const SizedBox(height: 12),
          IthakiResendTimer(
            canResend: countdownCanResend,
            secondsLeft: countdownSeconds,
            label: l.resendCode,
            onResend: () => startCountdown(24),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            l.submit,
            onPressed: _otp.length == 6
                ? () {
                    Navigator.pop(context);
                    SuccessBanner.show(
                      widget.parentContext,
                      widget.isEmail ? l.changedEmail : l.changedPhone,
                    );
                  }
                : null,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
