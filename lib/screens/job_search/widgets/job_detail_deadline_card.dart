import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class JobDetailDeadlineCard extends StatelessWidget {
  const JobDetailDeadlineCard({super.key, required this.deadline});

  final String deadline;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bannerText = l.deadlineBannerText.replaceAll('\n', ' ');

    return IthakiCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(10),
      borderRadius: 26,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
        decoration: BoxDecoration(
          color: IthakiTheme.accentPurpleLight,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: IthakiTheme.backgroundWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const IthakiIcon(
                    'calendar',
                    size: 18,
                    color: IthakiTheme.primaryPurple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    bannerText,
                    style: IthakiTheme.bodyRegular.copyWith(
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                _compactDeadline(deadline),
                style: IthakiTheme.bodySmallBold.copyWith(
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _compactDeadline(String value) {
    final colonIndex = value.indexOf(':');
    if (colonIndex == -1 || colonIndex == value.length - 1) {
      return value.trim();
    }
    return value.substring(colonIndex + 1).trim();
  }
}
