import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class DismissBanner extends StatelessWidget {
  final VoidCallback onUndo;
  const DismissBanner({super.key, required this.onUndo});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: IthakiTheme.textPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.dismissBannerTitle,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: IthakiTheme.backgroundWhite,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.dismissBannerCountdown,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 12,
                    color: IthakiTheme.lightGraphite,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onUndo,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: IthakiTheme.primaryPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l.undo,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.backgroundWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToastBanner extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  const ToastBanner({super.key, required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: IthakiTheme.textPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.backgroundWhite,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const IthakiIcon('x-close',
                size: 20, color: IthakiTheme.lightGraphite),
          ),
        ],
      ),
    );
  }
}
