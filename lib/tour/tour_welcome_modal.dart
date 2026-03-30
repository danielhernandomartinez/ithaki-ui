// lib/tour/tour_welcome_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

/// Shows once on first launch. Offers "Start Tour" or "Skip".
class TourWelcomeModal extends ConsumerWidget {
  const TourWelcomeModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourWelcomeModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tourProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IthakiIcon('rocket', size: 48, color: IthakiTheme.primaryPurple),
          const SizedBox(height: 16),
          Text('Welcome to Ithaki!', style: IthakiTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            "Let's take a quick tour so you know where everything is. It only takes a minute.",
            style: IthakiTheme.bodyRegular.copyWith(color: IthakiTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              'Start Tour',
              onPressed: () {
                Navigator.of(context).pop();
                notifier.startTour();
              },
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              notifier.confirmSkip();
            },
            child: Text(
              'Skip for now',
              style: IthakiTheme.bodyRegular.copyWith(
                color: IthakiTheme.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
