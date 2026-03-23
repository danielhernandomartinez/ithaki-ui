// lib/widgets/bottom_sheet_base.dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// White modal bottom sheet scaffold with title and × close button.
/// Usage:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => BottomSheetBase(title: 'X', child: ...),
///   );
class BottomSheetBase extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onClose;

  const BottomSheetBase({
    super.key,
    required this.title,
    required this.child,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 22, color: IthakiTheme.textPrimary),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}
