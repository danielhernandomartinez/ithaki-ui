import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

const _kCloseReasonHiredThroughIthaki = 'hired_through_ithaki';

const _kCloseReasonKeys = [
  _kCloseReasonHiredThroughIthaki,
  'position_filled_other',
  'budget_cut',
  'role_changed',
  'other',
];

// Mock candidates — replace with real data from provider when backend is ready
const _kMockIthakiCandidates = [
  'Nikos Papadakis',
  'Elena Koutrouki',
  'Omar Al-Hassan',
  'Layla Mansour',
];

class CloseJobSheet extends StatefulWidget {
  final JobPost jobPost;
  final void Function(String reason)? onConfirm;

  const CloseJobSheet({super.key, required this.jobPost, this.onConfirm});

  @override
  State<CloseJobSheet> createState() => _CloseJobSheetState();
}

class _CloseJobSheetState extends State<CloseJobSheet> {
  String? _reasonKey;
  String? _ithakiCandidate;

  bool get _isIthakiReason => _reasonKey == _kCloseReasonHiredThroughIthaki;
  bool get _canConfirm =>
      _reasonKey != null && (!_isIthakiReason || _ithakiCandidate != null);

  String _reasonLabel(AppLocalizations l10n, String key) => switch (key) {
        _kCloseReasonHiredThroughIthaki => l10n.closeJobHiredThroughIthaki,
        'position_filled_other' => 'Position filled (other source)',
        'budget_cut' => 'Budget cut',
        'role_changed' => 'Role changed',
        _ => 'Other',
      };

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

            // ── Reason dropdown ───────────────────────────────
            _Dropdown(
              value: _reasonKey,
              hint: l10n.closeJobReasonHint,
              items: _kCloseReasonKeys
                  .map((k) => DropdownMenuItem(
                        value: k,
                        child: Text(_reasonLabel(l10n, k)),
                      ))
                  .toList(),
              onChanged: (v) => setState(() {
                _reasonKey = v;
                _ithakiCandidate = null;
              }),
            ),

            // ── Ithaki candidate section (conditional) ────────
            if (_isIthakiReason) ...[
              const SizedBox(height: 16),
              Text(
                l10n.closeJobIthakiCandidateDescription,
                style: IthakiTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _Dropdown(
                value: _ithakiCandidate,
                hint: l10n.closeJobSelectCandidate,
                // TODO: replace with real candidates from provider when backend is ready
                items: _kMockIthakiCandidates
                    .map((name) => DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _ithakiCandidate = v),
              ),
            ],

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canConfirm
                    ? () => widget.onConfirm?.call(_reasonKey!)
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

class _Dropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: IthakiTheme.borderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary)),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
