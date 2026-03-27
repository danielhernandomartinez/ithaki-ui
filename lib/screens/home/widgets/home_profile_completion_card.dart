import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/profile_provider.dart';
import 'home_purple_button.dart';

class HomeProfileCompletionCard extends ConsumerWidget {
  const HomeProfileCompletionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeProvider).value;
    if (homeData == null) return const SizedBox.shrink();
    final progress = ref.watch(profileCompletionProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: const Color(0xFFDACCF8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── White section: progress bar + checklist ──────────
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complete your profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      IthakiHatchProgressBar(progress: progress),
                      const SizedBox(height: 12),
                      ...homeData.profileItems.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: item.completed
                                        ? IthakiTheme.textPrimary
                                        : IthakiTheme.softGray,
                                    shape: BoxShape.circle,
                                  ),
                                  child: item.completed
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: item.completed
                                          ? IthakiTheme.textPrimary
                                          : IthakiTheme.textSecondary,
                                      fontWeight: item.completed
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),

              // ─── #daccf8 section: welcome + benefits + button ──────
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Ithaki!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Fill in the missing information to unlock your full experience on the platform. A complete profile helps you get better job matches and more employer invitations.",
                      style: TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Benefits of completing your profile',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...homeData.profileBenefits.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check,
                                  size: 16, color: IthakiTheme.primaryPurple),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  b,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: IthakiTheme.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 14),
                    const HomePurpleButton(label: 'Fill Profile'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
