import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/profile_provider.dart';
import '../../providers/settings_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const _newsletterTopics = [
    (
      'Jobs Recommendations',
      'Personalized job offers based on your skills and preferences',
    ),
    (
      'Career Tips',
      'Expert advice and resources to boost your professional growth',
    ),
    (
      'Events & Webinars',
      'Upcoming career events, workshops, and networking sessions',
    ),
    (
      'Platform Updates',
      'New features, tools, and product improvements',
    ),
    (
      'Learning Opportunities',
      'Online courses and certifications to enhance your skills',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Notifications'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(context),

            // ── Communication Channel ──────────────────────────────────────
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Communication Channel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose a channel to get notifications about new relevant job openings and responses to submitted applications. You can select multiple options and change them anytime.',
                    style: TextStyle(
                      fontSize: 13,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IthakiOptionCard(
                    showLeadingCheckbox: true,
                    label: 'WhatsApp',
                    subtitle: profile.phone.isNotEmpty ? profile.phone : null,
                    isSelected: settings.whatsappEnabled,
                    onTap: () => notifier.toggleChannel('whatsapp'),
                  ),
                  const SizedBox(height: 8),
                  IthakiOptionCard(
                    showLeadingCheckbox: true,
                    label: 'SMS',
                    subtitle: profile.phone.isNotEmpty ? profile.phone : null,
                    isSelected: settings.smsEnabled,
                    onTap: () => notifier.toggleChannel('sms'),
                  ),
                  const SizedBox(height: 8),
                  IthakiOptionCard(
                    showLeadingCheckbox: true,
                    label: 'Push Notifications',
                    isSelected: settings.pushEnabled,
                    onTap: () => notifier.toggleChannel('push'),
                  ),
                ],
              ),
            ),

            // ── Email Newsletter ───────────────────────────────────────────
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Newsletter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Stay informed and make the most of your experience! Choose which types of updates and insights you\'d like to receive directly to your inbox.',
                    style: TextStyle(
                      fontSize: 13,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email badge
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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
                          'Email Newsletter',
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
                              ? '(active)'
                              : '(inactive)',
                          style: TextStyle(
                            fontSize: 12,
                            color: IthakiTheme.textSecondary,
                          ),
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
                              side: const BorderSide(
                                  color: IthakiTheme.softGraphite),
                              foregroundColor: IthakiTheme.textPrimary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Unsubscribe'),
                          ),
                        )
                      : IthakiButton(
                          'Subscribe',
                          onPressed: () {
                            notifier.subscribeNewsletter();
                            SuccessBanner.show(
                                context, 'Settings updated successfully.');
                          },
                        ),

                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Newsletter topics
                  for (final (type, subtitle) in _newsletterTopics) ...[
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
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE9DEFF),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.pop(),
              child: const SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
