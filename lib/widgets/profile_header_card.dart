import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../routes.dart';
import '../utils/profile_photo_image.dart';

class ProfileHeaderCard extends ConsumerWidget {
  final ProfileBasics basics;

  const ProfileHeaderCard({super.key, required this.basics});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final prefs = ref.watch(profileJobPreferencesProvider).value;
    final photoImage = profilePhotoImageProvider(basics.photoUrl);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: IthakiTheme.primaryPurple,
            backgroundImage: photoImage,
            onBackgroundImageError: photoImage == null
                ? null
                : (error, _) {
                    debugPrint(
                      '[profilePhoto] header image failed to load: $error',
                    );
                  },
            child: photoImage == null
                ? Text(
                    '${basics.firstName.isNotEmpty ? basics.firstName[0] : '?'}${basics.lastName.isNotEmpty ? basics.lastName[0] : '?'}',
                    style: const TextStyle(
                        color: IthakiTheme.backgroundWhite,
                        fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${basics.firstName} ${basics.lastName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                        : l.roleJobSeeker,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, color: IthakiTheme.textSecondary),
              ),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        _contactRow(const IthakiIcon('envelope', size: 16), basics.email),
        const SizedBox(height: 4),
        _contactRow(const IthakiIcon('phone', size: 20), basics.phone),
        const SizedBox(height: 8),
        Text(
          l.contactVisibilityNote,
          style:
              const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
        ),
        const Divider(height: 24),
        Row(children: [
          Expanded(child: _infoCell(l.genderLabel, basics.gender)),
          Expanded(child: _infoCell(l.ageLabel, _calcAge(basics.dateOfBirth))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _infoCell(l.citizenshipLabel, basics.citizenship)),
          Expanded(child: _infoCell(l.locationLabel, basics.residence)),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.push(Routes.profileBasics),
            icon: const IthakiIcon('edit-pencil', size: 16),
            label: Text(
              l.editProfileBasicsButton,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              foregroundColor: IthakiTheme.textPrimary,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _contactRow(Widget icon, String text) => Row(children: [
        icon,
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
          ),
        ),
      ]);

  Widget _infoCell(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 11, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
