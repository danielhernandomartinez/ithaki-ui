import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/application_detail_models.dart';

class ScreeningQuestionsCard extends StatelessWidget {
  final List<ScreeningQuestion> questions;
  const ScreeningQuestionsCard({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.screeningQuestionsTitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 4),
          Text(l.screeningQuestionsSubtitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              )),
          const SizedBox(height: 20),
          ...questions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _QaItem(question: q),
              )),
        ],
      ),
    );
  }
}

class _QaItem extends StatelessWidget {
  final ScreeningQuestion question;
  const _QaItem({required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.36,
            )),
        const SizedBox(height: 12),
        Text(question.answer,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            )),
      ],
    );
  }
}
