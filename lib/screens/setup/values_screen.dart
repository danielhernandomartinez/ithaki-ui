import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/reference_data_provider.dart';
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
    final valuesAsync = ref.watch(personalityValuesListProvider);
    final hasLoadError = valuesAsync.hasError;
    final loadErrorText = valuesAsync.error?.toString();
    final valueOptions = valuesAsync.value
            ?.map((v) => v.title)
            .where((v) => v.trim().isNotEmpty)
            .toList() ??
        const <String>[];

    return IthakiScreenLayout(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      horizontalPadding: 0,
      verticalPadding: 8,
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
                    if (hasLoadError) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: IthakiTheme.softGray,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: IthakiTheme.borderLight),
                        ),
                        child: Text(
                          loadErrorText ?? 'Failed to load values from server.',
                          style: IthakiTheme.captionRegular,
                        ),
                      ),
                    ],
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
                              context.push(Routes.setupCommunication);
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
