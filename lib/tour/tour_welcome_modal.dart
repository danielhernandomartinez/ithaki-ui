import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../providers/tour_provider.dart';

/// Shows once on first launch. "Skip for Now" / "Start Product Tour".
class TourWelcomeModal extends ConsumerWidget {
  const TourWelcomeModal({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourWelcomeModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(tourProvider.notifier);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo placeholder — replace with actual IthakiLogo widget if available
          const Text('Ithaki-logo',
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: IthakiTheme.primaryPurple,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 20),
          const Text("Let's Get You Started!",
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              )),
          const SizedBox(height: 10),
          const Text(
            'Here you can find a job that fits your skills and experience. Let\'s go step by step.',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              color: IthakiTheme.softGraphite,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          IthakiButton(
            'Skip for Now',
            variant: IthakiButtonVariant.outline,
            onPressed: () {
              Navigator.of(context).pop();
              notifier.confirmSkip();
            },
          ),
          const SizedBox(height: 10),
          IthakiButton(
            'Start Product Tour',
            onPressed: () {
              Navigator.of(context).pop();
              notifier.startTour();
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 4),
        ],
      ),
    );
  }
}
