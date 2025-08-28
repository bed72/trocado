import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:trocado/modules/core/presentation/widgets/bounce_widget.dart';

class BottomBarItemWidget extends StatelessWidget {
  final Color color;
  final String semanticLabel;
  final PhosphorIconData icon;

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
        child: Icon(icon, size: 24, color: color, semanticLabel: semanticLabel),
      ),
    );
  }
}
