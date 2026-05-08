import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class CvSectionCard extends StatelessWidget {
  const CvSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 12),
            IthakiOutlineButton(
              actionLabel!,
              icon: const IthakiIcon('edit-pencil', size: 18),
              onPressed: onActionPressed,
              borderRadius: 22,
            ),
          ],
        ],
      ),
    );
  }
}
