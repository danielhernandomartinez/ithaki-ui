import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class InvitationStickyBar extends StatelessWidget {
  final VoidCallback onAccept;
  final void Function(String) onMore;

  const InvitationStickyBar({
    super.key,
    required this.onAccept,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                Expanded(
                  child: IthakiButton(
                    l.acceptInviteAndApply,
                    onPressed: onAccept,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: IthakiTheme.backgroundWhite.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: onMore,
                    icon: const IthakiIcon(
                      'help',
                      size: 20,
                      color: IthakiTheme.softGraphite,
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'decline',
                        child: Text(l.declineButton),
                      ),
                      PopupMenuItem(value: 'save', child: Text(l.viewJob)),
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
