import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';

const _kHardSkills = [
  'Web Development', 'HTML5 / CSS3', 'JavaScript (ES6+)',
  'React / Vue / Angular', 'Node.js / Express.js', 'TypeScript',
  'Webflow', 'iOS Development', 'GitHub', 'RESTful APIs', 'GraphQL',
  'Python', 'Java', 'Flutter', 'Swift', 'Kotlin', 'SQL', 'Docker',
  'Kubernetes', 'AWS', 'Azure', 'Machine Learning', 'Data Analysis',
  'UI/UX Design', 'Figma', 'Product Management', 'SEO',
  'Digital Marketing', 'Excel / Spreadsheets', 'Blockchain', 'Cybersecurity',
];

const _kSoftSkills = [
  'Problem Solving', 'Attention to Detail', 'Teamwork', 'Responsibility',
  'Continuous Learning', 'Time Management', 'Critical Thinking',
  'Communication', 'Adaptability', 'Leadership', 'Creativity',
  'Conflict Resolution', 'Emotional Intelligence', 'Decision Making',
  'Multitasking', 'Networking', 'Mentoring', 'Public Speaking',
  'Negotiation', 'Work Ethic',
];

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
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textPrimary)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: IthakiTheme.softGraphite),
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
              .map((e) => _chip(e.value, () => onRemove(e.key)))
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
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          child: Row(children: [
            Expanded(
              child: Text(
                'Start typing to add a skill',
                style: TextStyle(
                    fontSize: 14, color: IthakiTheme.softGraphite),
              ),
            ),
            const IthakiIcon('arrow-down',
                size: 18, color: IthakiTheme.softGraphite),
          ]),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Edit Skills'),
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
              const Text('Edit Skills',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Select the skills that best represent your qualifications and professional expertise.',
                style: TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              _section(
                title: 'Hard Skills',
                skills: _hardSkills,
                allOptions: _kHardSkills,
                onAdd: (s) => _hardSkills.add(s),
                onRemove: (i) => _hardSkills.removeAt(i),
              ),
              const SizedBox(height: 24),
              _section(
                title: 'Soft Skills',
                skills: _softSkills,
                allOptions: _kSoftSkills,
                onAdd: (s) => _softSkills.add(s),
                onRemove: (i) => _softSkills.removeAt(i),
              ),
              const SizedBox(height: 28),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
