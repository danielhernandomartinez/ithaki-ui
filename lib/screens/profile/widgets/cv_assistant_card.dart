import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class CvAssistantCard extends StatelessWidget {
  const CvAssistantCard({super.key, required this.onAskPressed});

  final VoidCallback onAskPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            IthakiTheme.gradientCvDark,
            IthakiTheme.gradientCvDark,
            IthakiTheme.primaryPurple.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.greatJob,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.backgroundWhite,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  l.cvLevelLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    color: IthakiTheme.backgroundWhite,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: IthakiTheme.matchGreen,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l.strongLevel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l.cvAssistantImprovementSummary,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: IthakiTheme.backgroundWhite,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: IthakiOutlineButton(
              l.askCareerAssistant,
              icon: const IthakiIcon(
                'ai',
                size: 18,
                color: IthakiTheme.backgroundWhite,
              ),
              onPressed: onAskPressed,
              borderRadius: 24,
              foregroundColor: IthakiTheme.backgroundWhite,
              borderColor: IthakiTheme.backgroundWhite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class CareerAssistantSheet extends StatelessWidget {
  const CareerAssistantSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: IthakiTheme.softGraphite,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: IthakiIcon(
                      'ai',
                      size: 22,
                      color: IthakiTheme.backgroundWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.pathfinderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.careerAssistantTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                    ],
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
          ),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        IthakiTheme.primaryPurpleLight.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    l.pathfinderAdviceText,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.askCareerPathHint,
                          style: const TextStyle(
                            fontSize: 15,
                            color: IthakiTheme.textSecondary,
                          ),
                        ),
                      ),
                      const IthakiIcon(
                        'rocket',
                        size: 20,
                        color: IthakiTheme.textSecondary,
                      ),
                    ],
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
