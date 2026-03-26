import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

List<Color> getMatchGradientColors(String matchLabel) {
  switch (matchLabel) {
    case 'STRONG MATCH':
      return const [Color(0xFF50C948), Color(0xFF75E767)];
    case 'GREAT MATCH':
      return const [Color(0xFF50C948), Color(0xFF75E767)];
    case 'GOOD MATCH':
      return const [Color(0xFFA8D84E), Color(0xFFC8E86E)];
    case 'WEAK MATCH':
      return const [Color(0xFFE8C84E), Color(0xFFF0DD6E)];
    case 'NO BENEFICIARIES MATCH':
      return const [Color(0xFFBDBDBD), Color(0xFFD0D0D0)];
    default:
      return const [Color(0xFF50C948), Color(0xFF75E767)];
  }
}

Color getMatchBgColor(String matchLabel) {
  switch (matchLabel) {
    case 'STRONG MATCH':
    case 'GREAT MATCH':
      return IthakiTheme.matchBarBg;
    case 'GOOD MATCH':
      return const Color(0xFFF5F9E8);
    case 'WEAK MATCH':
      return const Color(0xFFFDF8E4);
    case 'NO BENEFICIARIES MATCH':
      return IthakiTheme.softGray;
    default:
      return IthakiTheme.matchBarBg;
  }
}
