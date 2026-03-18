import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _phoneController = TextEditingController();
  bool _isPhoneValid = false;
  String _selectedMethod = '';
  bool _rememberMe = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String value) {
    final phoneRegex = RegExp(r'^\+?[0-9\s]{8,15}$');
    setState(() {
      _isPhoneValid = phoneRegex.hasMatch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundWhite,
      appBar: IthakiAppBar(
        showLogin: true,
        onLoginPressed: () {
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
              IthakiTextField(
                label: 'Phone Number',
                hint: '+1 (555) 000-0000',
                controller: _phoneController,
                onChanged: _validatePhone,
                keyboardType: TextInputType.phone,
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
                _DeliveryMethodCard(
                  title: 'Send secured code via SMS',
                  value: 'sms',
                  isSelected: _selectedMethod == 'sms',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'sms';
                    });
                  },
                ),

                const SizedBox(height: 12),

                // WhatsApp method card
                _DeliveryMethodCard(
                  title: 'Send secured code via WhatsApp',
                  value: 'whatsapp',
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
                          debugPrint('Sending code to $_selectedMethod');
                          // TODO: Send code implementation
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

/// Custom delivery method card using design system
class _DeliveryMethodCard extends StatelessWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryMethodCard({
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? IthakiTheme.primaryPurple.withValues(alpha: 0.05)
              : IthakiTheme.backgroundWhite,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: IthakiTheme.bodyRegular.copyWith(
                  color: IthakiTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? IthakiTheme.primaryPurple
                      : IthakiTheme.borderLight,
                  width: 2,
                ),
                color:
                    isSelected ? IthakiTheme.primaryPurple : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
