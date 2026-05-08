import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class DraftReviewBanner extends StatelessWidget {
  const DraftReviewBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Center(
              child: IthakiIcon(
                'help',
                size: 18,
                color: IthakiTheme.primaryPurple,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.cvDraftReviewTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l.cvDraftReviewBody,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeaveWithoutPublishingSheet extends StatelessWidget {
  const LeaveWithoutPublishingSheet({
    super.key,
    required this.onLeaveWithoutSaving,
    required this.onSaveAndLeave,
  });

  final VoidCallback onLeaveWithoutSaving;
  final VoidCallback onSaveAndLeave;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.leaveWithoutPublishingTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const IthakiIcon(
                  'x-close',
                  size: 20,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l.leaveWithoutPublishingMessage,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: IthakiOutlineButton(
              l.leaveWithoutSaving,
              onPressed: onLeaveWithoutSaving,
              borderRadius: 24,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              l.saveAndLeave,
              onPressed: onSaveAndLeave,
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingActionShelf extends StatelessWidget {
  const FloatingActionShelf({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: IthakiTheme.backgroundWhite.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: IthakiTheme.borderLight.withValues(alpha: 0.85),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
