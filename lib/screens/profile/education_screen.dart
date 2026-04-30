// lib/screens/profile/education_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/panel_scaffold.dart';
import '../../widgets/profile_picker_field.dart';
import '../../widgets/city_search_bottom_sheet.dart';
import 'widgets/education_card.dart';

// ─── List / hub screen ───────────────────────────────────────────────────────

class EducationScreen extends ConsumerWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final educations = ref.watch(profileEducationsProvider).value ?? const [];

    return IthakiEntryListShell(
      appBarTitle: 'Education',
      title: 'Education',
      subtitle:
          'Add information about your educational background, degree, and field of study.',
      addButtonLabel: 'Add Education',
      onAddPressed: () => context.push(Routes.profileEducationEdit),
      onSavePressed: () => context.pop(),
      entries: educations.asMap().entries.map((e) {
        final index = e.key;
        final edu = e.value;

        return EducationCard(
          education: edu,
          onEditTap: () => context.push(
            Routes.profileEducationEdit,
            extra: EducationEditExtra(index: index, edu: edu).toMap(),
          ),
        );
      }).toList(),
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
    _institutionCtrl = TextEditingController(text: edu?.institutionName ?? '');
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
      ctrl.text = '${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  Future<void> _save() async {
    final notifier = ref.read(profileEducationsProvider.notifier);
    final edu = Education(
      institutionName: _institutionCtrl.text.trim(),
      fieldOfStudy: _fieldCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      degreeType: _degreeType,
      startDate: _startDateCtrl.text.trim(),
      endDate: _currentlyStudyHere ? null : _endDateCtrl.text.trim(),
      currentlyStudyHere: _currentlyStudyHere,
    );
    try {
      if (widget.editIndex != null) {
        await notifier.save(widget.editIndex!, edu);
      } else {
        await notifier.add(edu);
      }
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PanelScaffold(
      title: 'Edit Education',
      onSave: _save,
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
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
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
        ProfilePickerField(
          label: 'Location',
          hint: 'Type city to search',
          value: _locationCtrl.text,
          onTap: () => CitySearchBottomSheet.show(
            context,
            (city) => setState(() => _locationCtrl.text = city),
          ),
        ),
        const SizedBox(height: 12),
        ProfilePickerField(
          label: 'Degree Type',
          hint: 'Select degree',
          value: _degreeType,
          onTap: () => SearchBottomSheet.show(
            context,
            'Degree Type',
            _degreeTypes.map((d) => SearchItem(id: d, label: d)).toList(),
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
          onTap: _currentlyStudyHere ? null : () => _pickDate(_endDateCtrl),
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
              style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary)),
        ),
      ],
    );
  }
}
