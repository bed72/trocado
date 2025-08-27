import 'package:flutter/foundation.dart';

@immutable
final class RoutesConstant {
  final bool auth;
  final String path;
  final String name;
  final RegExp regex;
  final bool hideBottomBar;

  const RoutesConstant._({
    required this.auth,
    required this.path,
    required this.name,
    required this.regex,
    required this.hideBottomBar,
  });

  static final splash = RoutesConstant._(
    auth: false,
    path: '/splash',
    hideBottomBar: true,
    name: 'splash-route',
    regex: RegExp(r'/splash'),
  );

  static final home = RoutesConstant._(
    path: '/',
    auth: false,
    name: 'home-route',
    hideBottomBar: false,
    regex: RegExp(r'^/$'),
  );
}
