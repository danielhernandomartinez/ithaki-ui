import 'package:flutter/material.dart';

extension IthakiLayoutOffsets on BuildContext {
  double get ithakiTopOffset =>
      MediaQuery.paddingOf(this).top + kToolbarHeight + 8;

  double get ithakiPanelTopOffset =>
      MediaQuery.paddingOf(this).top + kToolbarHeight + 2;
}
