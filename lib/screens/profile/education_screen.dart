// lib/screens/profile/education_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';
import '../../utils/profile_date_utils.dart';
import '../../widgets/profile_meta_cell.dart';
import '../../widgets/profile_picker_field.dart';

// ─── List / hub screen ───────────────────────────────────────────────────────

class EducationScreen extends ConsumerWidget {
  const EducationScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final educations = ref.watch(profileProvider).educations;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Education'),
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
              // ── Header ────────────────────────────────────────────
              const Text('Education',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Add information about your educational background, degree, and field of study.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              // ── Education sub-cards ────────────────────────────────
              ...educations.asMap().entries.map((e) {
                final index = e.key;
                final edu = e.value;
                final duration = calcDuration(
                    edu.startDate,
                    edu.currentlyStudyHere ? null : edu.endDate);
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
                      // ── Header row ───────────────────────────────
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
                                  TextSpan(text: edu.fieldOfStudy),
                                  const TextSpan(
                                      text: '  at  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: IthakiTheme.textSecondary)),
                                  TextSpan(text: edu.institutionName),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context.push(
                              Routes.profileEducationEdit,
                              extra: EducationEditExtra(index: index, edu: edu).toMap(),
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
                      // ── Date + duration ──────────────────────────
                      Text(
                        [
                          edu.currentlyStudyHere
                              ? '${edu.startDate} – Present'
                              : '${edu.startDate} – ${edu.endDate ?? ''}',
                          if (duration.isNotEmpty) '($duration)',
                        ].join(' '),
                        style: const TextStyle(
                            fontSize: 13,
                            color: IthakiTheme.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),
                      const SizedBox(height: 10),
                      // ── Metadata ─────────────────────────────────
                      if (edu.location.isNotEmpty)
                        ProfileMetaCell(Icons.location_on_outlined, edu.location, alignIconTop: true),
                      if (edu.degreeType.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        ProfileMetaCell(Icons.school_outlined, edu.degreeType, alignIconTop: true),
                      ],
                    ],
                  ),
                );
              }),

              // ── Add button ─────────────────────────────────────────
              OutlinedButton.icon(
                onPressed: () => context.push(Routes.profileEducationEdit),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Education'),
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

              // ── Save ───────────────────────────────────────────────
              IthakiButton('Save', onPressed: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Form screen ─────────────────────────────────────────────────────────────

class EducationFormScreen extends ConsumerStatefulWidget {
  final int? editIndex;
  final Education? initial;

  const EducationFormScreen({
    super.key,
    this.editIndex,
    this.initial,
  });

  @override
  ConsumerState<EducationFormScreen> createState() =>
      _EducationFormScreenState();
}

class _EducationFormScreenState extends ConsumerState<EducationFormScreen> {
  late final TextEditingController _institutionCtrl;
  late final TextEditingController _fieldCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _startDateCtrl;
  late final TextEditingController _endDateCtrl;

  String _degreeType = '';
  bool _currentlyStudyHere = false;

  static const _degreeTypes = [
    'High School Diploma',
    'Associate Degree',
    'Bachelor\'s Diploma',
    'Master\'s Degree',
    'PhD / Doctorate',
    'Certification',
    'Bootcamp',
    'Other',
  ];

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

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ctrl.text =
          '${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  void _save() {
    final notifier = ref.read(profileProvider.notifier);
    final edu = Education(
      institutionName: _institutionCtrl.text.trim(),
      fieldOfStudy: _fieldCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      degreeType: _degreeType,
      startDate: _startDateCtrl.text.trim(),
      endDate:
          _currentlyStudyHere ? null : _endDateCtrl.text.trim(),
      currentlyStudyHere: _currentlyStudyHere,
    );
    if (widget.editIndex != null) {
      notifier.updateEducation(widget.editIndex!, edu);
    } else {
      notifier.addEducation(edu);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Edit Education'),
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
              // ── Header ──────────────────────────────────────────────
              const Text('Edit Education',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Add information about your educational background, '
                'degree, and field of study.',
                style: TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Fields ───────────────────────────────────────────────
              IthakiTextField(
                label: 'Institution Name',
                hint: 'e.g. University of Athens',
                controller: _institutionCtrl,
              ),
              const SizedBox(height: 12),
              IthakiTextField(
                label: 'Field of Study',
                hint: 'e.g. Computer Science',
                controller: _fieldCtrl,
              ),
              const SizedBox(height: 12),
              IthakiTextField(
                label: 'Location',
                hint: 'e.g. Athens, Greece',
                controller: _locationCtrl,
              ),
              const SizedBox(height: 12),
              ProfilePickerField(label: 
                'Degree Type', hint: 'Select degree', value: _degreeType, onTap: () => SearchBottomSheet.show(
                  context,
                  'Degree Type',
                  _degreeTypes
                      .map((d) => SearchItem(id: d, label: d))
                      .toList(),
                  (item) => setState(() => _degreeType = item.id),
                ),
              ),
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
                onTap: _currentlyStudyHere
                    ? null
                    : () => _pickDate(_endDateCtrl),
                suffixIcon: IthakiIcon('calendar',
                    size: 20,
                    color: _currentlyStudyHere
                        ? IthakiTheme.softGraphite
                        : IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 4),
              IthakiCheckbox(
                value: _currentlyStudyHere,
                onChanged: (v) => setState(() {
                  _currentlyStudyHere = v;
                  if (v) _endDateCtrl.clear();
                }),
                child: const Text('I currently study here',
                    style: TextStyle(
                        fontSize: 14, color: IthakiTheme.textPrimary)),
              ),
              const SizedBox(height: 24),
              IthakiButton('Save', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}
