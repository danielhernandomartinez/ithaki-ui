import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/setup_provider.dart';

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

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
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
                steps: ['Location', 'Job Interests', 'Preferences', 'Values', 'Communication'],
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
                    IthakiSelectorField(
                      label: 'Position Level',
                      value: _positionLevel,
                      hint: 'Select your position level',
                      onTap: _openPositionPicker,
                      optional: true,
                    ),
                    const SizedBox(height: 24),
                    IthakiChipSection(
                      title: 'Job Type',
                      description: 'Choose the types of employment you\'re interested in. You can select more than one option.',
                      options: _jobTypeOptions,
                      selected: _selectedJobTypes,
                      onChanged: (next) => setState(() {
                        _selectedJobTypes.clear();
                        _selectedJobTypes.addAll(next);
                      }),
                    ),
                    const SizedBox(height: 24),
                    IthakiChipSection(
                      title: 'Workplace Format',
                      description: 'Select your preferred workplace formats. You can select more than one option.',
                      options: _workplaceOptions,
                      selected: _selectedWorkplaceFormats,
                      onChanged: (next) => setState(() {
                        _selectedWorkplaceFormats.clear();
                        _selectedWorkplaceFormats.addAll(next);
                      }),
                    ),
                    const SizedBox(height: 24),
                    IthakiSalaryInput(
                      amountController: _salaryController,
                      paymentTerm: _paymentTerm,
                      paymentTermOptions: _paymentTermOptions,
                      onPaymentTermChanged: (val) => setState(() => _paymentTerm = val),
                      preferNotToSpecify: _preferNotToSpecify,
                      onPreferNotToSpecifyChanged: (val) => setState(() => _preferNotToSpecify = val),
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      'Continue',
                      onPressed: _canContinue
                          ? () {
                              ref.read(setupProvider.notifier).setPreferences(
                                positionLevel: _positionLevel,
                                jobTypes: Set.of(_selectedJobTypes),
                                workplaceFormats: Set.of(_selectedWorkplaceFormats),
                                salary: _salaryController.text,
                                paymentTerm: _paymentTerm,
                                preferNotToSpecifySalary: _preferNotToSpecify,
                              );
                              context.go('/setup/values');
                            }
                          : null,
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
