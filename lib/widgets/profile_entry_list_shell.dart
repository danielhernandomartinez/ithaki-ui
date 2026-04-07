import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Shared scaffold for profile list screens (Work Experience, Education).
/// Renders the white card with header, entry list, add button, and save.
class ProfileEntryListShell extends StatelessWidget {
  final String appBarTitle;
  final String title;
  final String subtitle;
  final List<Widget> entries;
  final String addButtonLabel;
  final VoidCallback onAddPressed;
  final VoidCallback onSavePressed;

  const ProfileEntryListShell({
    super.key,
    required this.appBarTitle,
    required this.title,
    required this.subtitle,
    required this.entries,
    required this.addButtonLabel,
    required this.onAddPressed,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return IthakiEntryListShell(
      appBarTitle: appBarTitle,
      title: title,
      subtitle: subtitle,
      entries: entries,
      addButtonLabel: addButtonLabel,
      onAddPressed: onAddPressed,
      onSavePressed: onSavePressed,
    );
  }
}
