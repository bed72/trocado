import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';

final class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trocado',
      routerConfig: Modugo.routerConfig,
    );
  }
}
