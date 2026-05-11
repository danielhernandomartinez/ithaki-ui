import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class QuizProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const QuizProgressBar(
      {super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$current/$total',
          style:
              IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: IthakiTheme.borderLight,
            color: IthakiTheme.primaryPurple,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
