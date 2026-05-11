import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';

class ApplicationsTabBar extends StatefulWidget {
  final TabController controller;
  final int invitationsCount;

  const ApplicationsTabBar({
    super.key,
    required this.controller,
    required this.invitationsCount,
  });

  @override
  State<ApplicationsTabBar> createState() => _ApplicationsTabBarState();
}

class _ApplicationsTabBarState extends State<ApplicationsTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tabs = [
      l.myApplicationsTabLabel,
      l.myInvitationsTabLabel(widget.invitationsCount),
      l.draftsTabLabel,
      l.archiveTabLabel,
    ];

    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabs.length, (i) {
              final isActive = widget.controller.index == i;
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
                child: GestureDetector(
                  onTap: () => widget.controller.animateTo(i),
                  child: Container(
                    height: 40,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? IthakiTheme.backgroundWhite
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabs[i],
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? IthakiTheme.textPrimary
                            : IthakiTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
