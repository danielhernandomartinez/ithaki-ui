// lib/tour/tour_skip_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

class TourSkipModal extends ConsumerWidget {
  const TourSkipModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourSkipModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tourProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Skip the tour?', style: IthakiTheme.headingMedium),
          const SizedBox(height: 8),
          Text(
            "You can always restart the tour from the Home screen.",
            style: IthakiTheme.bodyRegular.copyWith(color: IthakiTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              'Continue Tour',
              onPressed: () {
                Navigator.of(context).pop();
                notifier.cancelSkip();
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
              'Skip',
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
