import 'dart:io';

import 'package:trocado/modules/core/domain/constant/icons_constant.dart';

/// Run Script:
/// dart run lib/modules/core/presentation/icons/tools/generate_icons.dart

void main() {
  final lib = 'lib/modules/core/presentation/icons';
  final icons = '$lib/svgs';

  final buffer = StringBuffer();
  final root = Directory(icons);
  final output = File('$lib/generated/app_icons.dart');
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.svg'));

  buffer.writeln('''
// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/widgets.dart';

import 'package:trocado/modules/core/presentation/widgets/icon_widget.dart';

final class AppIcons {''');

  for (final file in files) {
    final relative = file.path.split('$icons/').last;
    final name = '${IconsConstant.path.name}$relative'.replaceAll('\\', '/');
    final method = _toCamelCase(
      relative.replaceAll('.svg', '').replaceAll('/', '_'),
    );

    buffer.writeln('''
  static Widget $method({
    Color? color,
    double? width,
    double? height,
    String? semanticsLabel,
  }) => IconWidget(
      name: '$name',
      color: color,
      width: width,
      height: height,
      semanticsLabel: semanticsLabel,
    );
    ''');
  }

  buffer.writeln('}');

  output.writeAsStringSync(buffer.toString());
}

String _toCamelCase(String input) {
  final name = input.split('/').last.replaceAll('.svg', '');
  final parts = name.split(RegExp(r'[_\s-]+'));

  return parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}
