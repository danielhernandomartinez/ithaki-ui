import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import 'job_detail_primitives.dart';

class OdysseaReviewCard extends StatelessWidget {
  final String rating;
  final List<String> points;
  const OdysseaReviewCard(
      {super.key, required this.rating, required this.points});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(l.odysseaReviewLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              )),
          if (rating.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5C0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(rating,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B6B00),
                    )),
                const SizedBox(width: 4),
                const Text('✦',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B6B00))),
              ]),
            ),
        ]),
        if (points.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...points.map((p) => JobDetailBullet(p)),
        ],
      ]),
    );
  }
}
