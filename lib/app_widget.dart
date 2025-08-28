import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:trocado/modules/core/presentation/themes/themes.dart';
import 'package:trocado/modules/core/presentation/widgets/load_widget.dart';

final class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trocado',
      theme: Themes.light,
      routerConfig: Modugo.routerConfig,
      debugShowCheckedModeBanner: kDebugMode,
      builder: (_, child) => LoadWidget(child: child),
    );
  }
}
