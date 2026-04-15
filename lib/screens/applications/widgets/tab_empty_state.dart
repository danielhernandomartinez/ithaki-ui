import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Generic empty-state widget used across the Applications tabs.
class TabEmptyState extends StatelessWidget {
  final String iconName;
  final String title;
  final String subtitle;

  const TabEmptyState({
    super.key,
    required this.iconName,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: IthakiIcon(iconName, size: 36, color: IthakiTheme.primaryPurple),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.34,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
