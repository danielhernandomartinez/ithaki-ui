import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../theme/ithaki_theme.dart';
import '../../widgets/ithaki_app_bar.dart';
import '../../widgets/ithaki_button.dart';
import '../../widgets/ithaki_step_tabs.dart';
import '../../widgets/search_bottom_sheet.dart';
import '../../models/search_item.dart';

const _positionLevels = [
  SearchItem(id: 'intern', label: 'Intern', subtitle: '[0 years]'),
  SearchItem(id: 'junior', label: 'Junior', subtitle: '[0–2 years]'),
  SearchItem(id: 'mid', label: 'Mid-Level', subtitle: '[2–5 years]'),
  SearchItem(id: 'senior', label: 'Senior', subtitle: '[5–8 years]'),
  SearchItem(id: 'lead', label: 'Lead', subtitle: '[8–12 years]'),
  SearchItem(id: 'manager', label: 'Manager', subtitle: '[10+ years]'),
  SearchItem(id: 'director', label: 'Director', subtitle: '[12+ years]'),
];

const _paymentTermOptions = [
  SearchItem(id: 'monthly', label: 'Monthly'),
  SearchItem(id: 'weekly', label: 'Weekly'),
  SearchItem(id: 'yearly', label: 'Yearly'),
  SearchItem(id: 'hourly', label: 'Hourly'),
  SearchItem(id: 'daily', label: 'Daily'),
];

const _jobTypeOptions = ['Full-Time', 'Part-Time', 'Contract', 'Freelance', 'Internship'];
const _workplaceOptions = ['On-site', 'Remote', 'Hybrid'];

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String? _positionLevel;
  final Set<String> _selectedJobTypes = {};
  final Set<String> _selectedWorkplaceFormats = {};
  final _salaryController = TextEditingController();
  String? _paymentTerm;
  bool _preferNotToSpecify = false;

  bool get _canContinue =>
      _positionLevel != null ||
      _selectedJobTypes.isNotEmpty ||
      _selectedWorkplaceFormats.isNotEmpty;

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }

  void _openPositionPicker() {
    SearchBottomSheet.show(
      context,
      'Position Level',
      _positionLevels,
      (item) => setState(() => _positionLevel = item.subtitle.isNotEmpty
          ? '${item.label} ${item.subtitle}'
          : item.label),
    );
  }

  void _openPaymentTermPicker() {
    SearchBottomSheet.show(
      context,
      'Payment Term',
      _paymentTermOptions,
      (item) => setState(() => _paymentTerm = item.label),
    );
  }

  Widget _selectorField({required String label, required String? value, required String hint, required VoidCallback onTap, bool optional = false}) {
    final selected = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)),
            if (optional)
              const Text(' (optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: IthakiTheme.textSecondary)),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(fontSize: 14, color: selected ? IthakiTheme.textPrimary : IthakiTheme.textHint),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20, color: IthakiTheme.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chipSection({required String title, required String description, required List<String> options, required Set<String> selected}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)),
        const SizedBox(height: 4),
        Text(description, style: IthakiTheme.bodyRegular),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () => setState(() {
                if (isSelected) { selected.remove(option); } else { selected.add(option); }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF0EAFA) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(Icons.check, size: 14, color: IthakiTheme.primaryPurple),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _salarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Expected Payment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary)),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount field
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('From', style: TextStyle(fontSize: 12, color: IthakiTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: IthakiTheme.borderLight),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _salaryController,
                            enabled: !_preferNotToSpecify,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: const TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
                            decoration: const InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(color: IthakiTheme.textHint),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const Text('€', style: TextStyle(fontSize: 16, color: IthakiTheme.textSecondary)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Payment term dropdown
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Term', style: TextStyle(fontSize: 12, color: IthakiTheme.textSecondary)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: _preferNotToSpecify ? null : _openPaymentTermPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _paymentTerm != null ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
                          width: _paymentTerm != null ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _paymentTerm ?? 'Monthly',
                              style: TextStyle(
                                fontSize: 14,
                                color: _paymentTerm != null ? IthakiTheme.textPrimary : IthakiTheme.textHint,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, size: 18, color: IthakiTheme.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => setState(() {
            _preferNotToSpecify = !_preferNotToSpecify;
            if (_preferNotToSpecify) _salaryController.clear();
          }),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: _preferNotToSpecify ? IthakiTheme.primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _preferNotToSpecify ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
                    width: 1.5,
                  ),
                ),
                child: _preferNotToSpecify
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 8),
              const Text('Prefer not to specify', style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IthakiStepTabs(
                steps: ['Location', 'Job Interests', 'Preferences', 'Values'],
                currentIndex: 2,
                completedUpTo: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Job Preferences', style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    const Text(
                      'Set your desired salary, position level, contract type, and work format '
                      '(remote, on-site, or hybrid) to help us match you with the most relevant opportunities.',
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 24),
                    _selectorField(
                      label: 'Position Level',
                      value: _positionLevel,
                      hint: 'Select your position level',
                      onTap: _openPositionPicker,
                      optional: true,
                    ),
                    const SizedBox(height: 24),
                    _chipSection(
                      title: 'Job Type',
                      description: 'Choose the types of employment you\'re interested in. You can select more than one option.',
                      options: _jobTypeOptions,
                      selected: _selectedJobTypes,
                    ),
                    const SizedBox(height: 24),
                    _chipSection(
                      title: 'Workplace Format',
                      description: 'Select your preferred workplace formats. You can select more than one option.',
                      options: _workplaceOptions,
                      selected: _selectedWorkplaceFormats,
                    ),
                    const SizedBox(height: 24),
                    _salarySection(),
                    const SizedBox(height: 40),
                    IthakiButton(
                      'Continue',
                      onPressed: _canContinue ? () => context.go('/setup/values') : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      'Back',
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.go('/setup/job-interests'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
