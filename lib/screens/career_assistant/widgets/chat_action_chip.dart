import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Single tappable suggestion chip
// ---------------------------------------------------------------------------

class ChatActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const ChatActionChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Initial chips row shown below the first AI message
// ---------------------------------------------------------------------------

class ChatInitialChipsRow extends StatelessWidget {
  final List<String> chips;
  final void Function(String) onChip;
  const ChatInitialChipsRow({super.key, required this.chips, required this.onChip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.chatGetStartedHint,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              color: IthakiTheme.softGraphite,
            ),
          ),
          const SizedBox(height: 8),
          ...chips.map((chip) => ChatActionChip(label: chip, onTap: () => onChip(chip))),
        ],
      ),
    );
  }
}
