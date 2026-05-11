import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import '../../../routes.dart';
import '../../../utils/ithaki_bottom_sheet.dart';
import 'apply_bottom_sheet.dart';

class JobDetailStickyBar extends StatelessWidget {
  final JobDetail detail;
  const JobDetailStickyBar({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: IthakiTheme.borderLight.withValues(alpha: 0.9),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    detail.salary,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: IthakiButton(
                          AppLocalizations.of(context)!.saveJob,
                          variant: IthakiButtonVariant.outline,
                          onPressed: () => context.go(Routes.jobSearch),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: IthakiButton(
                          AppLocalizations.of(context)!.applyButton,
                          onPressed: () {
                            showIthakiBottomSheet<void>(
                              context: context,
                              builder: (_) => const ApplyBottomSheet(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
