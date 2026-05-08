import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/company_models.dart';
import 'company_cultural_fit_gauge.dart';
import 'company_profile_styles.dart';
import 'company_surface_card.dart';

class CulturalMatchCard extends StatelessWidget {
  const CulturalMatchCard({super.key, required this.match});

  final CulturalMatch match;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CompanySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CompanyCulturalFitGauge(label: match.label),
          ),
          const SizedBox(height: 12),
          Text(l10n.culturalMatchScore, style: companyProfileSectionTitle),
          const SizedBox(height: 14),
          Text(
            l10n.culturalMatchDescription,
            style: companyProfileBodyStyle,
          ),
          const SizedBox(height: 14),
          Text(l10n.culturalMatchYouBothCareAbout, style: companyProfileBodyStyle),
          const SizedBox(height: 8),
          ...match.sharedValues.map(_CompanyMatchBullet.new),
          if (match.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(match.description, style: companyProfileBodyStyle),
          ],
        ],
      ),
    );
  }
}

class _CompanyMatchBullet extends StatelessWidget {
  const _CompanyMatchBullet(this.value);

  final String value;

  String get _emoji {
    final normalized = value.toLowerCase();
    if (normalized.contains('sustain')) return '🌱';
    if (normalized.contains('team')) return '🧑‍🤝‍🧑';
    if (normalized.contains('learn')) return '📚';
    return '•';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_emoji, style: companyProfileBodyStyle),
          const SizedBox(width: 6),
          Expanded(child: Text(value, style: companyProfileBodyStyle)),
        ],
      ),
    );
  }
}
