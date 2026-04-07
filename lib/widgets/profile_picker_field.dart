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
    return IthakiSelectorField(
      label: label,
      hint: hint,
      value: value.isEmpty ? null : value,
      onTap: onTap,
      fontSize: fontSize,
      verticalPadding: verticalPadding,
      arrowSize: arrowSize,
    );
  }
}
