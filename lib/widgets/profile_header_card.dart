import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/profile_provider.dart';
import '../routes.dart';

class ProfileHeaderCard extends ConsumerWidget {
  final ProfileBasics basics;

  const ProfileHeaderCard({super.key, required this.basics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(profileJobPreferencesProvider).value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: IthakiTheme.primaryPurple,
            backgroundImage: basics.photoUrl != null
                ? FileImage(File(basics.photoUrl!))
                : null,
            child: basics.photoUrl == null
                ? Text(
                    '${basics.firstName.isNotEmpty ? basics.firstName[0] : '?'}${basics.lastName.isNotEmpty ? basics.lastName[0] : '?'}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${basics.firstName} ${basics.lastName}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary),
            ),
            Text(
              prefs != null && prefs.jobInterests.isNotEmpty
                  ? prefs.jobInterests.first.title
                  : prefs != null && prefs.jobType.isNotEmpty
                      ? prefs.jobType
                      : 'Job Seeker',
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary),
            ),
          ]),
        ]),
        const SizedBox(height: 12),
        _contactRow(const IthakiIcon('envelope', size: 16), basics.email),
        const SizedBox(height: 4),
        _contactRow(const IthakiIcon('phone', size: 20), basics.phone),
        const SizedBox(height: 8),
        const Text(
          "Employers won't see your contact details until you apply for a job or accept an invitation.",
          style: TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
        ),
        const Divider(height: 24),
        Row(children: [
          Expanded(child: _infoCell('Gender', basics.gender)),
          Expanded(child: _infoCell('Age', _calcAge(basics.dateOfBirth))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _infoCell('Citizenship', basics.citizenship)),
          Expanded(child: _infoCell('Location', basics.residence)),
        ]),
        const SizedBox(height: 12),
        IthakiOutlineButton(
          'Edit Profile Basics',
          icon: const IthakiIcon('edit-pencil', size: 16),
          onPressed: () => context.push(Routes.profileBasics),
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ]),
    );
  }

  Widget _contactRow(Widget icon, String text) => Row(children: [
        icon,
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.textSecondary)),
      ]);

  Widget _infoCell(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
        ],
      );

  String _calcAge(String dob) {
    final parts = dob.split('-');
    if (parts.length < 3) return '';
    final year = int.tryParse(parts[2]);
    if (year == null) return '';
    return '${DateTime.now().year - year}';
  }
}
