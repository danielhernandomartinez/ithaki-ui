import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
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
    final l = AppLocalizations.of(context)!;
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
          Text(l.ithakiLogo,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: IthakiTheme.primaryPurple,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 20),
          Text(l.tourWelcomeTitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              )),
          const SizedBox(height: 10),
          Text(
            l.tourWelcomeBody,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              color: IthakiTheme.softGraphite,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          IthakiButton(
            l.skipForNow,
            variant: IthakiButtonVariant.outline,
            onPressed: () {
              Navigator.of(context).pop();
              notifier.confirmSkip();
            },
          ),
          const SizedBox(height: 10),
          IthakiButton(
            l.startProductTour,
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
