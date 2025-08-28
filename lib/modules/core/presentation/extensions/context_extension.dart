import 'package:flutter/material.dart';

import 'package:trocado/modules/core/presentation/themes/colors/color_theme.dart';

extension ThemeExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  ColorsTheme get colors => Theme.of(this).extension<ColorsTheme>()!;
}
