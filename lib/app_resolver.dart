import 'package:modugo/modugo.dart';
import 'package:flutter/widgets.dart';

import 'package:trocado/app_widget.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

import 'package:trocado/modules/core/presentation/widgets/load_widget.dart';
import 'package:trocado/modules/core/presentation/screens/failure_screen.dart';

final class AppResolver {
  static Widget get app => ModugoLoaderWidget(
    loading: const LoadWidget(),
    dependencies: _dependencies(),
    builder: (_) => const AppWidget(),
  );

  static Widget failure(BuildContext context, GoRouterState state) {
    context.go(RoutesConstant.home.path);
    return const FailureScreen();
  }

  static Future<List<Future<void>>> _dependencies() async {
    return Future.value([Modugo.i.allReady()]);
  }
}
