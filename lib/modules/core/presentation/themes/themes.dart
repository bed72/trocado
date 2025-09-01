import 'package:flutter/material.dart';

final class Themes {
  static theme(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Museo Sans',
    canvasColor: scheme.surface,
    brightness: scheme.brightness,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory,
    scaffoldBackgroundColor: scheme.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // textTheme: TextTheme.apply(
    //   bodyColor: scheme.onSurface,
    //   displayColor: scheme.onSurface,
    // ),
  );
}
