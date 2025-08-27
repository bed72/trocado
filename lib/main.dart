import 'package:modugo/modugo.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:trocado/app_module.dart';
import 'package:trocado/app_resolver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Modugo.configure(
    initialRoute: '/',
    module: AppModule(),
    errorBuilder: AppResolver.error,
    debugLogDiagnostics: kDebugMode,
    debugLogDiagnosticsGoRouter: kDebugMode,
  );

  runApp(AppResolver.app);
}
