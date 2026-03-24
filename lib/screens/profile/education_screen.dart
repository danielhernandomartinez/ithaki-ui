// lib/screens/profile/education_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';

class EducationScreen extends ConsumerWidget {
  const EducationScreen({super.key});

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EducationFormSheet(
        initial: null,
        onSave: (edu) =>
            ref.read(profileProvider.notifier).addEducation(edu),
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, WidgetRef ref, int index, Education edu) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EducationFormSheet(
        initial: edu,
        onSave: (updated) =>
            ref.read(profileProvider.notifier).updateEducation(index, updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final educations = ref.watch(profileProvider).educations;

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
          'Education',
          style: TextStyle(
            color: IthakiTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (educations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 24),
                child: Text(
                  'No education added yet.',
                  style: TextStyle(
                      fontSize: 14, color: IthakiTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...educations.asMap().entries.map((e) {
                final index = e.key;
                final edu = e.value;
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              edu.institutionName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: IthakiTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              edu.fieldOfStudy,
                              style: const TextStyle(
                                fontSize: 14,
                                color: IthakiTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              edu.degreeType,
                              style: TextStyle(
                                fontSize: 13,
                                color: IthakiTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              edu.currentlyStudyHere
                                  ? '${edu.startDate} – Present'
                                  : '${edu.startDate} – ${edu.endDate ?? ''}',
                              style: TextStyle(
                                fontSize: 13,
                                color: IthakiTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit,
                            size: 20, color: IthakiTheme.textSecondary),
                        onPressed: () =>
                            _showEditSheet(context, ref, index, edu),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: IthakiButton(
                'Add Education',
                onPressed: () => _showAddSheet(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationFormSheet extends StatefulWidget {
  final Education? initial;
  final void Function(Education) onSave;

  const _EducationFormSheet({
    required this.initial,
    required this.onSave,
  });

  @override
  State<_EducationFormSheet> createState() => _EducationFormSheetState();
}

class _EducationFormSheetState extends State<_EducationFormSheet> {
  late final TextEditingController _institutionCtrl;
  late final TextEditingController _fieldCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _startDateCtrl;
  late final TextEditingController _endDateCtrl;

  String _degreeType = '';
  bool _currentlyStudyHere = false;

  @override
  void initState() {
    super.initState();
    final edu = widget.initial;
    _institutionCtrl =
        TextEditingController(text: edu?.institutionName ?? '');
    _fieldCtrl = TextEditingController(text: edu?.fieldOfStudy ?? '');
    _locationCtrl = TextEditingController(text: edu?.location ?? '');
    _startDateCtrl = TextEditingController(text: edu?.startDate ?? '');
    _endDateCtrl = TextEditingController(text: edu?.endDate ?? '');
    _degreeType = edu?.degreeType ?? '';
    _currentlyStudyHere = edu?.currentlyStudyHere ?? false;
  }

  @override
  void dispose() {
    _institutionCtrl.dispose();
    _fieldCtrl.dispose();
    _locationCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final edu = Education(
      institutionName: _institutionCtrl.text.trim(),
      fieldOfStudy: _fieldCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      degreeType: _degreeType,
      startDate: _startDateCtrl.text.trim(),
      endDate: _currentlyStudyHere ? null : _endDateCtrl.text.trim(),
      currentlyStudyHere: _currentlyStudyHere,
    );
    widget.onSave(edu);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: IthakiTheme.primaryPurple),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Education',
      onClose: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _institutionCtrl,
              decoration: _fieldDecoration('Institution Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _fieldCtrl,
              decoration: _fieldDecoration('Field of Study'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationCtrl,
              decoration: _fieldDecoration('Location'),
            ),
            const SizedBox(height: 12),
            IthakiDropdown<String>(
              label: 'Degree Type',
              hint: 'Select degree',
              value: _degreeType.isEmpty ? null : _degreeType,
              items: const [
                'High School',
                'Associate',
                'Bachelor',
                'Master',
                'PhD',
                'Certification',
                'Other',
              ]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _degreeType = v ?? ''),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _startDateCtrl,
              decoration: _fieldDecoration('Start Date', hint: 'MM-YYYY'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _endDateCtrl,
              enabled: !_currentlyStudyHere,
              decoration: _fieldDecoration('End Date', hint: 'MM-YYYY'),
            ),
            CheckboxListTile(
              value: _currentlyStudyHere,
              onChanged: (v) =>
                  setState(() => _currentlyStudyHere = v ?? false),
              title: const Text('I currently study here'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: IthakiTheme.primaryPurple,
            ),
            const SizedBox(height: 20),
            IthakiButton('Save', onPressed: _save),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
