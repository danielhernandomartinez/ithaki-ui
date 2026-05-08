import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/job_detail_models.dart';

class JobStatusCard extends StatelessWidget {
  final JobDetail detail;
  const JobStatusCard({super.key, required this.detail});

  static Color _badgeColor(String label) {
    switch (label) {
      case 'Submitted':
        return const Color(0xFFE9DEFF);
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
                child: Text(detail.appliedAt,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.32,
                    )),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeColor(detail.statusLabel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(detail.statusLabel,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      color: IthakiTheme.textPrimary,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(detail.deadline,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.softGraphite,
                letterSpacing: -0.28,
              )),
        ],
      ),
    );
  }
}
