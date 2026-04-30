import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

const _kCloseReasons = [
  'Position filled',
  'Budget cut',
  'Role changed',
  'Other',
];

class CloseJobSheet extends StatefulWidget {
  final JobPost jobPost;
  final void Function(String reason)? onConfirm;

  const CloseJobSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<CloseJobSheet> createState() => _CloseJobSheetState();
}

class _CloseJobSheetState extends State<CloseJobSheet> {
  String? _reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(l10n.closeJobTitle, style: IthakiTheme.headingMedium),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ]),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: IthakiTheme.bodySmall,
                children: [
                  const TextSpan(text: 'Ready to close '),
                  TextSpan(
                    text: '"${widget.jobPost.title}"',
                    style: IthakiTheme.bodySmallBold,
                  ),
                  const TextSpan(
                    text: '? It will be moved to archived, and you\'ll still be able to reopen it anytime.\nPlease select a reason for closing the job:',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: IthakiTheme.borderLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _reason,
                  isExpanded: true,
                  hint: Text(l10n.closeJobReasonHint,
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary)),
                  items: _kCloseReasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (v) => setState(() => _reason = v),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _reason != null
                    ? () => widget.onConfirm?.call(_reason!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  disabledBackgroundColor:
                      IthakiTheme.primaryPurple.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(l10n.changeStatusButton,
                    style: IthakiTheme.buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
