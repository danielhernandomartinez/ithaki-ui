import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../company/widgets/company_cultural_fit_gauge.dart';
import 'cv_atoms.dart';
import 'cv_data.dart';

class CvHeaderCard extends StatelessWidget {
  const CvHeaderCard({
    super.key,
    required this.data,
    required this.isPublished,
    required this.onLearnMorePressed,
    required this.onPublishPressed,
    required this.onReturnToProfilePressed,
  });

  final MyCvData data;
  final bool isPublished;
  final VoidCallback onLearnMorePressed;
  final VoidCallback onPublishPressed;
  final VoidCallback onReturnToProfilePressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final badgeLabel = isPublished ? l.publishedBadge : l.draftModeBadge;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CvAvatarBadge(
                initials: data.avatarInitials,
                photoPath: data.photoPath,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.jobTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.softGraphite,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          CvContactRow(icon: 'envelope', value: data.email),
          const SizedBox(height: 8),
          CvContactRow(icon: 'phone', value: data.phone),
          const SizedBox(height: 12),
          Text(
            l.contactVisibilityNote,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: IthakiTheme.softGray.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(24),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useVerticalLayout = constraints.maxWidth < 340;
                final gaugeWidth = useVerticalLayout
                    ? constraints.maxWidth * 0.64
                    : constraints.maxWidth * 0.42;
                final gaugeHeight = gaugeWidth * 0.62;

                final gauge = CompanyCulturalFitGauge(
                  label: l.highLabel,
                  width: gaugeWidth.clamp(150.0, 186.0),
                  height: gaugeHeight.clamp(92.0, 112.0),
                  titleFontSize: 20,
                  subtitleFontSize: 10,
                  labelWidthFactor: 0.92,
                  textAlignment: const Alignment(0, 0.43),
                );

                final details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.youBothShareSameValues,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: onLearnMorePressed,
                      child: Text(
                        l.learnMore,
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textPrimary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                );

                if (useVerticalLayout) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: gauge,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DefaultTextStyle.merge(
                          textAlign: TextAlign.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                l.youBothShareSameValues,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                  color: IthakiTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: onLearnMorePressed,
                                child: Text(
                                  l.learnMore,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: IthakiTheme.textPrimary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    gauge,
                    const SizedBox(width: 12),
                    Expanded(child: details),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child:
                      CvInfoCell(label: l.genderInfoLabel, value: data.gender)),
              Expanded(
                  child: CvInfoCell(label: l.ageInfoLabel, value: data.age)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: CvInfoCell(
                    label: l.citizenshipLabel, value: data.citizenship),
              ),
              Expanded(
                child: CvInfoCell(
                    label: l.locationInfoLabel, value: data.location),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'location',
                    value: data.workplace,
                  ),
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'clock',
                    value: data.jobType,
                  ),
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'resume',
                    value: data.experienceLevel,
                  ),
                  CvMetaValue(
                    width: itemWidth,
                    icon: 'jobs',
                    value: data.salary,
                    isStrong: true,
                  ),
                ],
              );
            },
          ),
          if (!isPublished) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: IthakiButton(
                l.publishCv,
                onPressed: onPublishPressed,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: IthakiOutlineButton(
                l.returnToProfileSetup,
                icon: const IthakiIcon('edit-pencil', size: 18),
                onPressed: onReturnToProfilePressed,
                borderRadius: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
