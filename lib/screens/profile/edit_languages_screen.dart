import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/profile_provider.dart';
import '../../providers/reference_data_provider.dart';
import '../../widgets/panel_scaffold.dart';

const _kProficiencyLevels = [
  'Native',
  'Fluent',
  'Advanced',
  'Conversational',
  'Basic',
];

class EditLanguagesScreen extends ConsumerStatefulWidget {
  const EditLanguagesScreen({super.key});

  @override
  ConsumerState<EditLanguagesScreen> createState() => _EditLanguagesScreenState();
}

class _EditLanguagesScreenState extends ConsumerState<EditLanguagesScreen> {
  final List<String> _langs = [];
  final List<String> _levels = [];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(profileSkillsProvider).requireValue.languages;
    _langs.addAll(saved.map((l) => l.language));
    _levels.addAll(saved.map((l) => l.proficiency));
    if (_langs.isEmpty) _addEntry();
  }

  void _addEntry() {
    setState(() {
      _langs.add('');
      _levels.add('');
    });
  }

  void _removeEntry(int index) {
    setState(() {
      _langs.removeAt(index);
      _levels.removeAt(index);
    });
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget _buildLanguageIcon(String language, {double size = 20}) {
    return IthakiLanguageFlag(language, size: size);
  }

  void _showLanguagePicker(int index, List<String> availableLanguages) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: IthakiTheme.backgroundWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: IthakiTheme.borderLight,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: availableLanguages.length,
                  itemBuilder: (context, itemIndex) {
                    final lang = availableLanguages[itemIndex];
                    return ListTile(
                      leading: _buildLanguageIcon(lang, size: 22),
                      title: Text(lang),
                      onTap: () {
                        setState(() => _langs[index] = lang);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final langs = List.generate(
      _langs.length,
      (i) => Language(language: _langs[i], proficiency: _levels[i]),
    ).where((l) => l.language.isNotEmpty && l.proficiency.isNotEmpty).toList();

    try {
      await ref.read(profileSkillsProvider.notifier).updateLanguages(langs);
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    }
  }

  Widget _buildStatusBanner(AsyncValue<List<LanguageItem>> langsAsync) {
    if (langsAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: LinearProgressIndicator(minHeight: 2),
      );
    }
    if (!langsAsync.hasError) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: IthakiTheme.borderLight),
        ),
        child: Text(
          langsAsync.error.toString(),
          style: IthakiTheme.captionRegular,
        ),
      ),
    );
  }

  Widget _buildLanguageField(
    int index,
    List<String> availableLanguages,
    bool isLoadingLanguages,
  ) {
    return IthakiTextField(
      label: 'Language',
      hint: 'Select language',
      controller: TextEditingController(text: _langs[index]),
      readOnly: true,
      onTap: () {
        if (isLoadingLanguages) {
          _showMessage('Loading languages...');
          return;
        }
        if (availableLanguages.isEmpty) {
          _showMessage('No languages available right now.');
          return;
        }
        _showLanguagePicker(index, availableLanguages);
      },
      suffixIcon: const SizedBox(
        width: 28,
        child: Center(
          child: IthakiIcon(
            'arrow-down',
            size: 18,
            color: IthakiTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildProficiencyRow(int index) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _kProficiencyLevels.map((level) {
        final isSelected = _levels[index] == level;
        return GestureDetector(
          onTap: () => setState(() => _levels[index] = level),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(Icons.check, size: 14, color: IthakiTheme.primaryPurple),
                  const SizedBox(width: 4),
                ],
                Text(
                  level,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langsAsync = ref.watch(languagesListProvider);
    final availableLanguages = langsAsync.value?.map((l) => l.name).toList() ?? const [];
    final isLoadingLanguages = langsAsync.isLoading;

    return PanelScaffold(
      title: 'Edit Languages',
      onSave: _save,
      children: [
        _buildStatusBanner(langsAsync),
        for (int i = 0; i < _langs.length; i++) ...[
          if (i > 0) const Divider(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildLanguageField(i, availableLanguages, isLoadingLanguages),
              ),
              if (_langs.length > 1) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: IthakiTheme.softGraphite),
                    onPressed: () => _removeEntry(i),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Proficiency Level',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _buildProficiencyRow(i),
        ],
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: _addEntry,
          icon: const IthakiIcon('plus', size: 16),
          label: const Text('Add Another Language'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: IthakiTheme.softGraphite),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
