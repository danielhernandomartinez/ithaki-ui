import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class SwitchLiteSheet extends StatelessWidget {
  final BuildContext parentContext;
  const SwitchLiteSheet({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BottomSheetBase(
      title: 'Switch to Ithaki Lite?',
      onClose: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "The interface will become simpler and easier to use. We'll show you only the jobs that best match your job interests.\nYou can switch back to the full interface at any time.",
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: const BorderSide(color: IthakiTheme.softGraphite),
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: IthakiTheme.textPrimary,
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(height: 10),
          IthakiButton(
            'Switch to Ithaki Lite',
            onPressed: () {
              Navigator.pop(context);
              SuccessBanner.show(parentContext, 'Switched to Ithaki Lite.');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
