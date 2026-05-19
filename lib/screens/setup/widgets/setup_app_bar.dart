import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../config/app_config.dart';
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

    final basics = _profileBasicsOrNull(ref);

    final firstName = _firstNonEmpty(basics?.firstName, null);
    final lastName = _firstNonEmpty(basics?.lastName, null);

    return IthakiAppBar(
      showMenuAndAvatar: true,
      avatarInitials: _initials(firstName, lastName),
      avatarUrl: basics?.photoUrl,
    );
  }
}

ProfileBasics? _profileBasicsOrNull(WidgetRef ref) {
  if (!ref.exists(profileBasicsProvider) &&
      !AppConfig.useMockData &&
      AppConfig.apiBaseUrl.isEmpty) {
    return null;
  }
  try {
    return ref.watch(profileBasicsProvider).value;
  } catch (_) {
    return null;
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
