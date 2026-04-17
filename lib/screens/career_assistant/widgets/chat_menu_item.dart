import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class ChatMenuItem extends StatelessWidget {
  final String icon;
  final String label;
  const ChatMenuItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
