import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../providers/profile_provider.dart';
import '../../../providers/registration_provider.dart';

class SetupAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SetupAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registration = ref.watch(registrationProvider);
    final hasRegistrationName = registration.name.trim().isNotEmpty ||
        registration.lastName.trim().isNotEmpty;

    if (hasRegistrationName) {
      return IthakiAppBar(
        showMenuAndAvatar: true,
        avatarInitials: _initials(registration.name, registration.lastName),
      );
    }

    final basics = ref.watch(profileBasicsProvider).value;

    final firstName = _firstNonEmpty(basics?.firstName, null);
    final lastName = _firstNonEmpty(basics?.lastName, null);

    return IthakiAppBar(
      showMenuAndAvatar: true,
      avatarInitials: _initials(firstName, lastName),
      avatarUrl: basics?.photoUrl,
    );
  }
}

String _firstNonEmpty(String? preferred, String? fallback) {
  final value = preferred?.trim() ?? '';
  return value.isNotEmpty ? value : fallback?.trim() ?? '';
}

String _initials(String firstName, String lastName) {
  final first = firstName.trim();
  final last = lastName.trim();
  final result = [
    if (first.isNotEmpty) first.characters.first,
    if (last.isNotEmpty) last.characters.first,
  ].join().toUpperCase();
  return result;
}
