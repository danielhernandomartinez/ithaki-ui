import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/company_provider.dart';
import '../../providers/home_provider.dart';
import 'widgets/company_profile_components.dart';

class CompanyEventDetailScreen extends ConsumerWidget {
  const CompanyEventDetailScreen({
    super.key,
    required this.companyId,
    required this.eventId,
  });

  final String companyId;
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyAsync = ref.watch(companyProvider(companyId));
    final homeData = ref.watch(homeProvider).value;
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        showBackButton: true,
        avatarInitials: homeData?.userInitials ?? 'CI',
      ),
      body: companyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load company.')),
        data: (company) {
          final event = company.events.firstWhere(
            (item) => item.id == eventId,
            orElse: () => company.events.first,
          );

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, topOffset, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: AspectRatio(
                      aspectRatio: 361 / 168,
                      child: company.heroImageAsset.isNotEmpty
                          ? Image.asset(
                              company.heroImageAsset,
                              fit: BoxFit.cover,
                            )
                          : CompanyVisualPlaceholder(
                              title: event.title,
                              subtitle: 'Event hero placeholder',
                              height: double.infinity,
                              iconName: 'calendar',
                              borderRadius: 32,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CompanySurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.title, style: companyProfileTitleStyle),
                        const SizedBox(height: 14),
                        const Divider(
                            height: 1, color: IthakiTheme.borderLight),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 22,
                          runSpacing: 12,
                          children: [
                            CompanyInfoStat(
                                icon: 'calendar', label: event.date),
                            CompanyInfoStat(
                                icon: 'location', label: event.location),
                            CompanyInfoStat(
                              icon: 'clock',
                              label: event.detailTime.isEmpty
                                  ? event.time
                                  : event.detailTime,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CompanySurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CompanySectionTitle('Event Details'),
                        const SizedBox(height: 14),
                        Text(event.description, style: companyProfileBodyStyle),
                        if (event.address.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const CompanySectionTitle('Address'),
                          const SizedBox(height: 12),
                          Text(event.address, style: companyProfileBodyStyle),
                        ],
                        if (event.registrationLink.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const CompanySectionTitle('Registration Link'),
                          const SizedBox(height: 12),
                          Text(
                            event.registrationLink,
                            style: companyProfileBodyStyle.copyWith(
                              color: IthakiTheme.textSecondary,
                              decoration: TextDecoration.underline,
                              decorationColor: IthakiTheme.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (company.culturalMatch != null) ...[
                    const SizedBox(height: 12),
                    CulturalMatchCard(match: company.culturalMatch!),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
