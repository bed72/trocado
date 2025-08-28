import 'package:flutter/material.dart';

class BottomBarMenuWidget extends StatelessWidget {
  const BottomBarMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(title: const Text('Option 1'), onTap: () {}),
          ListTile(title: const Text('Option 2'), onTap: () {}),
        ],
      ),
    );
  }
}
