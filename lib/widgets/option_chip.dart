import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IthakiOptionChip(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}
