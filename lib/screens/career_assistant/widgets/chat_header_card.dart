import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class ChatHeaderCard extends StatelessWidget {
  final VoidCallback onMenu;
  const ChatHeaderCard({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Chat with your\nCareer Assistant',
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: onMenu,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: IthakiTheme.borderLight),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '...',
                  style: TextStyle(fontSize: 18, color: IthakiTheme.softGraphite),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
