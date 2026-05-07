import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import '../routes.dart';

class ProfileMenuItem {
  final String icon;
  final String label;
  final String route;

  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class ProfileMenuPanel extends StatelessWidget {
  final void Function(ProfileMenuItem item)? onItemTap;
  final VoidCallback? onLogOut;

  static List<ProfileMenuItem> _items(AppLocalizations l) => [
        ProfileMenuItem(
            icon: 'profile', label: l.profileMenuMyProfile, route: '/profile'),
        ProfileMenuItem(
            icon: 'resume', label: l.profileMenuMyCv, route: Routes.cv),
        ProfileMenuItem(
            icon: 'settings', label: l.accountSettings, route: '/settings'),
      ];

  const ProfileMenuPanel({super.key, this.onItemTap, this.onLogOut});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Menu Items ──────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _items(l)
                  .map((item) => _ProfileTile(
                        item: item,
                        onTap: () => onItemTap?.call(item),
                      ))
                  .toList(),
            ),
          ),

          // ─── Log Out ─────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 1, color: IthakiTheme.borderLight),
          ),
          _ProfileTile(
            item: const ProfileMenuItem(icon: 'log-out', label: '', route: ''),
            labelOverride: l.logOut,
            onTap: onLogOut ?? () {},
          ),
          SizedBox(height: bottomPadding + 16),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final ProfileMenuItem item;
  final String? labelOverride;
  final VoidCallback onTap;

  const _ProfileTile(
      {required this.item, this.labelOverride, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              IthakiIcon(item.icon, size: 20, color: IthakiTheme.textPrimary),
              const SizedBox(width: 14),
              Text(
                labelOverride ?? item.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
