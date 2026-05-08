import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

class CompanySurfaceCard extends StatelessWidget {
  const CompanySurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}
