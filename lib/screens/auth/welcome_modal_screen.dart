import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class WelcomeModalScreen extends StatelessWidget {
  const WelcomeModalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Column(
        children: [
          // Tappable overlay (dismiss to location)
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/setup/location'),
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
                    child: const Text(
                      'Ithaki-logo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.primaryPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome on board!\nYour account is created and verified!',
                  style: IthakiTheme.headingLarge,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Let\'s go through a short setup so we can match you with the best job options.',
                  style: IthakiTheme.bodyRegular,
                ),
                const SizedBox(height: 28),
                IthakiButton(
                  'Skip for Now',
                  variant: IthakiButtonVariant.outline,
                  onPressed: () => context.go('/setup/location'),
                ),
                const SizedBox(height: 12),
                IthakiButton(
                  'Start Setup',
                  onPressed: () => context.go('/setup/location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
