import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';

class WelcomeModalScreen extends StatelessWidget {
  const WelcomeModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      child: Column(
        children: [
          // Tappable overlay (dismiss to location)
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/setup/location'),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          // Bottom sheet card
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              24,
              28,
              24,
              MediaQuery.of(context).padding.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo placeholder
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: IthakiTheme.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      l.ithakiLogo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l.welcomeModalHeading,
                  style: IthakiTheme.headingLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  l.welcomeModalDescription,
                  style: IthakiTheme.bodyRegular,
                ),
                const SizedBox(height: 28),
                IthakiButton(
                  l.skipForNow,
                  variant: IthakiButtonVariant.outline,
                  onPressed: () => context.go('/home'),
                ),
                const SizedBox(height: 12),
                IthakiButton(
                  l.startSetup,
                  onPressed: () => context.push('/setup/location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
