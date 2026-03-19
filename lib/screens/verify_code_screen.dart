import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../widgets/email_login_footer.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final String method;

  const VerifyCodeScreen({
    super.key,
    required this.phoneNumber,
    required this.method,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen>
    with CountdownMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _code => _controllers.map((c) => c.text).join();
  bool get _isCodeComplete => _code.length == 6;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundWhite,
      appBar: IthakiAppBar(
        actionLabel: 'Sign Up',
        onActionPressed: () {
          // TODO: Navigate to sign up
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              Text(
                'Login to Ithaki Talent',
                style: IthakiTheme.headingLarge.copyWith(
                  color: IthakiTheme.textPrimary,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'We\'ve sent a verification code to ${widget.phoneNumber}',
                style: IthakiTheme.bodyRegular.copyWith(
                  color: IthakiTheme.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    'This is not your phone? ',
                    style: IthakiTheme.bodyRegular.copyWith(
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Go Back',
                      style: IthakiTheme.bodyRegular.copyWith(
                        color: IthakiTheme.textPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Code input boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 48,
                    height: 56,
                    margin: EdgeInsets.only(right: index < 5 ? 8 : 0),
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) => _onKeyEvent(index, event),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: IthakiTheme.headingLarge.copyWith(
                          color: IthakiTheme.textPrimary,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: IthakiTheme.borderLight,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: IthakiTheme.primaryPurple,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Resend countdown
              Center(
                child: countdownCanResend
                    ? GestureDetector(
                        onTap: () {
                          startCountdown();
                          // TODO: Resend code
                        },
                        child: Text(
                          'Resend code',
                          style: IthakiTheme.bodyRegular.copyWith(
                            color: IthakiTheme.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : Text(
                        'Resend code in 0:${countdownSeconds.toString().padLeft(2, '0')}',
                        style: IthakiTheme.bodyRegular.copyWith(
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
              ),

              const SizedBox(height: 32),

              // Login button
              SizedBox(
                width: double.infinity,
                child: IthakiButton(
                  'Login',
                  onPressed: _isCodeComplete
                      ? () {
                          debugPrint('Verifying code: $_code');
                          // TODO: Verify code implementation
                        }
                      : null,
                ),
              ),

              const SizedBox(height: 24),

              const EmailLoginFooter(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
