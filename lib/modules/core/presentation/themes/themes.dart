import 'package:flutter/material.dart';
import 'package:trocado/modules/core/presentation/themes/colors/color_theme.dart';

final class Themes {
  static final _colors = ColorsTheme.build();

  static get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Museo Sans',
    brightness: Brightness.light,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: _colors.background,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    extensions: <ThemeExtension<dynamic>>[ColorsTheme.build()],
  );
}
