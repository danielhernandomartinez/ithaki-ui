import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class InvitationTopCard extends StatelessWidget {
  final String senderInitials;
  final String senderName;
  final Color senderAvatarColor;
  final String companyName;
  final String message;
  final String deadline;

  const InvitationTopCard({
    super.key,
    required this.senderInitials,
    required this.senderName,
    required this.senderAvatarColor,
    required this.companyName,
    required this.message,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SenderAvatar(
                initials: senderInitials,
                color: senderAvatarColor,
                size: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.28,
              ),
            ),
          ],
          if (deadline.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: IthakiTheme.accentPurpleLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const IthakiIcon('calendar', size: 16,
                      color: IthakiTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deadline,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SenderAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  const _SenderAvatar(
      {required this.initials, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.33,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
