import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../routes.dart';
import '../models/chat_message.dart';

class JobCard extends StatelessWidget {
  final JobData card;
  const JobCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final isStrong = card.matchPct >= 90;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: IthakiTheme.softGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: IthakiIcon('jobs', size: 20, color: IthakiTheme.softGraphite),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  card.company,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.title,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.salary,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isStrong
                    ? [IthakiTheme.matchGreen, IthakiTheme.matchGreen]
                    : [IthakiTheme.matchGradientWeakStart, IthakiTheme.matchGradientWeakEnd],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white24,
                  ),
                  child: Center(
                    child: Text(
                      '${card.matchPct}%',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  card.matchLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              AppLocalizations.of(context)!.viewJobDetails,
              onPressed: () => context.push(Routes.jobSearchDetailFor('job-2')),
            ),
          ),
        ],
      ),
    );
  }
}
