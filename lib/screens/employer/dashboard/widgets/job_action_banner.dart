import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';

enum JobActionBannerType { changesPublished, statusChanged }

class JobActionBanner extends StatelessWidget {
  final JobActionBannerType type;
  final VoidCallback onDismiss;

  const JobActionBanner({
    super.key,
    required this.type,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final message = type == JobActionBannerType.changesPublished
        ? l10n.changesPublishedMessage
        : l10n.statusChangedMessage;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: IthakiTheme.softGraphite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: IthakiTheme.bodySmall.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            child: const IthakiIcon('x-close', size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
