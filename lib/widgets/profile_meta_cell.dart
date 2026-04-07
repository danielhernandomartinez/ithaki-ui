import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Icon + text cell used in profile sub-cards (work experience, education, profile view).
///
/// [alignIconTop] adds a top padding to the icon so it aligns with the first
/// line when the text wraps — useful for education/work sub-cards.
/// [flexible] uses Flexible instead of Expanded, preventing overflow in row grids.
class ProfileMetaCell extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool alignIconTop;
  final bool flexible;
  final double fontSize;

  const ProfileMetaCell(
    this.icon,
    this.value, {
    super.key,
    this.alignIconTop = false,
    this.flexible = false,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return IthakiMetaCell(
      icon,
      value,
      alignIconTop: alignIconTop,
      flexible: flexible,
      fontSize: fontSize,
    );
  }
}
