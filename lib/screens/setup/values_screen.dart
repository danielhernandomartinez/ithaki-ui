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

  void _toggle(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else if (_selected.length < _maxValues) {
        _selected.add(value);
      }
    });
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _valueOptions.map((value) {
                        final isSelected = _selected.contains(value);
                        final isDisabled = !isSelected && _selected.length >= _maxValues;
                        return GestureDetector(
                          onTap: isDisabled ? null : () => _toggle(value),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF0EAFA) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? IthakiTheme.primaryPurple
                                    : isDisabled
                                        ? IthakiTheme.borderLight.withValues(alpha: 0.5)
                                        : IthakiTheme.borderLight,
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
                                  value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? IthakiTheme.primaryPurple
                                        : isDisabled
                                            ? IthakiTheme.textHint
                                            : IthakiTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      'Finish Setup',
                      onPressed: _selected.isNotEmpty ? () => context.go('/home') : null,
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
