import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../l10n/app_localizations.dart';
import 'tabs/account_settings_tab.dart';
import 'tabs/notifications_tab.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const SettingsScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late int _tabIndex;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        title: _tabIndex == 0 ? l10n.accountSettings : l10n.notificationsLabel,
      ),
      body: Column(
        children: [
          _buildTabBar(l10n),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.viewPaddingOf(context).bottom + 32),
                  child: const AccountSettingsTab(),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.viewPaddingOf(context).bottom + 32),
                  child: const NotificationsTab(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(child: _tabPill(l10n.accountSettings, 0)),
          const SizedBox(width: 6),
          Expanded(child: _tabPill(l10n.notificationsLabel, 1)),
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
          color:
              selected ? IthakiTheme.backgroundWhite : Colors.transparent,
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
}
