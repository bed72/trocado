import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

import 'package:trocado/modules/home/presentation/screens/home_screen.dart';

final class HomeModule extends Module {
  @override
  List<IModule> routes() => [
    ChildRoute(
      path: RoutesConstant.home.path,
      name: RoutesConstant.home.name,
      child: (_, _) => HomeScreen(),
    ),
  ];
}
