import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../utils/open_resource.dart';
import '../../../widgets/profile_empty_state_card.dart';

class ProfileAboutMeTab extends ConsumerWidget {
  const ProfileAboutMeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutMe =
        ref.watch(profileAboutMeProvider).value ?? const ProfileAboutMe();
    if (aboutMe.bio.isEmpty) {
      return ProfileEmptyStateCard(
        title: 'About Me',
        description:
            'Add a few words about yourself to help employers understand who you are and what you do.',
        buttonLabel: 'Add About Me Information',
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
          const Text('About Me',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 12),
          Text(aboutMe.bio,
              style: const TextStyle(
                  fontSize: 16, color: IthakiTheme.textPrimary, height: 1.5)),
        ]),
        const SizedBox(height: 20),
        if (aboutMe.videoUrl != null) ...[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Video Introduction',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _openVideo(context, aboutMe.videoUrl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  height: 190,
                  color: const Color(0xFF040404),
                  alignment: Alignment.center,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0x801E1E1E),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        size: 28, color: IthakiTheme.backgroundWhite),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
        ],
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.profileAboutMe),
          icon: const IthakiIcon('edit-pencil', size: 20),
          label: const Text('Edit About Me & Video Introduction'),
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

  Future<void> _openVideo(BuildContext context, String? source) async {
    final uri = uriForResourceSource(source);
    if (uri == null) return;

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted || opened) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open video introduction.')),
    );
  }
}
