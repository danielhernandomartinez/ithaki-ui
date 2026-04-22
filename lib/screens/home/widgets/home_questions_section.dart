import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../routes.dart';

class HomeQuestionsSection extends StatelessWidget {
  const HomeQuestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            IthakiIcon('help', size: 24, color: IthakiTheme.accentPurpleLight),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Have questions?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Let us help you!',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => context.go(Routes.careerAssistant),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: IthakiTheme.borderLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Book Call with Counselor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
