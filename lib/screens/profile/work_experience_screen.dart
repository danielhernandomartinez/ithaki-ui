// lib/screens/profile/work_experience_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';

class WorkExperienceScreen extends ConsumerWidget {
  const WorkExperienceScreen({super.key});

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _WorkExperienceFormSheet(
        initial: null,
        onSave: (exp) =>
            ref.read(profileProvider.notifier).addWorkExperience(exp),
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, WidgetRef ref, int index, WorkExperience exp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _WorkExperienceFormSheet(
        initial: exp,
        onSave: (updated) =>
            ref.read(profileProvider.notifier).updateWorkExperience(index, updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(profileProvider).workExperiences;

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
          'Work Experience',
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
            if (experiences.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Text(
                  'No work experience added yet.',
                  style: TextStyle(
                      fontSize: 14, color: IthakiTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...experiences.asMap().entries.map((e) {
                final index = e.key;
                final exp = e.value;
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
                              exp.jobTitle,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: IthakiTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exp.companyName,
                              style: const TextStyle(
                                fontSize: 14,
                                color: IthakiTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exp.location,
                              style: TextStyle(
                                fontSize: 13,
                                color: IthakiTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              exp.currentlyWorkHere
                                  ? '${exp.startDate} – Present'
                                  : '${exp.startDate} – ${exp.endDate ?? ''}',
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
                            _showEditSheet(context, ref, index, exp),
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
                'Add Work Experience',
                onPressed: () => _showAddSheet(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkExperienceFormSheet extends StatefulWidget {
  final WorkExperience? initial;
  final void Function(WorkExperience) onSave;

  const _WorkExperienceFormSheet({
    required this.initial,
    required this.onSave,
  });

  @override
  State<_WorkExperienceFormSheet> createState() =>
      _WorkExperienceFormSheetState();
}

class _WorkExperienceFormSheetState extends State<_WorkExperienceFormSheet> {
  late final TextEditingController _jobTitleCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _summaryCtrl;
  late final TextEditingController _startDateCtrl;
  late final TextEditingController _endDateCtrl;

  String _experienceLevel = '';
  String _workplaceType = '';
  String _jobType = '';
  bool _currentlyWorkHere = false;

  @override
  void initState() {
    super.initState();
    final w = widget.initial;
    _jobTitleCtrl = TextEditingController(text: w?.jobTitle ?? '');
    _companyCtrl = TextEditingController(text: w?.companyName ?? '');
    _locationCtrl = TextEditingController(text: w?.location ?? '');
    _summaryCtrl = TextEditingController(text: w?.summary ?? '');
    _startDateCtrl = TextEditingController(text: w?.startDate ?? '');
    _endDateCtrl = TextEditingController(text: w?.endDate ?? '');
    _experienceLevel = w?.experienceLevel ?? '';
    _workplaceType = w?.workplace ?? '';
    _jobType = w?.jobType ?? '';
    _currentlyWorkHere = w?.currentlyWorkHere ?? false;
  }

  @override
  void dispose() {
    _jobTitleCtrl.dispose();
    _companyCtrl.dispose();
    _locationCtrl.dispose();
    _summaryCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final exp = WorkExperience(
      jobTitle: _jobTitleCtrl.text.trim(),
      companyName: _companyCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      experienceLevel: _experienceLevel,
      workplace: _workplaceType,
      jobType: _jobType,
      startDate: _startDateCtrl.text.trim(),
      endDate: _currentlyWorkHere ? null : _endDateCtrl.text.trim(),
      currentlyWorkHere: _currentlyWorkHere,
      summary: _summaryCtrl.text.trim().isEmpty
          ? null
          : _summaryCtrl.text.trim(),
    );
    widget.onSave(exp);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Work Experience',
      onClose: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            IthakiTextField(
              label: 'Job Title',
              hint: 'e.g. Software Engineer',
              controller: _jobTitleCtrl,
            ),
            const SizedBox(height: 12),
            IthakiTextField(
              label: 'Company Name',
              hint: 'e.g. Acme Corp',
              controller: _companyCtrl,
            ),
            const SizedBox(height: 12),
            IthakiTextField(
              label: 'Location',
              hint: 'e.g. Athens, Greece',
              controller: _locationCtrl,
            ),
            const SizedBox(height: 12),
            IthakiDropdown<String>(
              label: 'Experience Level',
              hint: 'Select level',
              value: _experienceLevel.isEmpty ? null : _experienceLevel,
              items: const ['Entry', 'Junior', 'Mid-level', 'Senior', 'Lead']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _experienceLevel = v ?? ''),
            ),
            const SizedBox(height: 12),
            IthakiDropdown<String>(
              label: 'Workplace Type',
              hint: 'Select workplace',
              value: _workplaceType.isEmpty ? null : _workplaceType,
              items: const ['On-site', 'Remote', 'Hybrid']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _workplaceType = v ?? ''),
            ),
            const SizedBox(height: 12),
            IthakiDropdown<String>(
              label: 'Job Type',
              hint: 'Select job type',
              value: _jobType.isEmpty ? null : _jobType,
              items: const [
                'Full Time',
                'Part Time',
                'Contract',
                'Freelance',
              ]
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _jobType = v ?? ''),
            ),
            const SizedBox(height: 12),
            IthakiTextField(
              label: 'Start Date',
              hint: 'MM-YYYY',
              controller: _startDateCtrl,
            ),
            const SizedBox(height: 12),
            IthakiTextField(
              label: 'End Date',
              hint: 'MM-YYYY',
              controller: _endDateCtrl,
              readOnly: _currentlyWorkHere,
            ),
            IthakiCheckbox(
              value: _currentlyWorkHere,
              onChanged: (v) => setState(() {
                _currentlyWorkHere = v;
                if (v) _endDateCtrl.clear();
              }),
              child: const Text(
                'I currently work here',
                style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _summaryCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Summary (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
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
