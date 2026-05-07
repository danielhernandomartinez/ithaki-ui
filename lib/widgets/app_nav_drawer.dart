import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

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

const _kLanguages = [
  (code: 'en', label: 'English', flag: 'GB'),
  (code: 'el', label: 'Ελληνικά', flag: 'GR'),
  (code: 'ar', label: 'العربية', flag: 'SA'),
];

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
    // legacy params kept for call-site compatibility — ignored
    // ignore: avoid_unused_constructor_parameters
    String languageLabel = 'English',
    // ignore: avoid_unused_constructor_parameters
    String languageFlagCode = 'gb',
    // ignore: avoid_unused_constructor_parameters
    VoidCallback? onLanguageTap,
  });

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String currentCode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguagePickerSheet(
        currentCode: currentCode,
        onSelect: (code) {
          ref.read(localeProvider.notifier).setLocale(code);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final localeCode = ref.watch(localeProvider)?.languageCode ?? 'en';
    final lang = _kLanguages.firstWhere(
      (l) => l.code == localeCode,
      orElse: () => _kLanguages.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Nav Items ───────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

          // ─── Profile Completion ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ProfileCard(progress: profileProgress),
          ),
          const SizedBox(height: 12),

          // ─── Language Selector ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _LanguageTile(
              flagCode: lang.flag,
              label: lang.label,
              onTap: () => _showLanguagePicker(context, ref, localeCode),
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

  const _NavTile({required this.item, required this.selected, required this.onTap});

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
            color: selected ? IthakiTheme.badgeLime : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            children: [
              IthakiIcon(item.icon, size: 20, color: IthakiTheme.textPrimary),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              if (item.badge != null)
                Container(
                  width: 22,
                  height: 22,
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

// ─── Profile Completion Card ──────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final double progress;
  const _ProfileCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pct = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.placeholderBg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.homeProfileCompleteYourProfile,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: 20,
              child: Stack(
                children: [
                  // Hatched background
                  CustomPaint(
                    size: const Size(double.infinity, 20),
                    painter: _HatchPainter(),
                  ),
                  // Green filled bar
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCFF00),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  // Percentage always visible on top
                  Positioned(
                    left: 10,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        '$pct%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = IthakiTheme.placeholderBg,
    );
    final paint = Paint()
      ..color = const Color(0xFFCCCCCC)
      ..strokeWidth = 1.5;
    const spacing = 8.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter old) => false;
}

// ─── Language Tile ────────────────────────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  final String flagCode;
  final String label;
  final VoidCallback? onTap;

  const _LanguageTile({required this.flagCode, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          IthakiFlag(flagCode, width: 28, height: 20, oval: true),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 20, color: IthakiTheme.textSecondary),
        ],
      ),
    );
  }
}

// ─── Language Picker Sheet ────────────────────────────────────────────────────

class _LanguagePickerSheet extends StatelessWidget {
  final String currentCode;
  final void Function(String code) onSelect;

  const _LanguagePickerSheet({required this.currentCode, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: IthakiTheme.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          for (final lang in _kLanguages) ...[
            _LangOption(
              lang: lang,
              selected: lang.code == currentCode,
              onTap: () => onSelect(lang.code),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final ({String code, String label, String flag}) lang;
  final bool selected;
  final VoidCallback onTap;

  const _LangOption({required this.lang, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? IthakiTheme.badgeLime : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            IthakiFlag(lang.flag, width: 28, height: 20, oval: true),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                lang.label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
            if (selected)
              const IthakiIcon('check', size: 18, color: IthakiTheme.textPrimary),
          ],
        ),
      ),
    );
  }
}
