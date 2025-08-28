import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

import 'package:trocado/modules/profile/presentation/screens/profile_screen.dart';

final class ProfileModule extends Module {
  @override
  List<IModule> routes() => [
    ChildRoute(
      path: RoutesConstant.profile.path,
      name: RoutesConstant.profile.name,
      child: (_, _) => ProfileScreen(),
    ),
  ];
}
