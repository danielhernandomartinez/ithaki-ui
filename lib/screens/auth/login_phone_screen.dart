import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/email_login_footer.dart';

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
    final l = AppLocalizations.of(context)!;
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundWhite,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        actionLabel: l.signUpAction,
        onActionPressed: () {
          context.push('/tech-comfort');
        },
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 16, right: 16, top: topOffset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Title
              Text(
                l.loginHeading,
                style: IthakiTheme.headingLarge.copyWith(
                  color: IthakiTheme.textPrimary,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                l.loginSubtitle,
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
                  l.selectMethodTitle,
                  style: IthakiTheme.sectionTitle.copyWith(
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // SMS method card
                IthakiOptionCard(
                  isSelected: _selectedMethod == 'sms',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'sms';
                    });
                  },
                  label: l.sendViaSms,
                  icon: 'envelope',
                  axis: Axis.vertical,
                  iconSize: 20,
                ),

                const SizedBox(height: 12),

                // WhatsApp method card
                IthakiOptionCard(
                  isSelected: _selectedMethod == 'whatsapp',
                  onTap: () {
                    setState(() {
                      _selectedMethod = 'whatsapp';
                    });
                  },
                  icon: 'whatsapp',
                  label: l.sendViaWhatsapp,
                  iconSize: 25,
                  axis: Axis.vertical,
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
                      l.rememberMe,
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
                  l.sendCodeButton,
                  onPressed: (_isPhoneValid && _selectedMethod.isNotEmpty)
                      ? () {
                          context.push(
                            '/verify-phone?phone=${Uri.encodeComponent(_fullPhoneNumber)}&method=$_selectedMethod',
                          );
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
