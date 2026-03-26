// lib/screens/profile/work_experience_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';
import '../../utils/profile_date_utils.dart';
import '../../widgets/profile_meta_cell.dart';
import '../../widgets/profile_picker_field.dart';

// ─── List screen ────────────────────────────────────────────────────────────

class WorkExperienceScreen extends ConsumerWidget {
  const WorkExperienceScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(profileProvider).workExperiences;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Work Experience'),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.viewPaddingOf(context).bottom + 32),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────
              const Text('Work Experience',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Add details about your previous roles and companies',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              // ── Experience sub-cards ─────────────────────────────────
              ...experiences.asMap().entries.map((e) {
                final index = e.key;
                final exp = e.value;
                final duration = calcDuration(
                    exp.startDate,
                    exp.currentlyWorkHere ? null : exp.endDate);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header row ─────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: IthakiTheme.textPrimary),
                                children: [
                                  TextSpan(text: exp.jobTitle),
                                  const TextSpan(
                                      text: '  at  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: IthakiTheme.textSecondary)),
                                  TextSpan(text: exp.companyName),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context.push(
                              '/profile/work-experience/edit',
                              extra: {'index': index, 'exp': exp},
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                    color: IthakiTheme.borderLight),
                              ),
                              child: const IthakiIcon('edit-pencil',
                                  size: 16,
                                  color: IthakiTheme.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // ── Date + duration ────────────────────────────
                      Text(
                        [
                          exp.currentlyWorkHere
                              ? '${exp.startDate} – Present'
                              : '${exp.startDate} – ${exp.endDate ?? ''}',
                          if (duration.isNotEmpty) '($duration)',
                        ].join(' '),
                        style: const TextStyle(
                            fontSize: 13,
                            color: IthakiTheme.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 10),
                      // ── Metadata grid ──────────────────────────────
                      Row(children: [
                        if (exp.location.isNotEmpty)
                          Expanded(child: ProfileMetaCell(Icons.location_on_outlined, exp.location)),
                        if (exp.workplace.isNotEmpty)
                          Expanded(child: ProfileMetaCell(Icons.business_outlined, exp.workplace)),
                      ]),
                      if (exp.jobType.isNotEmpty || exp.experienceLevel.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(children: [
                          if (exp.jobType.isNotEmpty)
                            Expanded(child: ProfileMetaCell(Icons.access_time_outlined, exp.jobType)),
                          if (exp.experienceLevel.isNotEmpty)
                            Expanded(child: ProfileMetaCell(Icons.bar_chart_outlined, exp.experienceLevel)),
                        ]),
                      ],
                      // ── Summary ────────────────────────────────────
                      if (exp.summary != null && exp.summary!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: Color(0xFFE0E0E0)),
                        const SizedBox(height: 10),
                        Text(exp.summary!,
                            style: const TextStyle(
                                fontSize: 13,
                                color: IthakiTheme.textPrimary,
                                height: 1.5)),
                      ],
                    ],
                  ),
                );
              }),

              // ── Add button ───────────────────────────────────────────
              OutlinedButton.icon(
                onPressed: () =>
                    context.push('/profile/work-experience/edit'),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Work Experience'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: IthakiTheme.softGraphite),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  foregroundColor: IthakiTheme.textPrimary,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 16),

              // ── Save button ──────────────────────────────────────────
              IthakiButton('Save', onPressed: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Form screen ─────────────────────────────────────────────────────────────

class WorkExperienceFormScreen extends ConsumerStatefulWidget {
  final int? editIndex;
  final WorkExperience? initial;

  const WorkExperienceFormScreen({
    super.key,
    this.editIndex,
    this.initial,
  });

  @override
  ConsumerState<WorkExperienceFormScreen> createState() =>
      _WorkExperienceFormScreenState();
}

class _WorkExperienceFormScreenState
    extends ConsumerState<WorkExperienceFormScreen> {
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

  static const _experienceLevels = [
    'Entry (0-1 years)',
    'Junior (1-2 years)',
    'Middle (2-3 years)',
    'Senior (3-5 years)',
    'Lead (5+ years)',
  ];
  static const _workplaces = ['On-site', 'Remote', 'Hybrid'];
  static const _jobTypes = ['Full Time', 'Part Time', 'Contract', 'Freelance'];

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
    _summaryCtrl.addListener(() => setState(() {}));
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

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final month = picked.month.toString().padLeft(2, '0');
      ctrl.text = '$month-${picked.year}';
    }
  }

  void _openPicker({
    required String title,
    required List<String> options,
    required String current,
    required void Function(String) onSelect,
  }) {
    SearchBottomSheet.show(
      context,
      title,
      options.map((o) => SearchItem(id: o, label: o)).toList(),
      (item) => setState(() => onSelect(item.id)),
    );
  }


  void _save() {
    final notifier = ref.read(profileProvider.notifier);
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
      summary: _summaryCtrl.text.trim().isEmpty ? null : _summaryCtrl.text.trim(),
    );
    if (widget.editIndex != null) {
      notifier.updateWorkExperience(widget.editIndex!, exp);
    } else {
      notifier.addWorkExperience(exp);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Edit Work Experience'),
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
              // ── Header ─────────────────────────────────────────
              const Text('Edit Work Experience',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Add details about your previous roles and companies',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Fields ──────────────────────────────────────────
              IthakiTextField(
                  label: 'Job Title',
                  hint: 'e.g. Software Engineer',
                  controller: _jobTitleCtrl),
              const SizedBox(height: 12),
              IthakiTextField(
                  label: 'Company Name',
                  hint: 'e.g. Acme Corp',
                  controller: _companyCtrl),
              const SizedBox(height: 12),
              IthakiTextField(
                  label: 'Location',
                  hint: 'e.g. Athens, Greece',
                  controller: _locationCtrl),
              const SizedBox(height: 12),
              ProfilePickerField(label: 'Experience Level', hint: 'Select level', value: _experienceLevel, onTap: () => _openPicker(
                        title: 'Experience Level',
                        options: _experienceLevels,
                        current: _experienceLevel,
                        onSelect: (v) => _experienceLevel = v,
                      )),
              const SizedBox(height: 12),
              ProfilePickerField(label: 'Workplace', hint: 'Select workplace', value: _workplaceType, onTap: () => _openPicker(
                        title: 'Workplace',
                        options: _workplaces,
                        current: _workplaceType,
                        onSelect: (v) => _workplaceType = v,
                      )),
              const SizedBox(height: 12),
              ProfilePickerField(label: 'Job Type', hint: 'Select job type', value: _jobType, onTap: () => _openPicker(
                        title: 'Job Type',
                        options: _jobTypes,
                        current: _jobType,
                        onSelect: (v) => _jobType = v,
                      )),
              const SizedBox(height: 12),
              IthakiTextField(
                label: 'Start Date',
                hint: 'MM-YYYY',
                controller: _startDateCtrl,
                readOnly: true,
                onTap: () => _pickDate(_startDateCtrl),
                suffixIcon: const IthakiIcon('calendar',
                    size: 20, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              IthakiTextField(
                label: 'End Date',
                hint: 'MM-YYYY',
                controller: _endDateCtrl,
                readOnly: true,
                onTap: _currentlyWorkHere ? null : () => _pickDate(_endDateCtrl),
                suffixIcon: IthakiIcon('calendar',
                    size: 20,
                    color: _currentlyWorkHere
                        ? IthakiTheme.softGraphite
                        : IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 4),
              IthakiCheckbox(
                value: _currentlyWorkHere,
                onChanged: (v) => setState(() {
                  _currentlyWorkHere = v;
                  if (v) _endDateCtrl.clear();
                }),
                child: const Text('I currently work here',
                    style: TextStyle(
                        fontSize: 14, color: IthakiTheme.textPrimary)),
              ),
              const SizedBox(height: 16),

              // ── Summary ─────────────────────────────────────────
              const Text('Experience Summary (optional)',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              TextField(
                controller: _summaryCtrl,
                maxLines: 5,
                maxLength: 1000,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                    Text('$currentLength / $maxLength symbols',
                        style: const TextStyle(
                            fontSize: 11, color: IthakiTheme.textSecondary)),
                decoration: InputDecoration(
                  hintText: 'Describe your role and achievements...',
                  hintStyle: const TextStyle(
                      color: IthakiTheme.softGraphite, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                        color: IthakiTheme.primaryPurple, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
