import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';

class EditSkillsScreen extends ConsumerStatefulWidget {
  const EditSkillsScreen({super.key});

  @override
  ConsumerState<EditSkillsScreen> createState() => _EditSkillsScreenState();
}

class _EditSkillsScreenState extends ConsumerState<EditSkillsScreen> {
  List<String> _hardSkills = [];
  List<String> _softSkills = [];
  final _hardCtrl = TextEditingController();
  final _softCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _hardSkills = List<String>.from(profile.hardSkills);
    _softSkills = List<String>.from(profile.softSkills);
  }

  @override
  void dispose() {
    _hardCtrl.dispose();
    _softCtrl.dispose();
    super.dispose();
  }

  void _save() {
    ref.read(profileProvider.notifier).updateSkills(_hardSkills, _softSkills);
    context.pop();
  }

  Widget _skillChip(String label, VoidCallback onRemove) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundViolet,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: IthakiTheme.textPrimary)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close,
                size: 14, color: IthakiTheme.softGraphite),
          ),
        ]),
      );

  Widget _chipSection(String sectionLabel, List<String> chips,
          TextEditingController ctrl) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...chips.asMap().entries.map((e) => _skillChip(e.value, () {
                    setState(() => chips.removeAt(e.key));
                  })),
            ]),
        if (chips.isNotEmpty) const SizedBox(height: 12),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Start typing to add a skill',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: IthakiTheme.primaryPurple)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
          ),
          onSubmitted: (v) {
            if (v.trim().isEmpty) return;
            setState(() {
              chips.add(v.trim());
              ctrl.clear();
            });
          },
        ),
      ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: IthakiTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Skills',
          style: TextStyle(
              color: IthakiTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hard Skills',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _chipSection('Hard Skills', _hardSkills, _hardCtrl),
              const SizedBox(height: 20),
              const Text('Soft Skills',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _chipSection('Soft Skills', _softSkills, _softCtrl),
              const SizedBox(height: 24),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
