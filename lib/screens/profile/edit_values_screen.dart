import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/reference_data_provider.dart';
import '../../widgets/panel_scaffold.dart';

const _kMaxValues = 5;

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
    _selected = Set<String>.from(
      ref.read(profileValuesProvider).asData?.value ?? const [],
    );
  }

  Future<void> _save() async {
    try {
      await ref.read(profileValuesProvider.notifier).save(_selected.toList());
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final valuesAsync = ref.watch(personalityValuesListProvider);
    final options = valuesAsync.value
            ?.map((v) => v.title.trim())
            .where((v) => v.isNotEmpty)
            .toSet()
            .toList() ??
        _selected.toList();

    return PanelScaffold(
      title: l.editValuesTitle,
      onSave: _selected.isNotEmpty ? _save : null,
      children: [
        Text(
          l.editValuesTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.chooseValuesDescription(_kMaxValues),
          style: const TextStyle(
            fontSize: 13,
            color: IthakiTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (valuesAsync.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (valuesAsync.hasError)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.softGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            child: Text(
              valuesAsync.error.toString(),
              style: IthakiTheme.captionRegular,
            ),
          )
        else
          IthakiChipGroup(
            options: options,
            selected: _selected,
            maxSelect: _kMaxValues,
            onChanged: (next) => setState(() {
              _selected = Set<String>.from(next);
            }),
          ),
      ],
    );
  }
}
