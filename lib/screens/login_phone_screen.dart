import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'verify_code_screen.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _phoneController = TextEditingController();
  bool _isPhoneValid = false;
  String _fullPhoneNumber = '';
  String _selectedMethod = '';
  bool _rememberMe = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
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

              // Title
              Text(
                'Login to Ithaki Talent',
                style: IthakiTheme.headingLarge.copyWith(
                  color: IthakiTheme.textPrimary,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Enter your phone number. We\'ll send you a code by SMS.',
                style: IthakiTheme.bodyRegular.copyWith(
                  color: IthakiTheme.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Phone number field
              IthakiPhoneField(
                controller: _phoneController,
                onChanged: (value) => setState(() {
                  _fullPhoneNumber = value;
                }),
                onValidationChanged: (isValid) {
                  setState(() {
                    _isPhoneValid = isValid;
                  });
                },
              ),

              const SizedBox(height: 24),

              // Delivery method selection
              if (_isPhoneValid) ...[
                Text(
                  'Select a method to receive the code',
                  style: IthakiTheme.sectionTitle.copyWith(
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // SMS method card
                IthakiOptionCard(
                  layout: IthakiOptionCardLayout.column,
                  label: 'Send secured code via SMS',
                  isSelected: _selectedMethod == 'sms',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'sms';
                    });
                  },
                  icon: 'envelope',
                ),

                const SizedBox(height: 12),

                // WhatsApp method card
                IthakiOptionCard(
                  layout: IthakiOptionCardLayout.column,
                  label: 'Send secured code via WhatsApp',
                  icon: 'whatsapp',
                  isSelected: _selectedMethod == 'whatsapp',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'whatsapp';
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Remember me checkbox
                Row(
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
                    const SizedBox(width: 12),
                    Text(
                      'Remember me',
                      style: IthakiTheme.bodyRegular.copyWith(
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],

              // Send Code button
              SizedBox(
                width: double.infinity,
                child: IthakiButton(
                  'Send Code',
                  onPressed: (_isPhoneValid && _selectedMethod.isNotEmpty)
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VerifyCodeScreen(
                                phoneNumber: _fullPhoneNumber,
                                method: _selectedMethod,
                              ),
                            ),
                          );
                        }
                      : null,
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              const Divider(
                color: IthakiTheme.borderLight,
                thickness: 1,
              ),

              const SizedBox(height: 24),

              // Alternative login text
              Center(
                child: Text(
                  'Prefer email? You can sign in with email instead.',
                  style: IthakiTheme.bodyRegular.copyWith(
                    color: IthakiTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Sign in with email button
              SizedBox(
                width: double.infinity,
                child: IthakiButton(
                  'Sign in with Email',
                  variant: IthakiButtonVariant.outline,
                  onPressed: () {
                    // TODO: Navigate to email login
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
