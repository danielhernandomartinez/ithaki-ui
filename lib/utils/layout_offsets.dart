import 'package:flutter/material.dart';

extension IthakiLayoutOffsets on BuildContext {
  double get ithakiTopOffset =>
      MediaQuery.paddingOf(this).top + kToolbarHeight + 16;

  double get ithakiPanelTopOffset => ithakiTopOffset - 14;
}
