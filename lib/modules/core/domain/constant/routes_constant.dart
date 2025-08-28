import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

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
    auth: true,
    name: 'home-route',
    hideBottomBar: false,
    regex: RegExp(r'^/$'),
  );

  static final profile = RoutesConstant._(
    auth: true,
    path: '/profile',
    hideBottomBar: false,
    name: 'profile-route',
    regex: RegExp(r'^/profile'),
  );

  static final transaction = RoutesConstant._(
    auth: true,
    path: '/transaction',
    hideBottomBar: false,
    name: 'transaction-route',
    regex: RegExp(r'^/transaction'),
  );

  static final _all = [home, splash, profile, transaction];

  static List<RoutesConstant> get hideBottomBarTo =>
      _all.where((route) => route.hideBottomBar == true).toList();

  static RoutesConstant? match(String location) =>
      _all.firstWhereOrNull((route) => route.regex.hasMatch(location));

  static bool needsAuthentication(String location) =>
      _all.firstWhereOrNull((route) => route.regex.hasMatch(location))?.auth ??
      false;
}
