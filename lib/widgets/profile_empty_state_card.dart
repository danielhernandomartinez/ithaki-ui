import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Shared empty-state card used in profile tabs (About Me, Work Experience, Education, Files).
class ProfileEmptyStateCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonLabel;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const ProfileEmptyStateCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onPressed,
            icon: buttonIcon,
            label: Text(buttonLabel),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              side: const BorderSide(color: IthakiTheme.softGraphite),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              foregroundColor: IthakiTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
