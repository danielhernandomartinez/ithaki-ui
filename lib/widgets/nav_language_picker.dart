import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../utils/ithaki_bottom_sheet.dart';

const kNavLanguages = [
  (code: 'en', label: 'English', flag: 'GB'),
  (code: 'el', label: 'Ελληνικά', flag: 'GR'),
  (code: 'ar', label: 'العربية', flag: 'SA'),
  (code: 'es', label: 'Español', flag: 'ES'),
];

void showLanguagePicker(
  BuildContext context, {
  required String currentCode,
  required void Function(String code) onSelect,
}) {
  showIthakiBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    builder: (_) => NavLanguagePickerSheet(
      currentCode: currentCode,
      onSelect: (code) {
        onSelect(code);
        Navigator.of(context).pop();
      },
    ),
  );
}

class NavLanguageTile extends StatelessWidget {
  final String flagCode;
  final String label;
  final VoidCallback? onTap;

  const NavLanguageTile(
      {super.key, required this.flagCode, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            IthakiFlag(flagCode, width: 20, height: 20, oval: true),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: IthakiTheme.bodyRegular,
              ),
            ),
            const IthakiIcon(
              'arrow-down',
              size: 20,
              color: IthakiTheme.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class NavLanguagePickerSheet extends StatelessWidget {
  final String currentCode;
  final void Function(String code) onSelect;

  const NavLanguagePickerSheet(
      {super.key, required this.currentCode, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding + 16),
      child: Container(
        key: const ValueKey('language-picker-sheet'),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: IthakiTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            for (final lang in kNavLanguages) ...[
              _LangOption(
                lang: lang,
                selected: lang.code == currentCode,
                onTap: () => onSelect(lang.code),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _LangOption extends StatelessWidget {
  final ({String code, String label, String flag}) lang;
  final bool selected;
  final VoidCallback onTap;

  const _LangOption(
      {required this.lang, required this.selected, required this.onTap});

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
              const IthakiIcon('check',
                  size: 18, color: IthakiTheme.textPrimary),
          ],
        ),
      ),
    );
  }
}
