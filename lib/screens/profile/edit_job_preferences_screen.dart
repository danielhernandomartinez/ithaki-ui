// lib/screens/profile/edit_job_preferences_screen.dart
import 'package:flutter/material.dart';
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
  String? _paymentTerm;

  final TextEditingController _salaryCtrl = TextEditingController();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider);
    _interests = List<JobInterest>.from(p.jobInterests);
    _positionLevel = p.positionLevel;
    _jobTypeSelected = p.jobType.isEmpty ? {} : {p.jobType};
    _workplaceSelected = p.workplace.isEmpty ? {} : {p.workplace};
    _salaryCtrl.text =
        p.expectedSalary != null ? p.expectedSalary!.toStringAsFixed(0) : '';
    _preferNotToSpecify = p.preferNotToSpecifySalary;
    _paymentTerm = null;
  }

  @override
  void dispose() {
    _salaryCtrl.dispose();
    _titleCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final salary = double.tryParse(_salaryCtrl.text.trim());
    ref.read(profileProvider.notifier).updateJobPreferences(
          interests: _interests,
          positionLevel: _positionLevel,
          jobType: _jobTypeSelected.isEmpty ? '' : _jobTypeSelected.first,
          workplace: _workplaceSelected.isEmpty ? '' : _workplaceSelected.first,
          expectedSalary: _preferNotToSpecify ? null : salary,
          preferNotToSpecifySalary: _preferNotToSpecify,
        );
    if (!mounted) return;
    SuccessBanner.show(context, 'Your Job Preferences has been updated.');
    context.pop();
  }

  void _addInterest() {
    final title = _titleCtrl.text.trim();
    final category = _categoryCtrl.text.trim();
    if (title.isEmpty || category.isEmpty) return;
    _titleCtrl.clear();
    _categoryCtrl.clear();
    setState(() {
      _interests = [
        ..._interests,
        JobInterest(title: title, category: category),
      ];
    });
  }

  void _removeInterest(int index) {
    setState(() {
      final list = List<JobInterest>.from(_interests);
      list.removeAt(index);
      _interests = list;
    });
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: IthakiTheme.textPrimary,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        title: 'Edit Job Preferences',
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
              // ── Section 1: Job Interests ──────────────────────────────
              _sectionTitle('Job Interests'),
              if (_interests.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'No interests added yet.',
                    style: TextStyle(
                        fontSize: 13, color: IthakiTheme.textSecondary),
                  ),
                )
              else
                ..._interests.asMap().entries.map((e) {
                  final interest = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${interest.title} — ${interest.category}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: IthakiTheme.textPrimary),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          color: IthakiTheme.textSecondary,
                          onPressed: () => _removeInterest(e.key),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _titleCtrl,
                      decoration: InputDecoration(
                        hintText: 'Job interest title',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: IthakiTheme.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _categoryCtrl,
                      decoration: InputDecoration(
                        hintText: 'Category',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: IthakiTheme.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add,
                        color: IthakiTheme.primaryPurple),
                    onPressed: _addInterest,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Section 2: Position Level ─────────────────────────────
              _sectionTitle('Position Level'),
              IthakiDropdown<String>(
                label: 'Position Level',
                hint: 'Select level',
                value: _positionLevel.isEmpty ? null : _positionLevel,
                items: const [
                  'Junior',
                  'Mid-level',
                  'Senior',
                  'Lead',
                  'Manager',
                  'Director',
                ]
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _positionLevel = v ?? ''),
              ),

              const SizedBox(height: 24),

              // ── Section 3: Job Type ───────────────────────────────────
              _sectionTitle('Job Type'),
              IthakiChipGroup(
                options: const [
                  'Full Time',
                  'Part Time',
                  'Contract',
                  'Freelance',
                  'Internship',
                ],
                selected: _jobTypeSelected,
                onChanged: (s) => setState(() => _jobTypeSelected = s),
                maxSelect: 1,
              ),

              const SizedBox(height: 24),

              // ── Section 4: Workplace Format ───────────────────────────
              _sectionTitle('Workplace Format'),
              IthakiChipGroup(
                options: const ['On-site', 'Remote', 'Hybrid'],
                selected: _workplaceSelected,
                onChanged: (s) => setState(() => _workplaceSelected = s),
                maxSelect: 1,
              ),

              const SizedBox(height: 24),

              // ── Section 5: Expected Payment ───────────────────────────
              IthakiSalaryInput(
                amountController: _salaryCtrl,
                paymentTerm: _paymentTerm,
                paymentTermOptions: const [
                  SearchItem(id: 'monthly', label: 'Monthly'),
                  SearchItem(id: 'yearly', label: 'Yearly'),
                ],
                onPaymentTermChanged: (v) =>
                    setState(() => _paymentTerm = v),
                preferNotToSpecify: _preferNotToSpecify,
                onPreferNotToSpecifyChanged: (v) =>
                    setState(() => _preferNotToSpecify = v),
              ),

              const SizedBox(height: 28),

              // ── Save button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: IthakiButton('Save', onPressed: _save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
