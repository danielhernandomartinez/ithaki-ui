import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../routes.dart';

/// Shared scaffold for profile edit screens:
/// violet background + app bar + scrollable white rounded panel + Save button.
class PanelScaffold extends ConsumerWidget {
  const PanelScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
  });

  final String title;
  final List<Widget> children;

  /// Passed directly to [IthakiButton]; null disables the button.
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final basics = ref.watch(profileBasicsProvider).value;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: ProfileEditAppBar(
        avatarInitials: basics?.initials ?? 'AA',
        avatarUrl: basics?.photoUrl,
        onNotificationsTap: () => context.push(Routes.settingsNotifications),
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.paddingOf(context).top + kToolbarHeight + 24,
            bottom: MediaQuery.viewPaddingOf(context).bottom + 16,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children,
                const SizedBox(height: 28),
                IthakiButton(l.save, onPressed: onSave),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileEditAppBar({
    super.key,
    required this.onBack,
    this.avatarInitials = 'AA',
    this.avatarUrl,
    this.onNotificationsTap,
  });

  final VoidCallback onBack;
  final String avatarInitials;
  final String? avatarUrl;
  final VoidCallback? onNotificationsTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context) {
    return IthakiAppBar(
      showMenuAndAvatar: true,
      showBackButton: true,
      title: AppLocalizations.of(context)!.appBarTitleIthaki,
      avatarInitials: avatarInitials,
      avatarUrl: avatarUrl,
      onMenuPressed: onBack,
      onNotificationsPressed: onNotificationsTap,
    );
  }
}
