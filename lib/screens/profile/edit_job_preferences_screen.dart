// lib/screens/profile/edit_job_preferences_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/success_banner.dart';

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
  late String _jobType;
  late String _workplace;
  late bool _preferNotToSpecify;
  late String _paymentTerm;

  final TextEditingController _salaryCtrl = TextEditingController();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileProvider);
    _interests = List<JobInterest>.from(p.jobInterests);
    _positionLevel = p.positionLevel;
    _jobType = p.jobType;
    _workplace = p.workplace;
    _salaryCtrl.text =
        p.expectedSalary != null ? p.expectedSalary!.toStringAsFixed(0) : '';
    _preferNotToSpecify = p.preferNotToSpecifySalary;
    _paymentTerm = 'Monthly';
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
          jobType: _jobType,
          workplace: _workplace,
          expectedSalary: _preferNotToSpecify ? null : salary,
          preferNotToSpecifySalary: _preferNotToSpecify,
        );
    SuccessBanner.show(context, 'Your Job Preferences has been updated.');
    context.pop();
  }

  void _addInterest() {
    final title = _titleCtrl.text.trim();
    final category = _categoryCtrl.text.trim();
    if (title.isEmpty || category.isEmpty) return;
    setState(() {
      _interests = [
        ..._interests,
        JobInterest(title: title, category: category),
      ];
      _titleCtrl.clear();
      _categoryCtrl.clear();
    });
  }

  void _removeInterest(int index) {
    setState(() {
      final list = List<JobInterest>.from(_interests);
      list.removeAt(index);
      _interests = list;
    });
  }

  Widget _multiChip(
      List<String> options, String selected, ValueChanged<String> onSelect) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final isSelected = selected == opt;
        return GestureDetector(
          onTap: () => onSelect(isSelected ? '' : opt),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? IthakiTheme.primaryPurple : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected
                    ? IthakiTheme.primaryPurple
                    : IthakiTheme.borderLight,
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : IthakiTheme.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: IthakiTheme.textPrimary,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Job Preferences',
          style: TextStyle(
            color: IthakiTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: IthakiTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
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
                ...List.generate(_interests.length, (i) {
                  final interest = _interests[i];
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
                          onPressed: () => _removeInterest(i),
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
              _multiChip(
                const [
                  'Full Time',
                  'Part Time',
                  'Contract',
                  'Freelance',
                  'Internship',
                ],
                _jobType,
                (v) => setState(() => _jobType = v),
              ),

              const SizedBox(height: 24),

              // ── Section 4: Workplace Format ───────────────────────────
              _sectionTitle('Workplace Format'),
              _multiChip(
                const ['On-site', 'Remote', 'Hybrid'],
                _workplace,
                (v) => setState(() => _workplace = v),
              ),

              const SizedBox(height: 24),

              // ── Section 5: Expected Payment ───────────────────────────
              _sectionTitle('Expected Payment'),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _salaryCtrl,
                      enabled: !_preferNotToSpecify,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Expected salary',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: IthakiTheme.textSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: IthakiTheme.primaryPurple),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey.shade200),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        filled: _preferNotToSpecify,
                        fillColor: _preferNotToSpecify
                            ? Colors.grey.shade100
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: DropdownButton<String>(
                      value: _paymentTerm,
                      items: const ['Monthly', 'Yearly']
                          .map((t) =>
                              DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _paymentTerm = v ?? 'Monthly'),
                      underline: const SizedBox(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _preferNotToSpecify,
                    activeColor: IthakiTheme.primaryPurple,
                    onChanged: (v) =>
                        setState(() => _preferNotToSpecify = v ?? false),
                  ),
                  const Text(
                    'Prefer not to specify',
                    style: TextStyle(
                        fontSize: 14, color: IthakiTheme.textPrimary),
                  ),
                ],
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
