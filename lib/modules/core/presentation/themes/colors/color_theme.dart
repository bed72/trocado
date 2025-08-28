import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'color_theme.tailor.dart';

@TailorMixin(themeGetter: ThemeGetter.none)
class ColorsTheme extends ThemeExtension<ColorsTheme>
    with _$ColorsThemeTailorMixin {
  @override
  final Color text;
  @override
  final Color primary;
  @override
  final Color secondary;
  @override
  final Color background;

  const ColorsTheme({
    required this.text,
    required this.primary,
    required this.secondary,
    required this.background,
  });

  factory ColorsTheme.build() => ColorsTheme(
    text: Colors.black,
    background: Colors.white,
    primary: Colors.greenAccent,
    secondary: Colors.orangeAccent,
  );
}
