import 'package:flutter/material.dart';

import 'package:trocado/modules/core/domain/constant/icons_constant.dart';

import 'package:trocado/modules/core/presentation/widgets/icon_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bounce_widget.dart';

class BottomBarItemWidget extends StatelessWidget {
  final Color color;
  final IconsConstant icon;
  final String semanticLabel;

  const BottomBarItemWidget({
    super.key,
    required this.icon,
    required this.color,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return BounceWidget.withoutTap(
      child: Tab(
        child: IconWidget(
          width: 24.0,
          height: 24.0,
          color: color,
          name: icon.name,
          semanticsLabel: semanticLabel,
        ),
      ),
    );
  }
}
