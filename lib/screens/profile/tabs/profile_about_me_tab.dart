import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';

class ProfileAboutMeTab extends StatelessWidget {
  final ProfileState profile;
  const ProfileAboutMeTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.bio.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('About Me',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Add a few words about yourself to help employers understand who you are and what you do.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiOutlineButton(
            'Add About Me Information',
            icon: const IthakiIcon('plus', size: 16),
            onPressed: () => context.push(Routes.profileAboutMe),
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ]),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text(profile.bio,
              style: const TextStyle(
                  fontSize: 16,
                  color: IthakiTheme.textPrimary,
                  height: 1.5)),
        ]),
        const SizedBox(height: 20),
        if (profile.videoUrl != null) ...[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Video Introduction',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 8),
            ClipRRect(
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
                      size: 28, color: Colors.white),
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            minimumSize: const Size(0, 40),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }
}
