import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../providers/assessment_provider.dart';

class QuizOptionTile extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  const QuizOptionTile({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class QuizQuestionOptions extends StatelessWidget {
  final Question question;
  final dynamic currentAnswer;
  final void Function(dynamic) onAnswer;

  const QuizQuestionOptions({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: switch (question) {
        SingleSelectQuestion q => _SingleSelectOptions(
            question: q,
            selected: currentAnswer as String?,
            onSelect: onAnswer,
          ),
        MultiSelectQuestion q => _MultiSelectOptions(
            question: q,
            selected: (currentAnswer as List?)?.cast<String>() ?? [],
            onSelect: onAnswer,
          ),
        RangeNumberQuestion q => _RangeNumberOptions(
            question: q,
            selected: currentAnswer as int?,
            onSelect: onAnswer,
          ),
        RangeSymbolQuestion q => _RangeSymbolOptions(
            question: q,
            selected: currentAnswer as int?,
            onSelect: onAnswer,
          ),
        ImageSelectQuestion q => _ImageSelectOptions(
            question: q,
            selected: currentAnswer as String?,
            onSelect: onAnswer,
          ),
      },
    );
  }
}

class _SingleSelectOptions extends StatelessWidget {
  final SingleSelectQuestion question;
  final String? selected;
  final void Function(String) onSelect;

  const _SingleSelectOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options
          .map(
            (opt) => QuizOptionTile(
              selected: selected == opt,
              onTap: () => onSelect(opt),
              child: Text(opt, style: IthakiTheme.bodySmall),
            ),
          )
          .toList(),
    );
  }
}

class _MultiSelectOptions extends StatelessWidget {
  final MultiSelectQuestion question;
  final List<String> selected;
  final void Function(List<String>) onSelect;

  const _MultiSelectOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options.map((opt) {
        final isSelected = selected.contains(opt);
        return QuizOptionTile(
          selected: isSelected,
          onTap: () {
            final updated = List<String>.from(selected);
            if (isSelected) {
              updated.remove(opt);
            } else if (updated.length < question.maxSelections) {
              updated.add(opt);
            }
            onSelect(updated);
          },
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.borderLight,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? IthakiTheme.primaryPurple : Colors.transparent,
                ),
                child: isSelected
                    ? const Center(
                        child: Text(
                          '✓',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      )
                    : null,
              ),
              Expanded(child: Text(opt, style: IthakiTheme.bodySmall)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RangeNumberOptions extends StatelessWidget {
  final RangeNumberQuestion question;
  final int? selected;
  final void Function(int) onSelect;

  const _RangeNumberOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            question.minLabel,
            style: IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
        ),
        ...List.generate(
          question.max - question.min + 1,
          (i) {
            final value = question.min + i;
            return QuizOptionTile(
              selected: selected == value,
              onTap: () => onSelect(value),
              child: Center(
                child: Text(
                  '$value',
                  style: IthakiTheme.bodySmall.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            question.maxLabel,
            style: IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _RangeSymbolOptions extends StatelessWidget {
  final RangeSymbolQuestion question;
  final int? selected;
  final void Function(int) onSelect;

  const _RangeSymbolOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final idx = entry.key;
        final opt = entry.value;
        return QuizOptionTile(
          selected: selected == idx,
          onTap: () => onSelect(idx),
          child: Column(
            children: [
              Text(opt.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(opt.label, style: IthakiTheme.bodySmall.copyWith(color: opt.color)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ImageSelectOptions extends StatelessWidget {
  final ImageSelectQuestion question;
  final String? selected;
  final void Function(String) onSelect;

  const _ImageSelectOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            question.imageAsset,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: IthakiTheme.placeholderBg,
              child: Center(
                child: IthakiIcon('upload-cloud', size: 40, color: IthakiTheme.textSecondary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...question.options.map(
          (opt) => QuizOptionTile(
            selected: selected == opt,
            onTap: () => onSelect(opt),
            child: Text(opt, style: IthakiTheme.bodySmall),
          ),
        ),
      ],
    );
  }
}
