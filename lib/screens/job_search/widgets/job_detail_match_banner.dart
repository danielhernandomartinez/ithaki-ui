import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class JobDetailMatchBanner extends StatelessWidget {
  final int percentage;
  final String matchLabel;
  final VoidCallback onAskCareerAssistant;

  const JobDetailMatchBanner({
    super.key,
    required this.percentage,
    required this.matchLabel,
    required this.onAskCareerAssistant,
  });

  Color get _progressColor {
    if (percentage >= 80) return IthakiTheme.matchGreen;
    if (percentage >= 60) return IthakiTheme.matchScoreGood;
    if (percentage >= 40) return IthakiTheme.matchScoreWeak;
    return IthakiTheme.matchScoreLow;
  }

  String _matchCopy(AppLocalizations l) {
    if (percentage >= 80) return l.strongSkillsMatch;
    if (percentage >= 60) return l.goodSkillsMatch;
    if (percentage >= 40) return l.partialSkillsMatch;
    return l.starterSkillsMatch;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            IthakiTheme.gradientDarkTop,
            IthakiTheme.gradientDarkBottom,
            IthakiTheme.primaryPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                ),
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: percentage.clamp(0, 100).toDouble() / 100,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _matchCopy(l),
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.45,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Divider(color: Colors.white.withValues(alpha: 0.18), height: 1),
        const SizedBox(height: 16),
        Text(
          l.curiousWhyMatch,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: onAskCareerAssistant,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.82),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const IthakiIcon('ai', size: 18, color: Colors.white),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    l.askCareerAssistant,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
