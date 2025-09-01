import 'package:flutter/widgets.dart';

import 'svg_strategy.dart';

/// A widget that displays an SVG image.
/// Use [url] to load an SVG from a network URL.
/// Use [name] to load an SVG from the asset bundle.
/// If none is passed the widget will throw an error.
class SvgWidget extends StatelessWidget {
  final String? url;
  final BoxFit? fit;
  final String? name;
  final double? width;
  final double? height;
  final String? semanticsLabel;
  final ColorFilter? colorFilter;

  /// [url] or [name] is required.
  const SvgWidget({
    super.key,
    this.fit,
    this.url,
    this.name,
    this.width,
    this.height,
    this.colorFilter,
    this.semanticsLabel,
  }) : assert(
         (name != null && url == null) || (name == null && url != null),
         'You must provide one of the following: path, name or url',
       );

  @override
  Widget build(BuildContext context) {
    final strategy = name == null
        ? NetworkSvgStrategy()
        : RootAssetSvgStrategy();

    return strategy.build(
      name: name ?? url!,
      width: width,
      fit: fit,
      height: height,
      colorFilter: colorFilter,
      semanticsLabel: semanticsLabel,
    );
  }

  SvgWidget copyWith({
    String? name,
    double? width,
    double? height,
    String? semanticsLabel,
    ColorFilter? colorFilter,
  }) => SvgWidget(
    name: name ?? this.name,
    width: width ?? this.width,
    height: height ?? this.height,
    colorFilter: colorFilter ?? this.colorFilter,
    semanticsLabel: semanticsLabel ?? this.semanticsLabel,
  );
}
