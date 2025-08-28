import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => context.go(RoutesConstant.home.path),
            child: Text('Splash'),
          ),
        ),
      ),
    );
  }
}
