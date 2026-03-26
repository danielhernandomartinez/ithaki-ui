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
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: appBarTitle),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.viewPaddingOf(context).bottom + 32),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 6),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 13, color: IthakiTheme.textSecondary)),
              const SizedBox(height: 20),
              ...entries,
              OutlinedButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add, size: 16),
                label: Text(addButtonLabel),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: IthakiTheme.softGraphite),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  foregroundColor: IthakiTheme.textPrimary,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 16),
              IthakiButton('Save', onPressed: onSavePressed),
            ],
          ),
        ),
      ),
    );
  }
}
