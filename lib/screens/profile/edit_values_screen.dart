// lib/screens/profile/edit_values_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';

const _kMaxValues = 5;

const _kValueOptions = [
  'Integrity', 'Responsibility', 'Teamwork', 'Respect',
  'Growth & Learning', 'Innovation', 'Creativity', 'Transparency',
  'Empathy', 'Accountability', 'Work-Life Balance', 'Open Communication',
  'Reliability', 'Adaptability', 'Problem-Solving', 'Ownership',
  'Customer Focus', 'Ambition', 'Initiative', 'Collaboration',
];

class EditValuesScreen extends ConsumerStatefulWidget {
  const EditValuesScreen({super.key});

  @override
  ConsumerState<EditValuesScreen> createState() => _EditValuesScreenState();
}

class _EditValuesScreenState extends ConsumerState<EditValuesScreen> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(ref.read(profileValuesProvider).requireValue);
  }

  void _save() {
    ref.read(profileValuesProvider.notifier).save(_selected.toList());
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Values'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.viewPaddingOf(context).bottom + 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: IthakiTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────
              const Text('Values',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              Text(
                'Choose up to $_kMaxValues values that best represent what matters most to you professionally.',
                style: const TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 24),

              // ── Chip group ───────────────────────────────────────────
              IthakiChipGroup(
                options: _kValueOptions,
                selected: _selected,
                maxSelect: _kMaxValues,
                onChanged: (next) => setState(() {
                  _selected = Set<String>.from(next);
                }),
              ),
              const SizedBox(height: 28),
              IthakiButton('Save', onPressed: _selected.isNotEmpty ? _save : null),
            ],
          ),
        ),
      ),
    );
  }
}
