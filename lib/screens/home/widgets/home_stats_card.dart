import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class HomeStatsCard extends StatelessWidget {
  const HomeStatsCard({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<IthakiStatRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: IthakiTheme.headingMedium),
        const SizedBox(height: 12),
        for (int i = 0; i < rows.length; i++) ...[
          _StatRow(row: rows[i]),
          if (i < rows.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.row});

  final IthakiStatRowData row;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: IthakiTheme.borderLight),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: Center(child: row.icon),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              row.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: IthakiTheme.bodySmall.copyWith(
                color: IthakiTheme.textSecondary,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${row.value}',
            style: IthakiTheme.sectionTitle.copyWith(
              color: IthakiTheme.textPrimary,
            ),
          ),
          if (row.change != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: IthakiTheme.badgeLime,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${row.change}',
                style: IthakiTheme.bodySmallBold.copyWith(
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
