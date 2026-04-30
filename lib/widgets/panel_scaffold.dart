import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../providers/profile_provider.dart';
import '../routes.dart';
import '../utils/profile_photo_image.dart';

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
    final basics = ref.watch(profileBasicsProvider).value;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ProfileEditAppBar(
              avatarInitials: basics?.initials ?? 'AA',
              avatarUrl: basics?.photoUrl,
              onNotificationsTap: () =>
                  context.push(Routes.settingsNotifications),
              onBack: () => context.pop(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
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
                      IthakiButton('Save', onPressed: onSave),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileEditAppBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final avatarImage = profilePhotoImageProvider(avatarUrl);

    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: [
                  IthakiIcon('back-chevron',
                      size: 18, color: IthakiTheme.textPrimary),
                  SizedBox(width: 4),
                  Text(
                    'Back',
                    style:
                        TextStyle(fontSize: 16, color: IthakiTheme.textPrimary),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Ithaki',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const IthakiIcon('notifications-bell',
                size: 22, color: IthakiTheme.textPrimary),
            onPressed: onNotificationsTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 16,
            backgroundColor: IthakiTheme.successGreen,
            backgroundImage: avatarImage,
            child: avatarImage == null
                ? Text(
                    avatarInitials,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: IthakiTheme.foregroundWhite,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
