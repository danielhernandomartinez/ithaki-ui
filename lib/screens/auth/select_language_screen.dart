import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/registration_provider.dart';

Widget _flag(String code) => IthakiFlag(code);

final _languages = [
  SearchItem(id: 'en', label: 'English', leadingWidget: _flag('GB')),
  SearchItem(id: 'el', label: 'Ελληνικά (Greek)', leadingWidget: _flag('GR')),
  SearchItem(id: 'de', label: 'Deutsch (German)', leadingWidget: _flag('DE')),
  SearchItem(id: 'fr', label: 'Français (French)', leadingWidget: _flag('FR')),
  SearchItem(id: 'es', label: 'Español (Spanish)', leadingWidget: _flag('ES')),
  SearchItem(id: 'it', label: 'Italiano (Italian)', leadingWidget: _flag('IT')),
  SearchItem(id: 'pt', label: 'Português (Portuguese)', leadingWidget: _flag('PT')),
  SearchItem(id: 'ar', label: 'العربية (Arabic)', leadingWidget: _flag('SA')),
  SearchItem(id: 'zh', label: '中文 (Chinese)', leadingWidget: _flag('CN')),
];

class SelectLanguageScreen extends ConsumerStatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  ConsumerState<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends ConsumerState<SelectLanguageScreen> {
  SearchItem? _selected;

  void _openPicker() {
    final l = AppLocalizations.of(context)!;
    SearchBottomSheet.show(
      context,
      l.selectLanguageTitle,
      _languages,
      (item) => setState(() => _selected = item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: IthakiAppBar(actionLabel: l.loginAction, onActionPressed: () => context.go('/login-phone')),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.welcomeHeading,
              style: IthakiTheme.headingLarge,
            ),
            const SizedBox(height: 20),
            Text(l.selectLanguageTitle, style: IthakiTheme.sectionTitle),
            const SizedBox(height: 8),
            Text(
              l.selectLanguageDescription,
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 24),
            Text(
              l.languageLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _openPicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: IthakiTheme.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    if (_selected != null) ...[
                      _selected!.leadingWidget!,
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        _selected?.label ?? l.selectLanguagePlaceholder,
                        style: TextStyle(
                          fontSize: 14,
                          color: _selected != null
                              ? IthakiTheme.textPrimary
                              : IthakiTheme.textHint,
                        ),
                      ),
                    ),
                    const IthakiIcon(
                      'arrow-down',
                      size: 20,
                      color: IthakiTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            IthakiButton(
              l.continueButton,
              isEnabled: _selected != null,
              onPressed: _selected != null
                  ? () {
                      ref.read(registrationProvider.notifier).setLanguage(_selected!.id);
                      context.go('/tech-comfort');
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            IthakiButton(
              l.skipButton,
              variant: IthakiButtonVariant.outline,
              onPressed: () => context.go('/tech-comfort'),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
