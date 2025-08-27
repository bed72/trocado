import 'package:modugo/modugo.dart';
import 'package:flutter/widgets.dart';

import 'package:trocado/app_widget.dart';

final class AppResolver {
  static Widget get app => ModugoLoaderWidget(
    loading: const Placeholder(),
    dependencies: _dependencies(),
    builder: (_) => const AppWidget(),
  );

  static Widget error(BuildContext context, GoRouterState state) {
    context.go('/');
    return const Placeholder();
  }

  static Future<List<Future<void>>> _dependencies() async {
    return Future.value([Modugo.i.allReady()]);
  }
}
