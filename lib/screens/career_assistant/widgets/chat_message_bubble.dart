import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'chat_action_chip.dart';
import 'article_card.dart';
import 'job_card.dart';
import '../models/chat_message.dart';

// ---------------------------------------------------------------------------
// Entry point: dispatches user vs AI bubbles
// ---------------------------------------------------------------------------

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final void Function(String) onChip;
  const ChatMessageBubble({super.key, required this.msg, required this.onChip});

  @override
  Widget build(BuildContext context) {
    if (msg.type == MsgType.user) return UserBubble(text: msg.text);
    return AiBubble(msg: msg, onChip: onChip);
  }
}

// ---------------------------------------------------------------------------
// User bubble
// ---------------------------------------------------------------------------

class UserBubble extends StatelessWidget {
  final String text;
  const UserBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: IthakiTheme.softGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AI bubble (text + optional chips / articles / jobs)
// ---------------------------------------------------------------------------

class AiBubble extends StatelessWidget {
  final ChatMessage msg;
  final void Function(String) onChip;
  const AiBubble({super.key, required this.msg, required this.onChip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            msg.text,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.textPrimary,
              height: 1.6,
            ),
          ),
          if (msg.variant == AiVariant.textWithChips && msg.chips.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...msg.chips.map((chip) => ChatActionChip(label: chip, onTap: () => onChip(chip))),
          ],
          if (msg.variant == AiVariant.articles) ...[
            const SizedBox(height: 10),
            ...msg.articles.map((a) => ArticleCard(card: a)),
          ],
          if (msg.variant == AiVariant.jobs) ...[
            const SizedBox(height: 10),
            ...msg.jobs.map((j) => JobCard(card: j)),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Thinking indicator
// ---------------------------------------------------------------------------

class ThinkingBubble extends StatelessWidget {
  const ThinkingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        'Thinking...',
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 13,
          color: IthakiTheme.textSecondary,
        ),
      ),
    );
  }
}
