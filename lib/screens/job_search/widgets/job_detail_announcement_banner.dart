import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class JobDetailAnnouncementBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  const JobDetailAnnouncementBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const IthakiIcon('rocket', size: 20, color: IthakiTheme.primaryPurple),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.newFeatureBanner,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.textPrimary,
                  height: 1.4,
                )),
            const SizedBox(height: 4),
            Text(l.readMore,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  color: IthakiTheme.textSecondary,
                  decoration: TextDecoration.underline,
                )),
          ]),
        ),
        GestureDetector(
          onTap: onDismiss,
          child: const IthakiIcon('delete',
              size: 18, color: IthakiTheme.softGraphite),
        ),
      ]),
    );
  }
}
