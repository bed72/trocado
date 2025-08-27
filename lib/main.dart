import 'package:modugo/modugo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:trocado/app_module.dart';
import 'package:trocado/app_resolver.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Modugo.configure(
    module: AppModule(),
    debugLogDiagnostics: kDebugMode,
    errorBuilder: AppResolver.failure,
    debugLogDiagnosticsGoRouter: kDebugMode,
    initialRoute: RoutesConstant.splash.path,
  );

  runApp(AppResolver.app);
}
