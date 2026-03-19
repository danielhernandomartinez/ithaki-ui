import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  SearchItem? _selected;

  void _openPicker() {
    SearchBottomSheet.show(
      context,
      'Select Language',
      _languages,
      (item) => setState(() => _selected = item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IthakiAppBar(actionLabel: "Login", onActionPressed: () => context.go('/login')),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Ithaki!\nLet\'s create an Account!',
              style: IthakiTheme.headingLarge,
            ),
            const SizedBox(height: 20),
            const Text('Select your Language', style: IthakiTheme.sectionTitle),
            const SizedBox(height: 8),
            const Text(
              'You can change the interface language at any time. All content, '
              'including the job description, your resume, and communication with '
              'consultants and the chatbot, will be in English.',
              style: IthakiTheme.bodyRegular,
            ),
            const SizedBox(height: 24),
            const Text(
              'Language',
              style: TextStyle(
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
                    color: _selected != null
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.borderLight,
                    width: _selected != null ? 1.5 : 1,
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
                        _selected?.label ?? 'Select your language',
                        style: TextStyle(
                          fontSize: 14,
                          color: _selected != null
                              ? IthakiTheme.textPrimary
                              : IthakiTheme.textHint,
                        ),
                      ),
                    ),
                    IthakiIcon(
                      _selected != null ? 'check' : 'arrow-down',
                      size: 20,
                      color: _selected != null
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            IthakiButton(
              'Continue',
              isEnabled: _selected != null,
              onPressed: _selected != null ? () => context.go('/tech-comfort') : null,
            ),
            const SizedBox(height: 12),
            IthakiButton(
              'Skip',
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
