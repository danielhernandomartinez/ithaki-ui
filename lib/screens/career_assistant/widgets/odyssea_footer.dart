import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class OdysseaFooter extends StatelessWidget {
  const OdysseaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        children: [
          const Text(
            'Odyssea',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final icon in ['home', 'eye', 'profile', 'team', 'envelope', 'search'])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
