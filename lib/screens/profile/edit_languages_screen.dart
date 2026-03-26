import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';

const _kProficiencyLevels = [
  'Native',
  'Fluent',
  'Advanced',
  'Conversational',
  'Basic',
];

const _kLanguages = [
  'English',
  'Greek',
  'Spanish',
  'French',
  'German',
  'Italian',
  'Arabic',
  'Chinese',
];

class EditLanguagesScreen extends ConsumerStatefulWidget {
  const EditLanguagesScreen({super.key});

  @override
  ConsumerState<EditLanguagesScreen> createState() =>
      _EditLanguagesScreenState();
}

class _EditLanguagesScreenState extends ConsumerState<EditLanguagesScreen> {
  List<String> _langs = [];
  List<String> _levels = [];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(profileSkillsProvider).languages;
    _langs = saved.map((l) => l.language).toList();
    _levels = saved.map((l) => l.proficiency).toList();
    if (_langs.isEmpty) _addEntry();
  }

  void _addEntry() {
    setState(() {
      _langs.add('');
      _levels.add('');
    });
  }

  void _removeEntry(int i) {
    setState(() {
      _langs.removeAt(i);
      _levels.removeAt(i);
    });
  }

  String _langCode(String language) {
    const map = {
      'English': 'gb',
      'Greek': 'gr',
      'Spanish': 'es',
      'French': 'fr',
      'German': 'de',
      'Italian': 'it',
      'Arabic': 'sa',
      'Chinese': 'cn',
    };
    return map[language] ?? 'gr';
  }

  void _showLanguagePicker(int i) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: mq.size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const Text('Select Language',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: _kLanguages
                        .map((lang) => ListTile(
                              leading: IthakiFlag(_langCode(lang),
                                  width: 24, height: 24),
                              title: Text(lang),
                              onTap: () {
                                setState(() => _langs[i] = lang);
                                Navigator.of(context).pop();
                              },
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _save() {
    final langs = List.generate(_langs.length, (i) {
      return Language(language: _langs[i], proficiency: _levels[i]);
    }).where((l) => l.language.isNotEmpty && l.proficiency.isNotEmpty).toList();
    ref.read(profileSkillsProvider.notifier).updateLanguages(langs);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Edit Languages'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.viewPaddingOf(context).bottom + 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < _langs.length; i++) ...[
                if (i > 0) const Divider(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: IthakiTextField(
                        label: 'Language',
                        hint: 'Select language',
                        controller: TextEditingController(text: _langs[i]),
                        readOnly: true,
                        onTap: () => _showLanguagePicker(i),
                        suffixIcon: _langs[i].isNotEmpty
                            ? IthakiFlag(_langCode(_langs[i]),
                                width: 22, height: 22)
                            : const IthakiIcon('arrow-down',
                                size: 20, color: IthakiTheme.textSecondary),
                      ),
                    ),
                    if (_langs.length > 1) ...[
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: IthakiTheme.softGraphite),
                          onPressed: () => _removeEntry(i),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Proficiency Level',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _kProficiencyLevels.map((level) {
                    final isSelected = _levels[i] == level;
                    return GestureDetector(
                      onTap: () => setState(() => _levels[i] = level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? IthakiTheme.primaryPurple
                                : IthakiTheme.borderLight,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(Icons.check,
                                  size: 14,
                                  color: IthakiTheme.primaryPurple),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              level,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? IthakiTheme.primaryPurple
                                    : IthakiTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _addEntry,
                icon: const IthakiIcon('plus', size: 16),
                label: const Text('Add Another Language'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: IthakiTheme.softGraphite),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  foregroundColor: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
