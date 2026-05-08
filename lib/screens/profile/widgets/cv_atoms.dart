import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/profile_models.dart';
import '../../../utils/profile_photo_image.dart';

class CvAvatarBadge extends StatelessWidget {
  const CvAvatarBadge({super.key, required this.initials, this.photoPath});

  final String initials;
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final photoImage = profilePhotoImageProvider(photoPath);
    return CircleAvatar(
      radius: 24,
      backgroundColor: IthakiTheme.softGraphite,
      backgroundImage: photoImage,
      onBackgroundImageError: photoImage == null
          ? null
          : (error, _) {
              debugPrint('[cvPhoto] avatar image failed to load: $error');
            },
      child: photoImage != null
          ? null
          : Text(
              initials,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: IthakiTheme.backgroundWhite,
              ),
            ),
    );
  }
}

class CvContactRow extends StatelessWidget {
  const CvContactRow({super.key, required this.icon, required this.value});

  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: IthakiTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class CvInfoCell extends StatelessWidget {
  const CvInfoCell({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: IthakiTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class CvMetaValue extends StatelessWidget {
  const CvMetaValue({
    super.key,
    required this.width,
    required this.icon,
    required this.value,
    this.isStrong = false,
  });

  final double width;
  final String icon;
  final String value;
  final bool isStrong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isStrong ? FontWeight.w700 : FontWeight.w500,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CvSkillChip extends StatelessWidget {
  const CvSkillChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          color: IthakiTheme.textPrimary,
        ),
      ),
    );
  }
}

class CvKeyValueRow extends StatelessWidget {
  const CvKeyValueRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.softGraphite,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CvLanguageRow extends StatelessWidget {
  const CvLanguageRow({super.key, required this.language});

  final Language language;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          IthakiLanguageFlag(language.language, size: 32),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              language.language,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
          Text(
            language.proficiency,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
