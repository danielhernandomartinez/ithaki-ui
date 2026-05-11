import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/application_detail_models.dart';
import '../../../routes.dart';

class TalentProfileCard extends StatelessWidget {
  final CandidateProfile candidate;
  const TalentProfileCard({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: IthakiTheme.badgeLime,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  candidate.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(candidate.name,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(candidate.title,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textSecondary,
                          letterSpacing: -0.28,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD8E5F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(candidate.availabilityLabel,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.32,
                )),
          ),
          const SizedBox(height: 12),
          _ContactRow(icon: 'envelope', value: candidate.email),
          const SizedBox(height: 8),
          _ContactRow(icon: 'phone', value: candidate.phone),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 12, children: [
            _InfoCell(label: l.genderInfoLabel, value: candidate.gender),
            _InfoCell(label: l.ageInfoLabel, value: candidate.age),
            _InfoCell(label: l.citizenshipLabel, value: candidate.citizenship),
            _InfoCell(label: l.locationInfoLabel, value: candidate.location),
          ]),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 12, children: [
            _IconInfoCell(
                icon: 'company-profile', value: candidate.workplacePreference),
            _IconInfoCell(icon: 'clock', value: candidate.employmentPreference),
            _IconInfoCell(icon: 'level', value: candidate.experienceLevel),
            _IconInfoCell(
                icon: 'bank-note',
                value: candidate.salaryExpectation,
                semibold: true),
          ]),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.push(Routes.profile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.showFullCv,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.32,
                    )),
                Container(height: 1, color: IthakiTheme.textPrimary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String icon;
  final String value;
  const _ContactRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
        const SizedBox(width: 4),
        Text(value,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.32,
            )),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textSecondary,
                letterSpacing: -0.28,
              )),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.32,
              )),
        ],
      ),
    );
  }
}

class _IconInfoCell extends StatelessWidget {
  final String icon;
  final String value;
  final bool semibold;
  const _IconInfoCell(
      {required this.icon, required this.value, this.semibold = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 152,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(value,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: semibold ? FontWeight.w600 : FontWeight.w400,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.32,
                )),
          ),
        ],
      ),
    );
  }
}
