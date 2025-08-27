import 'package:flutter/material.dart';

class LoadWidget extends StatelessWidget {
  final Widget? child;

  const LoadWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.green,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
