import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../config/app_config.dart';
import '../../l10n/app_localizations.dart';

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

  bool get _canUsePhone =>
      _isPhoneValid ||
      (AppConfig.bypassPhoneValidation &&
          _phoneController.text.trim().isNotEmpty);

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return IthakiScreenLayout(
      appBar: IthakiAppBar(
        actionLabel: l.signUpAction,
        onActionPressed: () {
          context.go(Routes.techComfort);
        },
      ),
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
            label: l.phoneNumberLabel,
            selectCountryTitle: l.selectCountryTitle,
            validationErrorText: l.phoneValidationError,
            countryPickerSearchHint: l.searchHint,
            countryPickerSelectLabel: l.selectAction,
          ),

          const SizedBox(height: 24),

          // Delivery method selection
          if (_canUsePhone) ...[
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
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _rememberMe = !_rememberMe),
              child: Row(
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
            ),

            const SizedBox(height: 24),
          ],

          // Send Code button
          // TODO(backend): Call a login-by-phone endpoint (e.g. POST /auth/login-phone)
          // before navigating. The endpoint should authenticate the user, return a JWT,
          // and trigger the OTP send (SMS or WhatsApp). Add loginWithPhone(String phone)
          // to AuthRepository and wire it here. Until then, VerifyOtpScreen is reached
          // without a valid session and no OTP is ever dispatched.
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              l.sendCodeButton,
              onPressed: (_canUsePhone && _selectedMethod.isNotEmpty)
                  ? () {
                      context.push(
                        Routes.verifyPhoneWith(
                            phone: _fullPhoneNumber, method: _selectedMethod),
                      );
                    }
                  : null,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
