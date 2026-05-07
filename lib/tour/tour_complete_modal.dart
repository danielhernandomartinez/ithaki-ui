import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import '../providers/tour_provider.dart';
import '../routes.dart';

class TourCompleteModal extends ConsumerWidget {
  const TourCompleteModal({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const TourCompleteModal(),
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
          Text(l.ithakiLogo,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: IthakiTheme.primaryPurple,
                letterSpacing: -0.5,
              )),
          const SizedBox(height: 20),
          Text(l.tourReadyTitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              )),
          const SizedBox(height: 10),
          Text(
            l.tourReadyBody,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              color: IthakiTheme.softGraphite,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          IthakiButton(
            l.goToJobSearch,
            onPressed: () {
              notifier.completeTour();
              Navigator.of(context).pop();
              context.go(Routes.jobSearch);
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 4),
        ],
      ),
    );
  }
}
