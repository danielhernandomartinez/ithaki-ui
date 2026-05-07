import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/tour_provider.dart';

class TourSkipModal extends ConsumerWidget {
  const TourSkipModal({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourSkipModal(),
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
          Text(l.tourSkipTitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              )),
          const SizedBox(height: 10),
          Text(
            l.tourSkipBody,
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
            l.continueProductTour,
            onPressed: () {
              Navigator.of(context).pop();
              notifier.cancelSkip();
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 4),
        ],
      ),
    );
  }
}
