import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';

class ReportJobSheet extends StatefulWidget {
  const ReportJobSheet({super.key});

  @override
  State<ReportJobSheet> createState() => _ReportJobSheetState();
}

class _ReportJobSheetState extends State<ReportJobSheet> {
  String? _reason;
  final _noteController = TextEditingController();
  static const _maxChars = 500;

  static const _reasons = [
    'Inaccurate job description',
    'Spam or scam',
    'Discriminatory content',
    'Already filled / closed',
    'Other',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: IthakiTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(l.reportJobTitle,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      )),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const IthakiIcon('delete',
                      size: 22, color: IthakiTheme.softGraphite),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l.reportJobDescription,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.softGraphite,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _reason,
              hint: Text(l.selectReasonHint,
                  style: TextStyle(color: IthakiTheme.textSecondary)),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: IthakiTheme.borderLight),
                ),
              ),
              items: _reasons
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _reason = v),
            ),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextField(
                  controller: _noteController,
                  maxLines: 8,
                  maxLength: _maxChars,
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      const SizedBox.shrink(),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l.tellUsMoreOptional,
                    hintStyle:
                        const TextStyle(color: IthakiTheme.textSecondary),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: IthakiTheme.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: IthakiTheme.borderLight),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    l.charactersCounter(_noteController.text.length, _maxChars),
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 12,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IthakiButton(
              l.reportThisJobButton,
              onPressed:
                  _reason != null ? () => Navigator.pop(context, true) : null,
            ),
          ],
        ),
      ),
    );
  }
}
