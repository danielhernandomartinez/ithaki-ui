// lib/screens/profile/edit_job_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/profile_picker_field.dart';
import '../../widgets/job_interest_tile.dart';
import '../../widgets/add_job_interest_sheet.dart';
import '../../widgets/panel_scaffold.dart';
import '../../widgets/salary_field_row.dart';

class EditJobPreferencesScreen extends ConsumerStatefulWidget {
  const EditJobPreferencesScreen({super.key});

  @override
  ConsumerState<EditJobPreferencesScreen> createState() =>
      _EditJobPreferencesScreenState();
}

class _EditJobPreferencesScreenState
    extends ConsumerState<EditJobPreferencesScreen> {
  late List<JobInterest> _interests;
  late String _positionLevel;
  late Set<String> _jobTypeSelected;
  late Set<String> _workplaceSelected;
  late bool _preferNotToSpecify;
  String _paymentTerm = 'Monthly';

  final _salaryCtrl = TextEditingController();

  static const _positionLevels = [
    'Entry (0-1 years)',
    'Junior (1-2 years)',
    'Middle (2-3 years)',
    'Senior (3-5 years)',
    'Lead (5+ years)',
    'Manager',
    'Director',
  ];
  static const _jobTypes = ['Full-Time', 'Part-time', 'Contract', 'Freelance'];
  static const _workplaceTypes = ['On-Site', 'Remote', 'Hybrid'];

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileJobPreferencesProvider).requireValue;
    _interests = List<JobInterest>.from(p.jobInterests);
    _positionLevel = p.positionLevel;
    _jobTypeSelected =
        p.jobType.isEmpty ? {} : Set<String>.from(p.jobType.split(', '));
    _workplaceSelected =
        p.workplace.isEmpty ? {} : Set<String>.from(p.workplace.split(', '));
    _salaryCtrl.text =
        p.expectedSalary != null ? p.expectedSalary!.toStringAsFixed(0) : '';
    _preferNotToSpecify = p.preferNotToSpecifySalary;
  }

  @override
  void dispose() {
    _salaryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final salary = double.tryParse(_salaryCtrl.text.trim());
    try {
      await ref.read(profileJobPreferencesProvider.notifier).save(
            interests: _interests,
            positionLevel: _positionLevel,
            jobType:
                _jobTypeSelected.isEmpty ? '' : _jobTypeSelected.join(', '),
            workplace:
                _workplaceSelected.isEmpty ? '' : _workplaceSelected.join(', '),
            expectedSalary: _preferNotToSpecify ? null : salary,
            preferNotToSpecifySalary: _preferNotToSpecify,
          );
      if (!mounted) return;
      SuccessBanner.show(context, l.jobPreferencesUpdated);
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
    final l = AppLocalizations.of(context)!;

    return PanelScaffold(
      title: l.editJobPreferencesTitle,
      onSave: _save,
      children: [
        // ── Header ──────────────────────────────────────────────
        Text(l.editJobPreferencesTitle,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 6),
        Text(
          l.preferencesDescription,
          style:
              const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 24),

        // ── Job Interests ────────────────────────────────────────
        ..._interests.asMap().entries.map((e) => JobInterestTile(
              interest: e.value,
              onRemove: () => setState(() {
                final list = List<JobInterest>.from(_interests);
                list.removeAt(e.key);
                _interests = list;
              }),
            )),
        OutlinedButton.icon(
          onPressed: () => AddJobInterestSheet.show(
            context,
            onAdd: (interest) =>
                setState(() => _interests = [..._interests, interest]),
          ),
          icon: const Icon(Icons.add, size: 16),
          label: Text(l.addAnotherJobInterest),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: IthakiTheme.softGraphite),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 24),

        // ── Position Level ───────────────────────────────────────
        ProfilePickerField(
          label: l.positionLevelOptionalLabel,
          hint: l.selectLevel,
          value: _positionLevel,
          fontSize: 14,
          verticalPadding: 11,
          arrowSize: 18,
          onTap: () => SearchBottomSheet.show(
            context,
            l.positionLevelLabel,
            _positionLevels.map((o) => SearchItem(id: o, label: o)).toList(),
            (item) => setState(() => _positionLevel = item.id),
          ),
        ),
        const SizedBox(height: 24),

        // ── Job Type ─────────────────────────────────────────────
        Text(l.jobTypeTitle,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 4),
        Text(
          l.jobTypeDescription,
          style:
              const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _jobTypes
              .map((t) => IthakiOptionChip(
                    label: t,
                    isSelected: _jobTypeSelected.contains(t),
                    onTap: () => setState(() {
                      if (_jobTypeSelected.contains(t)) {
                        _jobTypeSelected = {..._jobTypeSelected}..remove(t);
                      } else {
                        _jobTypeSelected = {..._jobTypeSelected, t};
                      }
                    }),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),

        // ── Workplace Format ─────────────────────────────────────
        Text(l.workplaceFormatTitle,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 4),
        Text(
          l.workplaceFormatDescription,
          style:
              const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _workplaceTypes
              .map((t) => IthakiOptionChip(
                    label: t,
                    isSelected: _workplaceSelected.contains(t),
                    onTap: () => setState(() {
                      if (_workplaceSelected.contains(t)) {
                        _workplaceSelected = {..._workplaceSelected}..remove(t);
                      } else {
                        _workplaceSelected = {..._workplaceSelected, t};
                      }
                    }),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),

        // ── Expected Payment ─────────────────────────────────────
        SalaryFieldRow(
          controller: _salaryCtrl,
          preferNotToSpecify: _preferNotToSpecify,
          paymentTerm: _paymentTerm,
          onPaymentTermChanged: (value) => setState(() => _paymentTerm = value),
          onPreferNotToSpecifyChanged: (v) =>
              setState(() => _preferNotToSpecify = v),
        ),
      ],
    );
  }
}
