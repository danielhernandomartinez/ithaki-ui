import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/setup_provider.dart';

const _maxValues = 5;

class ValuesScreen extends ConsumerStatefulWidget {
  const ValuesScreen({super.key});

  @override
  ConsumerState<ValuesScreen> createState() => _ValuesScreenState();
}

class _ValuesScreenState extends ConsumerState<ValuesScreen> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final valueOptions = [
      l.valueIntegrity, l.valueResponsibility, l.valueTeamwork, l.valueRespect,
      l.valueGrowth, l.valueInnovation, l.valueCreativity, l.valueTransparency,
      l.valueEmpathy, l.valueAccountability, l.valueWorkLifeBalance, l.valueOpenCommunication,
      l.valueReliability, l.valueAdaptability, l.valueProblemSolving, l.valueOwnership,
      l.valueCustomerFocus, l.valueAmbition, l.valueInitiative, l.valueCollaboration,
    ];

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
              IthakiStepTabs(
                steps: [l.stepLocation, l.stepJobInterests, l.stepPreferences, l.stepValues, l.stepCommunication],
                currentIndex: 3,
                completedUpTo: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.valuesHeading, style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    Text(
                      l.valuesDescription(_maxValues),
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 20),
                    IthakiChipGroup(
                      options: valueOptions,
                      selected: _selected,
                      maxSelect: _maxValues,
                      onChanged: (next) => setState(() {
                        _selected.clear();
                        _selected.addAll(next);
                      }),
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      l.continueButton,
                      onPressed: _selected.isNotEmpty
                          ? () {
                              ref.read(setupProvider.notifier).setValues(Set.of(_selected));
                              context.go('/setup/communication');
                            }
                          : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      l.backButton,
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.go('/setup/preferences'),
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
