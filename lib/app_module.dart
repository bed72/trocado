import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/core_module.dart';

final class AppModule extends Module {
  @override
  List<Module> imports() => [CoreModule()];

  @override
  void binds() {}

  @override
  List<IModule> routes() => [];
}
