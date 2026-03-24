import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../providers/profile_provider.dart';
import '../../providers/settings_provider.dart';

// ---------------------------------------------------------------------------
// Combined Settings Screen
// ---------------------------------------------------------------------------

class SettingsScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const SettingsScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late int _tabIndex;

  static const _newsletterTopics = [
    (
      'Jobs Recommendations',
      'Personalized job offers based on your skills and preferences',
    ),
    (
      'Career Tips',
      'Expert advice and resources to boost your professional growth',
    ),
    (
      'Events & Webinars',
      'Upcoming career events, workshops, and networking sessions',
    ),
    (
      'Platform Updates',
      'New features, tools, and product improvements',
    ),
    (
      'Learning Opportunities',
      'Online courses and certifications to enhance your skills',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        title: _tabIndex == 0 ? 'Account Settings' : 'Notifications',
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildAccountSettingsContent(),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _buildNotificationsContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab bar ──────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE9DEFF),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _tabPill('Account Settings', 0)),
          const SizedBox(width: 6),
          Expanded(child: _tabPill('Notifications', 1)),
        ],
      ),
    );
  }

  Widget _tabPill(String label, int index) {
    final selected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFE9DEFF),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? IthakiTheme.textPrimary
                  : IthakiTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ── Account Settings content ─────────────────────────────────────────────

  Widget _buildAccountSettingsContent() {
    final profile = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1 — Account Information
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Manage your account details to keep your account secure and up to date.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profile.email,
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              IthakiOutlineButton(
                'Change Email',
                icon: IthakiIcon('edit-pencil', size: 14),
                onPressed: () => _showChangeEmail(context),
              ),
              const SizedBox(height: 12),
              Divider(color: IthakiTheme.borderLight, thickness: 1),
              const SizedBox(height: 12),
              Text(
                'Phone Number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profile.phone,
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              IthakiOutlineButton(
                'Change Phone Number',
                icon: IthakiIcon('edit-pencil', size: 14),
                onPressed: () => _showChangePhone(context),
              ),
              const SizedBox(height: 12),
              Divider(color: IthakiTheme.borderLight, thickness: 1),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                'Change Password',
                icon: IthakiIcon('edit-pencil', size: 14),
                onPressed: () => _showChangePassword(context),
              ),
            ],
          ),
        ),

        // Card 2 — Profile Visibility
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Visibility',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    profile.profileVisible
                        ? IthakiIcon('eye', size: 14)
                        : IthakiIcon('eye-closed', size: 14),
                    const SizedBox(width: 4),
                    Text(
                      profile.profileVisible
                          ? 'Profile Visible for Employers'
                          : 'Profile Hidden from Employers',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Right now, employers can view your profile and send you invitations. If you prefer more privacy, you can hide your profile — it will only be visible when you apply to a job.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              profile.profileVisible
                  ? IthakiOutlineButton(
                      'Hide Profile from Employers',
                      icon: IthakiIcon('eye-closed', size: 14),
                      onPressed: () => _showMakeInvisible(context),
                    )
                  : IthakiOutlineButton(
                      'Show Profile to Employers',
                      icon: IthakiIcon('eye', size: 14),
                      onPressed: () => ref
                          .read(profileProvider.notifier)
                          .toggleProfileVisibility(),
                    ),
            ],
          ),
        ),

        // Card 3 — Digital Comfort
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Digital Comfort',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You are experienced tech user',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'You\'re using our full experience right now — perfect for confident tech users. If you ever want a simpler, easier interface, you can switch to the light version whenever you like.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                'Try Ithaki Lite',
                onPressed: () => _showSwitchLite(context),
              ),
            ],
          ),
        ),

        // Card 4 — Delete Account
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delete an Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Permanently remove your account and all related data from the system. This action cannot be undone.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                'Delete an Account',
                icon: IthakiIcon('delete', size: 14, color: Colors.red),
                onPressed: () => _showDeleteAccount(context),
                borderColor: Colors.red,
                foregroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Notifications content ────────────────────────────────────────────────

  Widget _buildNotificationsContent() {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final profile = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1 — Communication Channel
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Communication Channel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose a channel to get notifications about new relevant job openings and responses to submitted applications. You can select multiple options and change them anytime.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              IthakiOptionCard(
                showLeadingCheckbox: true,
                label: 'WhatsApp',
                subtitle: profile.phone.isNotEmpty ? profile.phone : null,
                isSelected: settings.whatsappEnabled,
                onTap: () => notifier.toggleChannel('whatsapp'),
              ),
              const SizedBox(height: 8),
              IthakiOptionCard(
                showLeadingCheckbox: true,
                label: 'SMS',
                subtitle: profile.phone.isNotEmpty ? profile.phone : null,
                isSelected: settings.smsEnabled,
                onTap: () => notifier.toggleChannel('sms'),
              ),
              const SizedBox(height: 8),
              IthakiOptionCard(
                showLeadingCheckbox: true,
                label: 'Push Notifications',
                isSelected: settings.pushEnabled,
                onTap: () => notifier.toggleChannel('push'),
              ),
            ],
          ),
        ),

        // Card 2 — Email Newsletter
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email Newsletter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Stay informed and make the most of your experience! Choose which types of updates and insights you\'d like to receive directly to your inbox.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 16),

              // Email badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: settings.emailNewsletterActive
                      ? IthakiTheme.backgroundViolet
                      : IthakiTheme.softGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: settings.emailNewsletterActive
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.lightGray,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    IthakiIcon(
                      'envelope',
                      size: 20,
                      color: settings.emailNewsletterActive
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Email Newsletter',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: settings.emailNewsletterActive
                            ? IthakiTheme.primaryPurple
                            : IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      settings.emailNewsletterActive
                          ? '(active)'
                          : '(inactive)',
                      style: const TextStyle(
                          fontSize: 12, color: IthakiTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Subscribe / Unsubscribe
              settings.emailNewsletterActive
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => notifier.unsubscribeNewsletter(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(
                              color: IthakiTheme.softGraphite),
                          foregroundColor: IthakiTheme.textPrimary,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Unsubscribe'),
                      ),
                    )
                  : IthakiButton(
                      'Subscribe',
                      onPressed: () {
                        notifier.subscribeNewsletter();
                        SuccessBanner.show(
                            context, 'Settings updated successfully.');
                      },
                    ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Newsletter topics
              for (final (type, subtitle) in _newsletterTopics) ...[
                IthakiOptionCard(
                  showLeadingCheckbox: true,
                  label: type,
                  subtitle: subtitle,
                  isSelected: settings.newsletterTypes.contains(type),
                  enabled: settings.emailNewsletterActive,
                  onTap: () => notifier.toggleNewsletterType(type),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ── Bottom sheet launchers ────────────────────────────────────────────────

  void _showChangeEmail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangeEmailSheet(parentContext: context),
    );
  }

  void _showChangePhone(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangePhoneSheet(parentContext: context),
    );
  }

  void _showChangePassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChangePasswordSheet(parentContext: context),
    );
  }

  void _showMakeInvisible(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MakeInvisibleSheet(parentContext: context),
    );
  }

  void _showSwitchLite(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SwitchLiteSheet(parentContext: context),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeleteAccountSheet(parentContext: context),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 1: Change Email
// ---------------------------------------------------------------------------

class _ChangeEmailSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const _ChangeEmailSheet({required this.parentContext});

  @override
  ConsumerState<_ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends ConsumerState<_ChangeEmailSheet> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return BottomSheetBase(
      title: 'Change Email',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update your email address',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            'Current Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiTextField(
            label: 'New Email',
            hint: 'Enter new email',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Update',
            onPressed: _emailCtrl.text.trim().isNotEmpty
                ? () {
                    Navigator.pop(context);
                    _showVerification(
                      widget.parentContext,
                      newValue: _emailCtrl.text,
                      isEmail: true,
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

// ---------------------------------------------------------------------------
// Sheet 2: Change Phone
// ---------------------------------------------------------------------------

class _ChangePhoneSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const _ChangePhoneSheet({required this.parentContext});

  @override
  ConsumerState<_ChangePhoneSheet> createState() => _ChangePhoneSheetState();
}

class _ChangePhoneSheetState extends ConsumerState<_ChangePhoneSheet> {
  final _phoneCtrl = TextEditingController();
  bool _valid = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return BottomSheetBase(
      title: 'Change Phone Number',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Phone Number',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.phone,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiPhoneField(
            controller: _phoneCtrl,
            label: 'New Phone Number',
            onValidationChanged: (v) => setState(() => _valid = v),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Update',
            onPressed: _valid
                ? () {
                    Navigator.pop(context);
                    _showVerification(
                      widget.parentContext,
                      newValue: _phoneCtrl.text,
                      isEmail: false,
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

// ---------------------------------------------------------------------------
// Sheet 3: Verification (OTP)
// ---------------------------------------------------------------------------

void _showVerification(
  BuildContext context, {
  required String newValue,
  required bool isEmail,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _VerificationSheet(
      newValue: newValue,
      isEmail: isEmail,
      parentContext: context,
    ),
  );
}

class _VerificationSheet extends StatefulWidget {
  final String newValue;
  final bool isEmail;
  final BuildContext parentContext;

  const _VerificationSheet({
    required this.newValue,
    required this.isEmail,
    required this.parentContext,
  });

  @override
  State<_VerificationSheet> createState() => _VerificationSheetState();
}

class _VerificationSheetState extends State<_VerificationSheet>
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
    return BottomSheetBase(
      title: 'Verification',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New ${widget.isEmail ? 'Email' : 'Phone Number'}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.newValue,
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'A 6-digit code was sent to your ${widget.isEmail ? 'phone via SMS' : 'email'}.',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
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
              fillColor: Colors.white,
              focusedBorderColor: IthakiTheme.primaryPurple,
              focusedFillColor: Colors.white,
              filledBorderColor: IthakiTheme.primaryPurple,
              filledFillColor: Colors.white,
              textStyle: TextStyle(
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
            label: 'Resend code',
            onResend: () => startCountdown(24),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Submit',
            onPressed: _otp.length == 6
                ? () {
                    Navigator.pop(context);
                    SuccessBanner.show(
                      widget.parentContext,
                      widget.isEmail
                          ? 'Your email has been changed.'
                          : 'Your phone number has been changed.',
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

// ---------------------------------------------------------------------------
// Sheet 4: Change Password
// ---------------------------------------------------------------------------

class _ChangePasswordSheet extends StatefulWidget {
  final BuildContext parentContext;
  const _ChangePasswordSheet({required this.parentContext});

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool get _hasUpperAndLower =>
      _newCtrl.text.contains(RegExp(r'[A-Z]')) &&
      _newCtrl.text.contains(RegExp(r'[a-z]'));
  bool get _hasLength => _newCtrl.text.length >= 8;
  bool get _hasNumber => _newCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _newCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  bool get _allRules =>
      _hasUpperAndLower && _hasLength && _hasNumber && _hasSpecial;
  bool get _passwordsMatch =>
      _newCtrl.text.isNotEmpty && _newCtrl.text == _confirmCtrl.text;

  @override
  void dispose() {
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Change Password',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change your password to keep your account secure',
            style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiPasswordField(
            label: 'New Password',
            hint: 'Enter your new password',
            controller: _newCtrl,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          IthakiValidationRow(
            text: 'Includes one uppercase and one lowercase letter',
            valid: _hasUpperAndLower,
          ),
          IthakiValidationRow(
            text: 'At least 8 characters',
            valid: _hasLength,
          ),
          IthakiValidationRow(
            text: 'Includes at least one number',
            valid: _hasNumber,
          ),
          IthakiValidationRow(
            text: r'Includes one special character (like !@#$%^&)',
            valid: _hasSpecial,
          ),
          const SizedBox(height: 12),
          IthakiPasswordField(
            label: 'Repeat New Password',
            hint: 'Repeat your new password',
            controller: _confirmCtrl,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Update',
            onPressed: _allRules && _passwordsMatch
                ? () {
                    Navigator.pop(context);
                    SuccessBanner.show(
                      widget.parentContext,
                      'Your password has been updated.',
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

// ---------------------------------------------------------------------------
// Sheet 5: Make Invisible
// ---------------------------------------------------------------------------

class _MakeInvisibleSheet extends ConsumerWidget {
  final BuildContext parentContext;
  const _MakeInvisibleSheet({required this.parentContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomSheetBase(
      title: 'Make your profile invisible?',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "If you make your profile invisible, employers won't be able to find you in candidate searches. You'll still be able to apply for jobs you're interested in. You can change your profile visibility anytime in your account settings.",
            style:
                TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: IthakiButton(
                  'Make Profile Invisible',
                  onPressed: () {
                    ref
                        .read(profileProvider.notifier)
                        .toggleProfileVisibility();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 6: Switch to Ithaki Lite
// ---------------------------------------------------------------------------

class _SwitchLiteSheet extends StatelessWidget {
  final BuildContext parentContext;
  const _SwitchLiteSheet({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Switch to Ithaki Lite?',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The interface will become simpler and easier to use. We'll show you only the jobs that best match your job interests.\nYou can switch back to the full interface at any time.",
            style:
                TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: IthakiTheme.softGraphite),
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: IthakiTheme.textPrimary,
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(height: 10),
          IthakiButton(
            'Switch to Ithaki Lite',
            onPressed: () {
              Navigator.pop(context);
              SuccessBanner.show(parentContext, 'Switched to Ithaki Lite.');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 7: Delete Account
// ---------------------------------------------------------------------------

class _DeleteAccountSheet extends StatefulWidget {
  final BuildContext parentContext;
  const _DeleteAccountSheet({required this.parentContext});

  @override
  State<_DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<_DeleteAccountSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _ctrl.text.toLowerCase() == 'delete';

    return BottomSheetBase(
      title: 'Confirm Account Deletion',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'To permanently delete your account, please type delete in the field below.\nThis action cannot be undone — all your data will be removed forever.',
            style:
                TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiTextField(
            label: "Type 'delete' to confirm",
            hint: 'Enter "delete"',
            controller: _ctrl,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: IthakiTheme.softGraphite),
                foregroundColor: IthakiTheme.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: canDelete
                  ? () {
                      Navigator.pop(context);
                      widget.parentContext.go('/tech-comfort');
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: canDelete ? Colors.red : Colors.grey.shade300),
                foregroundColor: canDelete ? Colors.red : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Delete Account'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
