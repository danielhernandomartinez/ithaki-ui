import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

const _valueOptions = [
  'Integrity', 'Responsibility', 'Teamwork', 'Respect',
  'Growth & Learning', 'Innovation', 'Creativity', 'Transparency',
  'Empathy', 'Accountability', 'Work-Life Balance', 'Open Communication',
  'Reliability', 'Adaptability', 'Problem-Solving', 'Ownership',
  'Customer Focus', 'Ambition', 'Initiative', 'Collaboration',
];

const _maxValues = 5;

class ValuesScreen extends StatefulWidget {
  const ValuesScreen({super.key});

  @override
  State<ValuesScreen> createState() => _ValuesScreenState();
}

class _ValuesScreenState extends State<ValuesScreen> {
  final Set<String> _selected = {};

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
                currentIndex: 3,
                completedUpTo: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Values', style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    const Text(
                      'Pick the values that feel closest to you. You can choose up to $_maxValues.',
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 20),
                    IthakiChipGroup(
                      options: _valueOptions,
                      selected: _selected,
                      maxSelect: _maxValues,
                      onChanged: (next) => setState(() {
                        _selected.clear();
                        _selected.addAll(next);
                      }),
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      'Finish Setup',
                      onPressed: _selected.isNotEmpty ? () => context.go('/setup/communication') : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      'Back',
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
