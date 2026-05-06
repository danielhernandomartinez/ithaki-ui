import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';

class ProfileValuesTab extends ConsumerWidget {
  const ProfileValuesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final values = ref.watch(profileValuesProvider).value ?? const [];
    if (values.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.noValuesAddedYet,
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 12),
          IthakiOutlineButton(
            l.editValuesTitle,
            icon: const IthakiIcon('edit-pencil', size: 16),
            onPressed: () => context.push(Routes.profileValues),
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ]),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values.map(_chip).toList(),
        ),
        const SizedBox(height: 12),
        IthakiOutlineButton(
          l.editValuesTitle,
          icon: const IthakiIcon('edit-pencil', size: 16),
          onPressed: () => context.push(Routes.profileValues),
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ]),
    );
  }

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundViolet,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFDDD5F8)),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.primaryPurple)),
      );
}
