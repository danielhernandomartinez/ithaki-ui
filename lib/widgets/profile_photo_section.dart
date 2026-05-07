import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../utils/profile_photo_image.dart';

class ProfilePhotoSection extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onPick;

  const ProfilePhotoSection({
    super.key,
    required this.photoPath,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final photoImage = profilePhotoImageProvider(photoPath);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: IthakiTheme.primaryPurple,
            backgroundImage: photoImage,
            child: photoImage == null
                ? const IthakiIcon('profile',
                    size: 24, color: IthakiTheme.backgroundWhite)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.photoFileLimit,
                  style:
                      const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  l.photoRecommendation,
                  style:
                      const TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
                ),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onPick,
            icon: const IthakiIcon('upload-cloud',
                size: 16, color: IthakiTheme.textPrimary),
            label: Text(photoPath == null ? l.uploadPhoto : l.replacePhoto),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: IthakiTheme.borderLight),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              foregroundColor: IthakiTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
