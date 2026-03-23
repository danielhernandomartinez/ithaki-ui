// lib/tour/tour_complete_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

class TourCompleteModal extends ConsumerWidget {
  const TourCompleteModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourCompleteModal(),
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
          const IthakiIcon('rocket', size: 48, color: IthakiTheme.primaryPurple),
          const SizedBox(height: 16),
          Text('Tour Complete!', style: IthakiTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            "You're ready to go! Start exploring Ithaki and take the next step in your career.",
            style: IthakiTheme.bodyRegular.copyWith(color: IthakiTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              "Let's Go!",
              onPressed: () {
                Navigator.of(context).pop();
                notifier.completeTour();
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
