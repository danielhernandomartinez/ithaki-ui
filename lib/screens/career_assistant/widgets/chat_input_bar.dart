import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onSend;
  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(
        children: [
          const IthakiIcon('ai', size: 18, color: IthakiTheme.softGraphite),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: l10n.askCareerPathHint,
                hintStyle: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.textSecondary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onSubmitted: onSend,
            ),
          ),
          GestureDetector(
            onTap: () => onSend(controller.text),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: IthakiTheme.primaryPurple,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: IthakiIcon('arrow-down', size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
