import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/core_module.dart';
import 'package:trocado/modules/home/home_module.dart';
import 'package:trocado/modules/splash/splash_module.dart';
import 'package:trocado/modules/profile/profile_module.dart';
import 'package:trocado/modules/transaction/transaction_module.dart';

import 'package:trocado/modules/core/presentation/widgets/bottom/bottom_bar_widget.dart';

final class AppModule extends Module {
  @override
  List<Module> imports() => [CoreModule()];

  @override
  List<IModule> routes() => [
    ModuleRoute(name: 'splash-module', module: SplashModule()),

    StatefulShellModuleRoute(
      builder: (_, _, shell) => BottomBarWidget(shell: shell),
      routes: [
        ModuleRoute(name: 'home-module', module: HomeModule()),
        ModuleRoute(name: 'transaction-module', module: TransactionModule()),
        ModuleRoute(name: 'profile-module', module: ProfileModule()),
      ],
    ),
  ];
}
