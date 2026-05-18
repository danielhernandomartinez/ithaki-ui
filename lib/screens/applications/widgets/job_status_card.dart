import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/job_detail_models.dart';
import '../../../utils/localized_dates.dart';

class JobStatusCard extends StatelessWidget {
  final JobDetail detail;
  const JobStatusCard({super.key, required this.detail});

  static Color _badgeColor(String label) {
    switch (label) {
      case 'Submitted':
        return IthakiTheme.statusBgPurple;
      case 'Viewed':
        return IthakiTheme.statusBgGray;
      case 'Interview':
        return IthakiTheme.statusBgBlue;
      case 'Offer':
        return IthakiTheme.statusBgGreen;
      case 'Rejected':
        return IthakiTheme.statusBgRed;
      default:
        return IthakiTheme.statusBgGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.softGray),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(formatAppliedAt(context, detail.appliedAt),
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
