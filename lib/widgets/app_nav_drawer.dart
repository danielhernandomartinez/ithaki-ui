import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/locale_provider.dart';
import 'nav_language_picker.dart';
import 'nav_profile_card.dart';

class NavItem {
  final String icon;
  final String label;
  final String route;
  final int? badge;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.badge,
  });
}

class AppNavDrawer extends ConsumerWidget {
  final String currentRoute;
  final List<NavItem> items;
  final double profileProgress;
  final void Function(NavItem item)? onItemTap;

  const AppNavDrawer({
    super.key,
    required this.currentRoute,
    required this.items,
    this.profileProgress = 0.25,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final selectedLocaleCode = ref.watch(localeProvider).value?.languageCode;
    final resolvedLocaleCode =
        selectedLocaleCode ?? Localizations.localeOf(context).languageCode;
    final localeCode = kNavLanguages.any((l) => l.code == resolvedLocaleCode)
        ? resolvedLocaleCode
        : 'en';
    final lang = kNavLanguages.firstWhere(
      (l) => l.code == localeCode,
      orElse: () => kNavLanguages.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final selected = item.route == currentRoute;
                return _NavTile(
                  item: item,
                  selected: selected,
                  onTap: () => onItemTap?.call(item),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: NavProfileCard(progress: profileProgress),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: NavLanguageTile(
              flagCode: lang.flag,
              label: lang.label,
              onTap: () => showLanguagePicker(
                context,
                currentCode: localeCode,
                onSelect: (code) =>
                    ref.read(localeProvider.notifier).setLocale(code),
              ),
            ),
          ),
          SizedBox(height: bottomPadding + 16),
        ],
      ),
    );
  }
}

// ─── Nav Tile ─────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavTile(
      {required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? IthakiTheme.badgeLime : IthakiTheme.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              IthakiIcon(
                item.icon,
                size: 20,
                color:
                    selected ? IthakiTheme.textPrimary : IthakiTheme.graphite,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: IthakiTheme.bodyRegular.copyWith(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (item.badge != null)
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: IthakiTheme.textPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${item.badge}',
                    style: const TextStyle(
                      color: IthakiTheme.backgroundWhite,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
