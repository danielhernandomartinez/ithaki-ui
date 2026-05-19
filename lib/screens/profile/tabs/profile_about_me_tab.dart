import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../config/app_config.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../widgets/profile_empty_state_card.dart';
import '../../../widgets/profile_video_player.dart';

class ProfileAboutMeTab extends ConsumerWidget {
  const ProfileAboutMeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final aboutMe =
        ref.watch(profileAboutMeProvider).value ?? const ProfileAboutMe();
    final hasBio = aboutMe.bio.trim().isNotEmpty;
    final showVideo = AppConfig.showVideoIntroductionInProfile;
    final hasVideo = showVideo && (aboutMe.videoUrl?.trim().isNotEmpty ?? false);

    if (!hasBio && !hasVideo) {
      return ProfileEmptyStateCard(
        title: l.profileAboutMeTitle,
        description: l.aboutMeEmptyDescription,
        buttonLabel: l.addAboutMeInformation,
        buttonIcon: const IthakiIcon('plus', size: 16),
        onPressed: () => context.push(Routes.profileAboutMe),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.profileAboutMeTitle,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          if (hasBio) ...[
            const SizedBox(height: 12),
            Text(aboutMe.bio,
                style: const TextStyle(
                    fontSize: 16, color: IthakiTheme.textPrimary, height: 1.5)),
          ],
        ]),
        const SizedBox(height: 20),
        if (hasVideo) ...[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.videoIntroductionTitle,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 8),
            ProfileVideoPreview(source: aboutMe.videoUrl!),
          ]),
          const SizedBox(height: 20),
        ],
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.profileAboutMe),
          icon: const IthakiIcon('edit-pencil', size: 20),
          label: Text(showVideo
              ? l.editAboutMeVideo
              : '${l.edit} ${l.profileAboutMeTitle}'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: IthakiTheme.softGraphite),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            minimumSize: const Size(0, 40),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }
}
