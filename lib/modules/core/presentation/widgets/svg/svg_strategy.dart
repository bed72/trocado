import 'package:flutter/widgets.dart';

import 'package:flutter_svg/svg.dart';

import 'package:trocado/modules/core/domain/constant/icons_constant.dart';

abstract interface class SvgStrategy {
  Widget build({
    required String name,
    BoxFit? fit,
    double? width,
    double? height,
    String? semanticsLabel,
    ColorFilter? colorFilter,
  });
}

class RootAssetSvgStrategy implements SvgStrategy {
  @override
  Widget build({
    required String name,
    BoxFit? fit,
    double? width,
    double? height,
    String? semanticsLabel,
    ColorFilter? colorFilter,
  }) => SvgPicture.asset(
    '${IconsConstant.path.name}ic_$name.svg',
    width: width,
    height: height,
    fit: fit ?? BoxFit.none,
    colorFilter: colorFilter,
    semanticsLabel: semanticsLabel,
  );
}

class NetworkSvgStrategy implements SvgStrategy {
  @override
  Widget build({
    required String name,
    BoxFit? fit,
    double? width,
    double? height,
    String? semanticsLabel,
    ColorFilter? colorFilter,
  }) => SvgPicture.network(
    name,
    width: width,
    height: height,
    colorFilter: colorFilter,
    semanticsLabel: semanticsLabel,
  );
}
