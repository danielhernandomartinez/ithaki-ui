import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Tappable picker field that looks like a text field with a dropdown arrow.
/// Used for SearchBottomSheet pickers in profile edit screens.
class ProfilePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final VoidCallback onTap;
  final double fontSize;
  final double verticalPadding;
  final double arrowSize;

  const ProfilePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onTap,
    this.fontSize = 16,
    this.verticalPadding = 14,
    this.arrowSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: verticalPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value : hint,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                      color: hasValue
                          ? IthakiTheme.textPrimary
                          : IthakiTheme.softGraphite,
                    ),
                  ),
                ),
                IthakiIcon('arrow-down',
                    size: arrowSize, color: IthakiTheme.softGraphite),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
