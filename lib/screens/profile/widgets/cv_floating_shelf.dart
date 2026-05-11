import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/cv_provider.dart';
import '../../../routes.dart';
import 'cv_overlays.dart';

class CvFloatingShelf extends ConsumerWidget {
  const CvFloatingShelf({super.key, required this.isPublished});

  final bool isPublished;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return Positioned(
      left: 16,
      right: 16,
      bottom: MediaQuery.viewPaddingOf(context).bottom + 16,
      child: FloatingActionShelf(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: isPublished
                  ? IthakiOutlineButton(
                      l.goToProfile,
                      onPressed: () => context.push(Routes.profile),
                      borderRadius: 24,
                    )
                  : IthakiButton(
                      l.publishCv,
                      onPressed: () => ref
                          .read(cvPublishedProvider.notifier)
                          .setPublished(true),
                    ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: isPublished
                  ? IthakiOutlineButton(
                      l.downloadCv,
                      icon: const IthakiIcon('resume', size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.cvDownloadSoon)),
                        );
                      },
                      borderRadius: 24,
                    )
                  : IthakiOutlineButton(
                      l.returnToProfileSetup,
                      icon: const IthakiIcon('edit-pencil', size: 18),
                      onPressed: () => context.push(Routes.profile),
                      borderRadius: 24,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
