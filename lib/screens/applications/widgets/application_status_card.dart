import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/application_detail_models.dart';
import '../../../utils/localized_dates.dart';

class ApplicationStatusCard extends StatelessWidget {
  final ApplicationDetail detail;
  const ApplicationStatusCard({super.key, required this.detail});

  static Color badgeColor(String label) {
    switch (label) {
      case 'Submitted':
        return IthakiTheme.accentPurpleLight;
      case 'Viewed':
        return const Color(0xFFE9E9E9);
      case 'Interview':
        return const Color(0xFFD8E5F9);
      case 'Offer':
        return const Color(0xFFD6F5D0);
      case 'Rejected':
        return const Color(0xFFFFE0E0);
      default:
        return const Color(0xFFE9E9E9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  formatAppliedAt(context, detail.appliedAt),
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor(detail.statusLabel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  detail.statusLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail.appliedWithNote,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
}
