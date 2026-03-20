import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../providers/registration_provider.dart';

Widget _flag(String code) => IthakiFlag(code);

final _languages = [
  SearchItem(id: 'en', label: 'English', leadingWidget: _flag('GB')),
  SearchItem(id: 'el', label: 'Ελληνικά (Greek)', leadingWidget: _flag('GR')),
  SearchItem(id: 'ar', label: 'العربية (Arabic)', leadingWidget: _flag('SA')),
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
      (item) {
        setState(() => _selected = item);
        ref.read(localeProvider.notifier).setLocale(item.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(actionLabel: l.loginAction, onActionPressed: () => context.go('/login-phone')),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24, right: 24, top: topOffset + 20, bottom: 20),
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
                      context.push('/tech-comfort');
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            IthakiButton(
              l.skipButton,
              variant: IthakiButtonVariant.outline,
              onPressed: () => context.pushReplacement('/tech-comfort'),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
