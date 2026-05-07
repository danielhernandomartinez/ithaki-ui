import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(profileBasicsProvider).value;
    final profileVisible = ref.watch(profileVisibleProvider).value ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1 — Account Information
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.accountInformationTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.accountInformationSubtitle,
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profile?.email ?? '',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              IthakiOutlineButton(
                l10n.changeEmailTitle,
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
                l10n.phoneNumberLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profile?.phone ?? '',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              IthakiOutlineButton(
                l10n.changePhoneTitle,
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
                l10n.changePasswordTitle,
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
                l10n.profileVisibilityTitle,
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
                          ? l10n.profileVisibleForEmployers
                          : l10n.profileHiddenFromEmployers,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.profileVisibilityDescription,
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              profileVisible
                  ? IthakiOutlineButton(
                      l10n.hideProfileFromEmployers,
                      onPressed: () => _showSheet(
                        context,
                        const MakeInvisibleSheet(),
                      ),
                    )
                  : IthakiOutlineButton(
                      l10n.showProfileToEmployers,
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
                l10n.digitalComfortTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.digitalComfortExperienced,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.digitalComfortDescription,
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                l10n.tryIthakiLite,
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
              Text(
                l10n.deleteAnAccount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.deleteAccountTabDescription,
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                l10n.deleteAnAccount,
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
