import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';

class EditLanguagesScreen extends ConsumerStatefulWidget {
  const EditLanguagesScreen({super.key});

  @override
  ConsumerState<EditLanguagesScreen> createState() =>
      _EditLanguagesScreenState();
}

class _EditLanguagesScreenState extends ConsumerState<EditLanguagesScreen> {
  List<Language> _languages = [];
  List<TextEditingController> _langCtrls = [];
  List<String> _levels = [];

  @override
  void initState() {
    super.initState();
    final langs = ref.read(profileProvider).languages;
    _languages = List.from(langs);
    _langCtrls =
        langs.map((l) => TextEditingController(text: l.language)).toList();
    _levels = langs.map((l) => l.proficiency).toList();
    if (_languages.isEmpty) _addEntry();
  }

  @override
  void dispose() {
    for (final c in _langCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addEntry() {
    setState(() {
      _languages.add(const Language(language: '', proficiency: ''));
      _langCtrls.add(TextEditingController());
      _levels.add('');
    });
  }

  void _removeEntry(int i) {
    setState(() {
      _languages.removeAt(i);
      _langCtrls[i].dispose();
      _langCtrls.removeAt(i);
      _levels.removeAt(i);
    });
  }

  void _showLanguagePicker(int i) {
    const commonLanguages = [
      'English',
      'Greek',
      'Spanish',
      'French',
      'German',
      'Italian',
      'Arabic',
      'Chinese',
    ];
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...commonLanguages.map(
            (lang) => ListTile(
              title: Text(lang),
              onTap: () {
                setState(() => _langCtrls[i].text = lang);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _langCodeFor(String language) {
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

  void _save() {
    final langs = List.generate(
      _languages.length,
      (i) => Language(
        language: _langCtrls[i].text.trim(),
        proficiency: _levels[i],
      ),
    ).where((l) => l.language.isNotEmpty && l.proficiency.isNotEmpty).toList();
    ref.read(profileProvider.notifier).updateLanguages(langs);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Languages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _languages.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _langCtrls[i],
                          readOnly: true,
                          onTap: () => _showLanguagePicker(i),
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: IthakiFlag(
                                _langCtrls[i].text.isNotEmpty
                                    ? _langCodeFor(_langCtrls[i].text)
                                    : 'gr',
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: IthakiTheme.primaryPurple,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Proficiency Level',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _levels[i].isNotEmpty
                                    ? _levels[i]
                                    : null,
                                onChanged: (v) =>
                                    setState(() => _levels[i] = v ?? ''),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                items: [
                                  'Native',
                                  'Fluent',
                                  'Advanced',
                                  'Conversational',
                                  'Basic',
                                ]
                                    .map(
                                      (o) => DropdownMenuItem(
                                        value: o,
                                        child: Text(o),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: IthakiTheme.softGraphite,
                              ),
                              onPressed: () => _removeEntry(i),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                      ],
                    ),
                  OutlinedButton(
                    onPressed: _addEntry,
                    child: const Text('+ Add Another Language'),
                  ),
                  const SizedBox(height: 16),
                  IthakiButton('Save', onPressed: _save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
