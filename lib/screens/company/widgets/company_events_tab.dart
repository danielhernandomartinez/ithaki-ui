import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/company_models.dart';
import 'company_cultural_match_card.dart';
import 'company_profile_atoms.dart';
import 'company_profile_styles.dart';
import 'company_surface_card.dart';
import 'company_visual_placeholder.dart';

class CompanyEventsTab extends StatelessWidget {
  const CompanyEventsTab({
    super.key,
    required this.events,
    required this.company,
    required this.culturalMatch,
    required this.onOpenEvent,
  });

  final List<CompanyEvent> events;
  final CompanyProfile company;
  final CulturalMatch? culturalMatch;
  final void Function(String eventId) onOpenEvent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (events.isEmpty)
            CompanyEmptyState(l10n.companyNoEvents)
          else ...[
            CompanySurfaceCard(
              child: CompanySectionTitle(l10n.companyEventsTitle),
            ),
            const SizedBox(height: 12),
            ...events.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => onOpenEvent(event.id),
                  child: _EventCard(event: event, company: company),
                ),
              ),
            ),
          ],
          if (culturalMatch != null) ...[
            const SizedBox(height: 8),
            CulturalMatchCard(match: culturalMatch!),
          ],
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.company});

  final CompanyEvent event;
  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyProfileLogo(company: company, size: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Text(event.title, style: companyProfileTitleStyle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              CompanyInfoStat(icon: 'calendar', label: event.date),
              if (event.time.isNotEmpty)
                CompanyInfoStat(icon: 'clock', label: event.time),
              if (event.location.isNotEmpty)
                CompanyInfoStat(icon: 'location', label: event.location),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          Text(event.description, style: companyProfileBodyStyle),
          const SizedBox(height: 12),
          if (event.imageAssets.isNotEmpty)
            Row(
              children: event.imageAssets
                  .map(
                    (asset) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          asset,
                          width: 91,
                          height: 82,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            const Row(
              children: [
                Expanded(
                  child: CompanyVisualPlaceholder(
                    title: 'Talks',
                    subtitle: 'Event media placeholder',
                    height: 82,
                    iconName: 'calendar',
                    borderRadius: 18,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CompanyVisualPlaceholder(
                    title: 'Workshop',
                    subtitle: 'Event media placeholder',
                    height: 82,
                    iconName: 'assessment',
                    borderRadius: 18,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
