import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';
import '../../providers/reference_data_provider.dart';
import '../../widgets/panel_scaffold.dart';

class EditSkillsScreen extends ConsumerStatefulWidget {
  const EditSkillsScreen({super.key});

  @override
  ConsumerState<EditSkillsScreen> createState() => _EditSkillsScreenState();
}

class _EditSkillsScreenState extends ConsumerState<EditSkillsScreen> {
  List<String> _hardSkills = [];
  List<String> _softSkills = [];

  @override
  void initState() {
    super.initState();
    final skills = ref.read(profileSkillsProvider).requireValue;
    _hardSkills = List<String>.from(skills.hardSkills);
    _softSkills = List<String>.from(skills.softSkills);
  }

  void _save() {
    ref.read(profileSkillsProvider.notifier).updateSkills(_hardSkills, _softSkills);
    context.pop();
  }

  void _openPicker({
    required String title,
    required List<String> allOptions,
    required List<String> selected,
    required void Function(String) onAdd,
  }) {
    final available = allOptions
        .where((s) => !selected.contains(s))
        .map((s) => SearchItem(id: s, label: s))
        .toList();
    SearchBottomSheet.show(
      context,
      title,
      available,
      (item) => setState(() => onAdd(item.id)),
    );
  }

  Widget _chip(String label, VoidCallback onRemove) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: IthakiTheme.textPrimary)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: IthakiTheme.softGraphite),
          ),
        ]),
      );

  Widget _section({
    required String title,
    required List<String> skills,
    required List<String> allOptions,
    required void Function(String) onAdd,
    required void Function(int) onRemove,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary)),
      const SizedBox(height: 10),
      if (skills.isNotEmpty) ...[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .asMap()
              .entries
              .map((e) => _chip(e.value, () => setState(() => onRemove(e.key))))
              .toList(),
        ),
        const SizedBox(height: 10),
      ],
      GestureDetector(
        onTap: () => _openPicker(
          title: title,
          allOptions: allOptions,
          selected: skills,
          onAdd: onAdd,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          child: Row(children: [
            Expanded(
              child: Text(
                'Start typing to add a skill',
                style: TextStyle(fontSize: 14, color: IthakiTheme.softGraphite),
              ),
            ),
            const IthakiIcon('arrow-down', size: 18, color: IthakiTheme.softGraphite),
          ]),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final hardAsync = ref.watch(hardSkillsProvider);
    final softAsync = ref.watch(softSkillsProvider);

    final hardOptions = hardAsync.value?.map((s) => s.name).toList() ?? const [];
    final softOptions = softAsync.value?.map((s) => s.name).toList() ?? const [];

    return PanelScaffold(
      title: 'Edit Skills',
      onSave: _save,
      children: [
        const Text('Edit Skills',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 6),
        const Text(
          'Select the skills that best represent your qualifications and professional expertise.',
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 24),
        if (hardAsync.isLoading || softAsync.isLoading)
          const Center(child: CircularProgressIndicator())
        else ...[
          _section(
            title: 'Hard Skills',
            skills: _hardSkills,
            allOptions: hardOptions,
            onAdd: (s) => _hardSkills.add(s),
            onRemove: (i) => _hardSkills.removeAt(i),
          ),
          const SizedBox(height: 24),
          _section(
            title: 'Soft Skills',
            skills: _softSkills,
            allOptions: softOptions,
            onAdd: (s) => _softSkills.add(s),
            onRemove: (i) => _softSkills.removeAt(i),
          ),
        ],
      ],
    );
  }
}
