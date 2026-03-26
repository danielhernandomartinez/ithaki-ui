import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../providers/profile_provider.dart';
import '../sheets/change_email_sheet.dart';
import '../sheets/change_password_sheet.dart';
import '../sheets/change_phone_sheet.dart';
import '../sheets/delete_account_sheet.dart';
import '../sheets/make_invisible_sheet.dart';
import '../sheets/switch_lite_sheet.dart';

class AccountSettingsTab extends ConsumerWidget {
  const AccountSettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileBasicsProvider);
    final profileVisible = ref.watch(profileVisibleProvider);

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
                onPressed: () => _showSheet(
                  context,
                  ChangeEmailSheet(parentContext: context),
                ),
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
                onPressed: () => _showSheet(
                  context,
                  ChangePhoneSheet(parentContext: context),
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: IthakiTheme.borderLight, thickness: 1),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                'Change Password',
                icon: IthakiIcon('edit-pencil', size: 14),
                onPressed: () => _showSheet(
                  context,
                  ChangePasswordSheet(parentContext: context),
                ),
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
                    profileVisible
                        ? IthakiIcon('eye', size: 14)
                        : IthakiIcon('eye-closed', size: 14),
                    const SizedBox(width: 4),
                    Text(
                      profileVisible
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
              profileVisible
                  ? IthakiOutlineButton(
                      'Hide Profile from Employers',
                      onPressed: () => _showSheet(
                        context,
                        const MakeInvisibleSheet(),
                      ),
                    )
                  : IthakiOutlineButton(
                      'Show Profile to Employers',
                      icon: IthakiIcon('eye', size: 14),
                      onPressed: () =>
                          ref.read(profileVisibleProvider.notifier).toggle(),
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
                "You're using our full experience right now — perfect for confident tech users. If you ever want a simpler, easier interface, you can switch to the light version whenever you like.",
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                'Try Ithaki Lite',
                onPressed: () => _showSheet(
                  context,
                  SwitchLiteSheet(parentContext: context),
                ),
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
                onPressed: () => _showSheet(
                  context,
                  DeleteAccountSheet(parentContext: context),
                ),
                borderColor: Colors.red,
                foregroundColor: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSheet(BuildContext context, Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => sheet,
    );
  }
}
