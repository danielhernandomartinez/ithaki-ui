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
    final iconWidget = Icon(icon, size: 14, color: IthakiTheme.softGraphite);
    final textWidget = Text(
      value,
      style: TextStyle(fontSize: fontSize, color: IthakiTheme.textSecondary),
      overflow: flexible ? TextOverflow.ellipsis : null,
    );

    return Row(
      crossAxisAlignment:
          alignIconTop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        alignIconTop
            ? Padding(padding: const EdgeInsets.only(top: 1), child: iconWidget)
            : iconWidget,
        const SizedBox(width: 4),
        flexible ? Flexible(child: textWidget) : Expanded(child: textWidget),
      ],
    );
  }
}
