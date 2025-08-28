import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

import 'package:trocado/modules/splash/presentation/screens/splash_screen.dart';

final class SplashModule extends Module {
  @override
  List<IModule> routes() => [
    ChildRoute(
      path: RoutesConstant.splash.path,
      name: RoutesConstant.splash.name,
      child: (_, _) => SplashScreen(),
    ),
  ];
}
