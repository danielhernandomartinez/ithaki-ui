import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

List<Color> getMatchGradientColors(String matchLabel) {
  switch (matchLabel) {
    case 'STRONG MATCH':
    case 'GREAT MATCH':
      return [IthakiTheme.matchGradientHighStart, IthakiTheme.matchGreen];
    case 'GOOD MATCH':
      return [IthakiTheme.matchGradientGoodStart, IthakiTheme.matchGradientGoodEnd];
    case 'WEAK MATCH':
      return [IthakiTheme.matchGradientWeakStart, IthakiTheme.matchGradientWeakEnd];
    case 'NO BENEFICIARIES MATCH':
      return [IthakiTheme.matchGradientNoneStart, IthakiTheme.matchGradientNoneEnd];
    default:
      return [IthakiTheme.matchGradientHighStart, IthakiTheme.matchGreen];
  }
}

Color getMatchBgColor(String matchLabel) {
  switch (matchLabel) {
    case 'STRONG MATCH':
    case 'GREAT MATCH':
      return IthakiTheme.matchBarBg;
    case 'GOOD MATCH':
      return IthakiTheme.matchBgGood;
    case 'WEAK MATCH':
      return IthakiTheme.matchBgWeak;
    case 'NO BENEFICIARIES MATCH':
      return IthakiTheme.softGray;
    default:
      return IthakiTheme.matchBarBg;
  }
}
