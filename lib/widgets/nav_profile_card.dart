import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../l10n/app_localizations.dart';
import 'profile_completion_progress_bar.dart';

class NavProfileCard extends StatelessWidget {
  final double progress;
  const NavProfileCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SizedBox(
      height: 95,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: IthakiTheme.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 31,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l.homeProfileCompleteYourProfile,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: IthakiTheme.bodyRegular.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ProfileCompletionProgressBar(progress: progress),
          ],
        ),
      ),
    );
  }
}
