import 'package:flutter/material.dart';
import 'package:modugo/modugo.dart';

Future<T?> bottomSheetScaffoldWidget<T>({
  required Widget child,
  double marginTop = 32,
  bool autoResize = false,
}) => showModalBottomSheet<T>(
  useSafeArea: true,
  isScrollControlled: true,
  context: modularNavigatorKey.currentContext!,
  builder: (BuildContext context) => Container(
    constraints: autoResize
        ? null
        : BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - marginTop,
          ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: child,
  ),
);
