import 'package:flutter/material.dart';

import 'package:trocado/modules/core/presentation/widgets/svg/svg_widget.dart';

class IconWidget extends StatelessWidget {
  final String name;
  final Color? color;
  final double? width;
  final double? height;
  final String? semanticsLabel;

  const IconWidget({
    super.key,
    required this.name,
    this.color,
    this.width,
    this.height,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) => SvgWidget(
    name: name,
    width: width,
    height: height,
    semanticsLabel: semanticsLabel,
    colorFilter: color == null
        ? null
        : ColorFilter.mode(color!, BlendMode.srcIn),
  );
}
