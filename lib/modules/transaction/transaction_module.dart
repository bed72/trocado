import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

final class TransactionModule extends Module {
  @override
  List<IModule> routes() => [
    ChildRoute(
      path: RoutesConstant.transaction.path,
      name: RoutesConstant.transaction.name,
      child: (_, _) => const SizedBox.shrink(),
    ),
  ];
}
