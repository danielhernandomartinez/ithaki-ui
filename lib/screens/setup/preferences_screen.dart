import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/setup_provider.dart';

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

  void _openPositionPicker(AppLocalizations l, List<SearchItem> positionLevels) {
    SearchBottomSheet.show(
      context,
      l.positionLevelLabel,
      positionLevels,
      (item) => setState(() => _positionLevel = item.subtitle.isNotEmpty
          ? '${item.label} ${item.subtitle}'
          : item.label),
      searchHint: l.searchHint,
      selectLabel: l.selectAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final positionLevels = [
      SearchItem(id: 'intern', label: l.positionIntern, subtitle: '[0 years]'),
      SearchItem(id: 'junior', label: l.positionJunior, subtitle: '[0–2 years]'),
      SearchItem(id: 'mid', label: l.positionMid, subtitle: '[2–5 years]'),
      SearchItem(id: 'senior', label: l.positionSenior, subtitle: '[5–8 years]'),
      SearchItem(id: 'lead', label: l.positionLead, subtitle: '[8–12 years]'),
      SearchItem(id: 'manager', label: l.positionManager, subtitle: '[10+ years]'),
      SearchItem(id: 'director', label: l.positionDirector, subtitle: '[12+ years]'),
    ];

    final paymentTermOptions = [
      SearchItem(id: 'monthly', label: l.payMonthly),
      SearchItem(id: 'weekly', label: l.payWeekly),
      SearchItem(id: 'yearly', label: l.payYearly),
      SearchItem(id: 'hourly', label: l.payHourly),
      SearchItem(id: 'daily', label: l.payDaily),
    ];

    final jobTypeOptions = [l.jobFullTime, l.jobPartTime, l.jobContract, l.jobFreelance, l.jobInternship];
    final workplaceOptions = [l.workOnSite, l.workRemote, l.workHybrid];

    return IthakiScreenLayout(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IthakiStepTabs(
                steps: [l.stepLocation, l.stepJobInterests, l.stepPreferences, l.stepValues, l.stepCommunication],
                currentIndex: 2,
                completedUpTo: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.preferencesHeading, style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    Text(
                      l.preferencesDescription,
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 24),
                    IthakiSelectorField(
                      label: l.positionLevelLabel,
                      value: _positionLevel,
                      hint: l.positionLevelHint,
                      onTap: () => _openPositionPicker(l, positionLevels),
                      optional: true,
                    ),
                    const SizedBox(height: 24),
                    IthakiChipSection(
                      title: l.jobTypeTitle,
                      description: l.jobTypeDescription,
                      options: jobTypeOptions,
                      selected: _selectedJobTypes,
                      onChanged: (next) => setState(() {
                        _selectedJobTypes.clear();
                        _selectedJobTypes.addAll(next);
                      }),
                    ),
                    const SizedBox(height: 24),
                    IthakiChipSection(
                      title: l.workplaceFormatTitle,
                      description: l.workplaceFormatDescription,
                      options: workplaceOptions,
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
                      paymentTermOptions: paymentTermOptions,
                      onPaymentTermChanged: (val) => setState(() => _paymentTerm = val),
                      preferNotToSpecify: _preferNotToSpecify,
                      onPreferNotToSpecifyChanged: (val) => setState(() => _preferNotToSpecify = val),
                      expectedPaymentLabel: l.expectedPaymentLabel,
                      fromLabel: l.fromLabel,
                      paymentTermLabel: l.paymentTermTitle,
                      paymentTermPlaceholder: l.paymentTermPlaceholder,
                      currencySymbol: l.currencySymbol,
                      preferNotToSpecifyLabel: l.preferNotToSpecify,
                      paymentTermPickerTitle: l.paymentTermTitle,
                      paymentTermPickerSearchHint: l.searchHint,
                      paymentTermPickerSelectLabel: l.selectAction,
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      l.continueButton,
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
                              context.push('/setup/values');
                            }
                          : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      l.backButton,
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
