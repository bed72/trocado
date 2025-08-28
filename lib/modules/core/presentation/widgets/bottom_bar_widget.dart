import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:trocado/modules/core/domain/constant/routes_constant.dart';
import 'package:trocado/modules/core/presentation/extensions/context_extension.dart';

class BottomBarWidget extends StatelessWidget {
  final int _maxVisibleTabs = 5;

  final StatefulNavigationShell _shell;

  const BottomBarWidget({super.key, required StatefulNavigationShell shell})
    : _shell = shell;

  @override
  Widget build(BuildContext context) {
    final hideBottomBar = _shouldHideBottomBar(context);
    final visibleIndex = _getVisibleIndex(_shell.currentIndex);

    return Scaffold(
      body: _shell,
      bottomNavigationBar: hideBottomBar
          ? null
          : Container(
              decoration: BoxDecoration(
                // border: Border(top: BorderSide(color: context.light.secondary)),
              ),
              child: BottomNavigationBar(
                elevation: 0,
                onTap: _onTap,
                showSelectedLabels: false,
                currentIndex: visibleIndex,
                showUnselectedLabels: false,
                items: _buildVisibleItems(context),
                type: BottomNavigationBarType.fixed,
                // backgroundColor: context.light.,
                // selectedItemColor: context.light.secondary,
                // unselectedItemColor: context.light.secondary,
              ),
            ),
    );
  }

  bool _shouldHideBottomBar(BuildContext context) => RoutesConstant
      .hideBottomBarTo
      .any((params) => params.regex.hasMatch(context.path));

  int _getVisibleIndex(int actualIndex) {
    final index = _visibleBranchIndices.indexOf(actualIndex);
    return index == -1 ? 0 : index;
  }

  List<int> get _visibleBranchIndices => List.generate(
    _maxVisibleTabs,
    (i) => i,
  ).where((i) => i < _maxVisibleTabs).toList();

  void _onTap(int index) {
    final branchIndex = _visibleBranchIndices[index];

    _shell.goBranch(branchIndex);
  }

  List<BottomNavigationBarItem> _buildVisibleItems(BuildContext context) {
    final allIcons = [
      (LucideIcons.house200, 'Explorar'),
      (LucideIcons.dollarSign200, 'Transações'),
      (LucideIcons.user200, 'Meu perfil'),
    ];

    return List.generate(
      allIcons.length,
      (i) => _buildItem(
        context: context,
        icon: allIcons[i].$1,
        semanticsLabel: allIcons[i].$2,
      ),
    );
  }

  BottomNavigationBarItem _buildItem({
    required BuildContext context,
    required IconData icon,
    required String semanticsLabel,
  }) => BottomNavigationBarItem(
    label: '',
    icon: Icon(icon, size: 24.0),
    activeIcon: Icon(icon, size: 24.0, fontWeight: FontWeight.w800),
  );
}
