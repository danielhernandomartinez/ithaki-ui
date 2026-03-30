import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

/// Shared scaffold for profile edit screens:
/// violet background + app bar + scrollable white rounded panel + Save button.
class PanelScaffold extends StatelessWidget {
  const PanelScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
  });

  final String title;
  final List<Widget> children;

  /// Passed directly to [IthakiButton]; null disables the button.
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 16,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: IthakiTheme.backgroundWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...children,
              const SizedBox(height: 28),
              IthakiButton('Save', onPressed: onSave),
            ],
          ),
        ),
      ),
    );
  }
}
