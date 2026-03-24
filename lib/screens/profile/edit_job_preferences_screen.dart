// lib/screens/profile/edit_job_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';

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
  static const _paymentTerms = ['Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider);
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

  void _save() {
    final salary = double.tryParse(_salaryCtrl.text.trim());
    ref.read(profileProvider.notifier).updateJobPreferences(
          interests: _interests,
          positionLevel: _positionLevel,
          jobType:
              _jobTypeSelected.isEmpty ? '' : _jobTypeSelected.join(', '),
          workplace: _workplaceSelected.isEmpty
              ? ''
              : _workplaceSelected.join(', '),
          expectedSalary: _preferNotToSpecify ? null : salary,
          preferNotToSpecifySalary: _preferNotToSpecify,
        );
    if (!mounted) return;
    SuccessBanner.show(context, 'Your Job Preferences has been updated.');
    context.pop();
  }

  void _removeInterest(int index) {
    setState(() {
      final list = List<JobInterest>.from(_interests);
      list.removeAt(index);
      _interests = list;
    });
  }

  void _openAddInterest() {
    final titleCtrl = TextEditingController();
    final categoryCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Job Interest',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 16),
              IthakiTextField(
                label: 'Job Title',
                hint: 'e.g. Web Developer',
                controller: titleCtrl,
              ),
              const SizedBox(height: 12),
              IthakiTextField(
                label: 'Category',
                hint: 'e.g. IT & Development',
                controller: categoryCtrl,
              ),
              const SizedBox(height: 20),
              IthakiButton('Add', onPressed: () {
                final title = titleCtrl.text.trim();
                final category = categoryCtrl.text.trim();
                if (title.isEmpty || category.isEmpty) return;
                setState(() {
                  _interests = [
                    ..._interests,
                    JobInterest(title: title, category: category),
                  ];
                });
                Navigator.of(ctx).pop();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check,
                  size: 14, color: IthakiTheme.primaryPurple),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? IthakiTheme.primaryPurple
                    : IthakiTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickerField(
      String label, String hint, String value, VoidCallback onTap) {
    final hasValue = value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value : hint,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          hasValue ? FontWeight.w600 : FontWeight.w400,
                      color: hasValue
                          ? IthakiTheme.textPrimary
                          : IthakiTheme.softGraphite,
                    ),
                  ),
                ),
                const IthakiIcon('arrow-down',
                    size: 18, color: IthakiTheme.softGraphite),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Job Preferences'),
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
              const Text('Job Preferences',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              const Text(
                'Set your desired salary, position level, contract type, '
                'and work format (remote, on-site, or hybrid) to help us '
                'match you with the most relevant opportunities.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Job Interests ────────────────────────────────────────
              ..._interests.asMap().entries.map((e) {
                final interest = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: const IthakiIcon('rocket',
                          size: 20, color: IthakiTheme.primaryPurple),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(interest.title,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: IthakiTheme.textPrimary)),
                          Text(interest.category,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: IthakiTheme.textSecondary)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeInterest(e.key),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const IthakiIcon('delete',
                            size: 16,
                            color: IthakiTheme.softGraphite),
                      ),
                    ),
                  ]),
                );
              }),
              OutlinedButton.icon(
                onPressed: _openAddInterest,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Another Job Interest'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: IthakiTheme.softGraphite),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  foregroundColor: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // ── Position Level ───────────────────────────────────────
              _pickerField(
                'Position Level (optional)',
                'Select level',
                _positionLevel,
                () => SearchBottomSheet.show(
                  context,
                  'Position Level',
                  _positionLevels
                      .map((o) => SearchItem(id: o, label: o))
                      .toList(),
                  (item) => setState(() => _positionLevel = item.id),
                ),
              ),
              const SizedBox(height: 24),

              // ── Job Type ─────────────────────────────────────────────
              const Text('Job Type',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 4),
              const Text(
                'Choose the types of employment you\'re interested in. '
                'You can select more than one option.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _jobTypes
                    .map((t) => _optionTile(
                          t,
                          _jobTypeSelected.contains(t),
                          () => setState(() {
                            if (_jobTypeSelected.contains(t)) {
                              _jobTypeSelected =
                                  {..._jobTypeSelected}..remove(t);
                            } else {
                              _jobTypeSelected = {..._jobTypeSelected, t};
                            }
                          }),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // ── Workplace Format ─────────────────────────────────────
              const Text('Workplace Format',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 4),
              const Text(
                'Select your preferred workplace formats. '
                'You can select more than one option.',
                style:
                    TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _workplaceTypes
                    .map((t) => _optionTile(
                          t,
                          _workplaceSelected.contains(t),
                          () => setState(() {
                            if (_workplaceSelected.contains(t)) {
                              _workplaceSelected =
                                  {..._workplaceSelected}..remove(t);
                            } else {
                              _workplaceSelected = {
                                ..._workplaceSelected,
                                t
                              };
                            }
                          }),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // ── Expected Payment ─────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Expected Payment From',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: IthakiTheme.textPrimary)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _salaryCtrl,
                          enabled: !_preferNotToSpecify,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: const TextStyle(
                                color: IthakiTheme.softGraphite),
                            suffixText: '€',
                            suffixStyle: const TextStyle(
                                fontSize: 14,
                                color: IthakiTheme.textSecondary),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: IthakiTheme.borderLight),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: IthakiTheme.borderLight),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: IthakiTheme.primaryPurple,
                                  width: 1.5),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: IthakiTheme.borderLight),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _pickerField(
                      'Payment Term',
                      'Select',
                      _paymentTerm,
                      () => SearchBottomSheet.show(
                        context,
                        'Payment Term',
                        _paymentTerms
                            .map((t) => SearchItem(id: t, label: t))
                            .toList(),
                        (item) =>
                            setState(() => _paymentTerm = item.id),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              IthakiCheckbox(
                value: _preferNotToSpecify,
                onChanged: (v) => setState(() => _preferNotToSpecify = v),
                child: const Text('Prefer not to specify',
                    style: TextStyle(
                        fontSize: 14, color: IthakiTheme.textPrimary)),
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
