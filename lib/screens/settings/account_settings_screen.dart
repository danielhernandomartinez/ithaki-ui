import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/bottom_sheet_base.dart';
import '../../widgets/success_banner.dart';

// ---------------------------------------------------------------------------
// Main screen
// ---------------------------------------------------------------------------

class AccountSettingsScreen extends ConsumerWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: IthakiTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: IthakiTheme.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Section 1: Account ----
            _SectionLabel('ACCOUNT'),
            _Card(
              children: [
                ListTile(
                  title: const Text('Email',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                  subtitle: Text(profile.email,
                      style: const TextStyle(
                          color: IthakiTheme.textSecondary, fontSize: 13)),
                  trailing:
                      const Icon(Icons.chevron_right, color: IthakiTheme.softGraphite),
                  onTap: () => _showChangeEmail(context),
                ),
                _Divider(),
                ListTile(
                  title: const Text('Phone',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                  subtitle: Text(profile.phone,
                      style: const TextStyle(
                          color: IthakiTheme.textSecondary, fontSize: 13)),
                  trailing:
                      const Icon(Icons.chevron_right, color: IthakiTheme.softGraphite),
                  onTap: () => _showChangePhone(context),
                ),
                _Divider(),
                ListTile(
                  title: const Text('Password',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                  trailing:
                      const Icon(Icons.chevron_right, color: IthakiTheme.softGraphite),
                  onTap: () => _showChangePassword(context),
                ),
              ],
            ),

            // ---- Section 2: Profile Visibility ----
            _SectionLabel('PROFILE'),
            _Card(
              children: [
                SwitchListTile(
                  title: const Text('Profile Visibility',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                  subtitle: Text(
                    profile.profileVisible
                        ? 'Your profile is public'
                        : 'Your profile is invisible',
                    style: const TextStyle(
                        color: IthakiTheme.textSecondary, fontSize: 13),
                  ),
                  value: profile.profileVisible,
                  activeThumbColor: IthakiTheme.primaryPurple,
                  onChanged: (val) {
                    if (!val) {
                      _showMakeInvisible(context);
                    } else {
                      ref.read(profileProvider.notifier).toggleProfileVisibility();
                    }
                  },
                ),
              ],
            ),

            // ---- Section 3: Subscriptions ----
            _SectionLabel('SUBSCRIPTIONS'),
            _Card(
              children: [
                ListTile(
                  title: const Text('Switch to Lite',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                  trailing:
                      const Icon(Icons.chevron_right, color: IthakiTheme.softGraphite),
                  onTap: () => _showSwitchLite(context),
                ),
                _Divider(),
                ListTile(
                  title: const Text('Notifications',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                  trailing:
                      const Icon(Icons.chevron_right, color: IthakiTheme.softGraphite),
                  onTap: () => context.push('/settings/notifications'),
                ),
              ],
            ),

            // ---- Section 4: Danger Zone ----
            _SectionLabel('DANGER ZONE'),
            _Card(
              children: [
                ListTile(
                  title: const Text('Delete Account',
                      style: TextStyle(color: Colors.red)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () => _showDeleteAccountStep1(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers used by the screen
// ---------------------------------------------------------------------------

void _showChangeEmail(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChangeEmailSheet(),
  );
}

void _showChangePhone(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChangePhoneSheet(),
  );
}

void _showChangePassword(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChangePasswordSheet(),
  );
}

void _showVerification(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _VerificationSheet(),
  );
}

void _showMakeInvisible(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _MakeInvisibleSheet(),
  );
}

void _showSwitchLite(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _SwitchLiteSheet(parentContext: context),
  );
}

void _showDeleteAccountStep1(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DeleteAccountStep1Sheet(parentContext: context),
  );
}

void _showDeleteAccountStep2(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _DeleteAccountStep2Sheet(parentContext: context),
  );
}

// ---------------------------------------------------------------------------
// Shared small widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1,
          color: IthakiTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 16, endIndent: 16,
        color: IthakiTheme.borderLight);
  }
}

// ---------------------------------------------------------------------------
// Sheet 1: Change Email
// ---------------------------------------------------------------------------

class _ChangeEmailSheet extends StatefulWidget {
  const _ChangeEmailSheet();

  @override
  State<_ChangeEmailSheet> createState() => _ChangeEmailSheetState();
}

class _ChangeEmailSheetState extends State<_ChangeEmailSheet> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Change Email',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('New email address'),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Send Verification Code',
            onPressed: () {
              Navigator.of(context).pop();
              _showVerification(context);
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 2: Change Phone
// ---------------------------------------------------------------------------

class _ChangePhoneSheet extends StatefulWidget {
  const _ChangePhoneSheet();

  @override
  State<_ChangePhoneSheet> createState() => _ChangePhoneSheetState();
}

class _ChangePhoneSheetState extends State<_ChangePhoneSheet> {
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Change Phone',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('New phone number'),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Send Verification Code',
            onPressed: () {
              Navigator.of(context).pop();
              SuccessBanner.show(context, 'Verification code sent.');
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 3: Change Password
// ---------------------------------------------------------------------------

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool get _hasLength => _newCtrl.text.length >= 8;
  bool get _hasUpper => _newCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _newCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial => _newCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  bool get _allRules => _hasLength && _hasUpper && _hasNumber && _hasSpecial;
  bool get _passwordsMatch =>
      _newCtrl.text.isNotEmpty && _newCtrl.text == _confirmCtrl.text;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Change Password',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _currentCtrl,
            obscureText: true,
            decoration: _inputDecoration('Current password'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newCtrl,
            obscureText: true,
            decoration: _inputDecoration('New password'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          _PasswordRule('At least 8 characters', _hasLength),
          _PasswordRule('At least one uppercase letter', _hasUpper),
          _PasswordRule('At least one number', _hasNumber),
          _PasswordRule('At least one special character', _hasSpecial),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmCtrl,
            obscureText: true,
            decoration: _inputDecoration('Confirm new password'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Change Password',
            onPressed: (_allRules && _passwordsMatch)
                ? () {
                    Navigator.of(context).pop();
                    SuccessBanner.show(context, 'Password changed successfully.');
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _PasswordRule extends StatelessWidget {
  final String label;
  final bool satisfied;
  const _PasswordRule(this.label, this.satisfied);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '• $label',
        style: TextStyle(
          fontSize: 12,
          color: satisfied ? Colors.green : IthakiTheme.textSecondary,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 4: Verification
// ---------------------------------------------------------------------------

class _VerificationSheet extends StatefulWidget {
  const _VerificationSheet();

  @override
  State<_VerificationSheet> createState() => _VerificationSheetState();
}

class _VerificationSheetState extends State<_VerificationSheet> {
  final _codeCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Verify Your Identity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Enter the 6-digit code sent to your email/phone.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeCtrl,
            maxLength: 6,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
                color: IthakiTheme.textPrimary),
            decoration: _inputDecoration('').copyWith(counterText: ''),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Confirm',
            onPressed: _codeCtrl.text.length == 6
                ? () {
                    Navigator.of(context).pop();
                    SuccessBanner.show(context, 'Updated successfully.');
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 5: Make Invisible
// ---------------------------------------------------------------------------

class _MakeInvisibleSheet extends StatelessWidget {
  const _MakeInvisibleSheet();

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Make Profile Invisible',
      child: Consumer(
        builder: (context, ref, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Your profile will be hidden from search results and employers.',
              style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: IthakiTheme.textPrimary,
                      side: const BorderSide(color: IthakiTheme.borderLight),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: IthakiButton(
                    'Confirm',
                    onPressed: () {
                      ref
                          .read(profileProvider.notifier)
                          .toggleProfileVisibility();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 6: Switch to Lite
// ---------------------------------------------------------------------------

class _SwitchLiteSheet extends StatelessWidget {
  final BuildContext parentContext;
  const _SwitchLiteSheet({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Switch to Lite',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text(
            'The Lite plan offers basic features with limited profile visibility. '
            'Downgrading will take effect at the end of your billing cycle.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          IthakiButton(
            'Confirm Downgrade',
            onPressed: () {
              Navigator.of(context).pop();
              SuccessBanner.show(
                  parentContext, 'You have switched to the Lite plan.');
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 7: Delete Account Step 1
// ---------------------------------------------------------------------------

class _DeleteAccountStep1Sheet extends StatelessWidget {
  final BuildContext parentContext;
  const _DeleteAccountStep1Sheet({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Delete Account',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Are you sure you want to delete your account? This action is irreversible.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel',
                      style: TextStyle(color: IthakiTheme.textPrimary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDeleteAccountStep2(parentContext);
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sheet 8: Delete Account Step 2
// ---------------------------------------------------------------------------

class _DeleteAccountStep2Sheet extends StatefulWidget {
  final BuildContext parentContext;
  const _DeleteAccountStep2Sheet({required this.parentContext});

  @override
  State<_DeleteAccountStep2Sheet> createState() =>
      _DeleteAccountStep2SheetState();
}

class _DeleteAccountStep2SheetState extends State<_DeleteAccountStep2Sheet> {
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Confirm Deletion',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Enter your password to confirm account deletion.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordCtrl,
            obscureText: true,
            decoration: _inputDecoration('Password'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          IthakiButton(
            'Delete My Account',
            onPressed: _passwordCtrl.text.isNotEmpty
                ? () {
                    Navigator.of(context).pop();
                    widget.parentContext.go('/tech-comfort');
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared decoration helper
// ---------------------------------------------------------------------------

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: IthakiTheme.softGraphite, fontSize: 14),
    filled: true,
    fillColor: const Color(0xFFF7F7F8),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: IthakiTheme.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: IthakiTheme.borderLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: IthakiTheme.primaryPurple),
    ),
  );
}
