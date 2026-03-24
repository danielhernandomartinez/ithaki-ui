import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/settings_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    const newsletterTypes = [
      'Job Alerts',
      'Career Tips',
      'Company News',
      'Industry Insights',
      'Product Updates',
    ];

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showBackButton: true,
        title: 'Notifications',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('CHANNELS'),
            _Card(
              children: [
                SwitchListTile(
                  activeThumbColor: IthakiTheme.primaryPurple,
                  activeTrackColor: IthakiTheme.primaryPurple.withValues(alpha: 0.4),
                  title: const Text(
                    'WhatsApp',
                    style: TextStyle(color: IthakiTheme.textPrimary),
                  ),
                  subtitle: const Text(
                    'Receive notifications via WhatsApp',
                    style: TextStyle(color: IthakiTheme.textSecondary, fontSize: 13),
                  ),
                  value: settings.whatsappEnabled,
                  onChanged: (_) => notifier.toggleChannel('whatsapp'),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16, color: IthakiTheme.borderLight),
                SwitchListTile(
                  activeThumbColor: IthakiTheme.primaryPurple,
                  activeTrackColor: IthakiTheme.primaryPurple.withValues(alpha: 0.4),
                  title: const Text(
                    'SMS',
                    style: TextStyle(color: IthakiTheme.textPrimary),
                  ),
                  subtitle: const Text(
                    'Receive notifications via SMS',
                    style: TextStyle(color: IthakiTheme.textSecondary, fontSize: 13),
                  ),
                  value: settings.smsEnabled,
                  onChanged: (_) => notifier.toggleChannel('sms'),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16, color: IthakiTheme.borderLight),
                SwitchListTile(
                  activeThumbColor: IthakiTheme.primaryPurple,
                  activeTrackColor: IthakiTheme.primaryPurple.withValues(alpha: 0.4),
                  title: const Text(
                    'Push Notifications',
                    style: TextStyle(color: IthakiTheme.textPrimary),
                  ),
                  subtitle: const Text(
                    'Receive push notifications',
                    style: TextStyle(color: IthakiTheme.textSecondary, fontSize: 13),
                  ),
                  value: settings.pushEnabled,
                  onChanged: (_) => notifier.toggleChannel('push'),
                ),
              ],
            ),
            const _SectionLabel('EMAIL NEWSLETTER'),
            _Card(
              children: [
                SwitchListTile(
                  activeThumbColor: IthakiTheme.primaryPurple,
                  activeTrackColor: IthakiTheme.primaryPurple.withValues(alpha: 0.4),
                  title: const Text(
                    'Newsletter',
                    style: TextStyle(color: IthakiTheme.textPrimary),
                  ),
                  subtitle: const Text(
                    'Receive our email newsletter',
                    style: TextStyle(color: IthakiTheme.textSecondary, fontSize: 13),
                  ),
                  value: settings.emailNewsletterActive,
                  onChanged: (val) => val
                      ? notifier.subscribeNewsletter()
                      : notifier.unsubscribeNewsletter(),
                ),
                if (settings.emailNewsletterActive) ...[
                  const Divider(height: 1, indent: 16, endIndent: 16, color: IthakiTheme.borderLight),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Choose topics:',
                      style: TextStyle(
                        color: IthakiTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  for (final type in newsletterTypes)
                    CheckboxListTile(
                      title: Text(
                        type,
                        style: const TextStyle(
                          color: IthakiTheme.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      value: settings.newsletterTypes.contains(type),
                      onChanged: (_) => notifier.toggleNewsletterType(type),
                      activeColor: IthakiTheme.primaryPurple,
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                ],
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: IthakiTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: children),
      );
}
