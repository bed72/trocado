// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_theme.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$ColorsThemeTailorMixin on ThemeExtension<ColorsTheme> {
  Color get text;
  Color get primary;
  Color get secondary;
  Color get background;

  @override
  ColorsTheme copyWith({
    Color? text,
    Color? primary,
    Color? secondary,
    Color? background,
  }) {
    return ColorsTheme(
      text: text ?? this.text,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
    );
  }

  @override
  ColorsTheme lerp(covariant ThemeExtension<ColorsTheme>? other, double t) {
    if (other is! ColorsTheme) return this as ColorsTheme;
    return ColorsTheme(
      text: Color.lerp(text, other.text, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ColorsTheme &&
            const DeepCollectionEquality().equals(text, other.text) &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary) &&
            const DeepCollectionEquality().equals(
              background,
              other.background,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(secondary),
      const DeepCollectionEquality().hash(background),
    );
  }
}
