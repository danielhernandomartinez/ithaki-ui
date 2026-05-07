import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/settings_provider.dart';

class NotificationsTab extends ConsumerWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final profile = ref.watch(profileBasicsProvider).value;
    final newsletterTopics = [
      (l.newsletterJobsTitle, l.newsletterJobsSubtitle),
      (l.newsletterCareerTipsTitle, l.newsletterCareerTipsSubtitle),
      (l.newsletterEventsTitle, l.newsletterEventsSubtitle),
      (l.newsletterPlatformTitle, l.newsletterPlatformSubtitle),
      (l.newsletterLearningTitle, l.newsletterLearningSubtitle),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1 — Communication Channel
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.communicationChannelTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.communicationDescription,
                style: const TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              IthakiOptionCard(
                showLeadingCheckbox: true,
                label: l.whatsapp,
                subtitle:
                    (profile?.phone ?? '').isNotEmpty ? profile!.phone : null,
                isSelected: settings.whatsappEnabled,
                onTap: () => notifier.toggleChannel('whatsapp'),
              ),
              const SizedBox(height: 8),
              IthakiOptionCard(
                showLeadingCheckbox: true,
                label: l.sms,
                subtitle:
                    (profile?.phone ?? '').isNotEmpty ? profile!.phone : null,
                isSelected: settings.smsEnabled,
                onTap: () => notifier.toggleChannel('sms'),
              ),
              const SizedBox(height: 8),
              IthakiOptionCard(
                showLeadingCheckbox: true,
                label: l.pushNotifications,
                isSelected: settings.pushEnabled,
                onTap: () => notifier.toggleChannel('push'),
              ),
            ],
          ),
        ),

        // Card 2 — Email Newsletter
        IthakiCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.emailNewsletterTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.emailNewsletterDescription,
                style: const TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 16),

              // Email badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: settings.emailNewsletterActive
                      ? IthakiTheme.backgroundViolet
                      : IthakiTheme.softGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: settings.emailNewsletterActive
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.lightGray,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    IthakiIcon(
                      'envelope',
                      size: 20,
                      color: settings.emailNewsletterActive
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l.emailNewsletterTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: settings.emailNewsletterActive
                            ? IthakiTheme.primaryPurple
                            : IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      settings.emailNewsletterActive
                          ? l.newsletterActive
                          : l.newsletterInactive,
                      style: const TextStyle(
                          fontSize: 12, color: IthakiTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Subscribe / Unsubscribe
              settings.emailNewsletterActive
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => notifier.unsubscribeNewsletter(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side:
                              const BorderSide(color: IthakiTheme.softGraphite),
                          foregroundColor: IthakiTheme.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(l.unsubscribe),
                      ),
                    )
                  : IthakiButton(
                      l.subscribe,
                      onPressed: () {
                        notifier.subscribeNewsletter();
                        SuccessBanner.show(
                            context, l.settingsUpdatedSuccessfully);
                      },
                    ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Newsletter topics
              for (final (type, subtitle) in newsletterTopics) ...[
                IthakiOptionCard(
                  showLeadingCheckbox: true,
                  label: type,
                  subtitle: subtitle,
                  isSelected: settings.newsletterTypes.contains(type),
                  enabled: settings.emailNewsletterActive,
                  onTap: () => notifier.toggleNewsletterType(type),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
