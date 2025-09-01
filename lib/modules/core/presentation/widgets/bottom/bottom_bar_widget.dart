import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';

import 'package:trocado/modules/core/domain/constant/icons_constant.dart';
import 'package:trocado/modules/core/domain/constant/routes_constant.dart';

import 'package:trocado/modules/core/presentation/widgets/indicator_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bottom_sheet_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bottom/bottom_bar_menu_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bottom/bottom_bar_item_widget.dart';

class BottomBarWidget extends StatefulWidget {
  final StatefulNavigationShell shell;

  const BottomBarWidget({super.key, required this.shell});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget>
    with TickerProviderStateMixin {
  int? _previousTabIndex;

  final int _bottomSheetTab = 1;
  final int _maxVisibleTabs = 3;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _maxVisibleTabs, vsync: this);
    _tabController.index = widget.shell.currentIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    final branchIndex = index;

    if (branchIndex == _bottomSheetTab) {
      _buildBottomSheet();
      return;
    }

    _setPreviousTabIndex();
    setState(() => _tabController.index = branchIndex);
    widget.shell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.shell.currentIndex,
    );
  }

  void _setPreviousTabIndex() {
    if (_tabController.index == _bottomSheetTab) return;
    _previousTabIndex = _tabController.index;
  }

  bool _shouldHideBottomBar(BuildContext context) => RoutesConstant
      .hideBottomBarTo
      .any((params) => params.regex.hasMatch(context.path));

  @override
  Widget build(BuildContext context) {
    final hideBottomBar = _shouldHideBottomBar(context);

    return PopScope(
      onPopInvokedWithResult: (_, _) async {
        if (context.canPop()) context.pop();
      },
      child: Scaffold(
        body: SafeArea(child: widget.shell),
        bottomNavigationBar: hideBottomBar
            ? null
            : TabBar(
                onTap: _onTap,
                tabs: _buildTabs(),
                dividerHeight: 0.0,
                enableFeedback: false,
                controller: _tabController,
                indicator: IndicatorWidget(),
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                padding: EdgeInsets.only(bottom: 18.0),
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
      ),
    );
  }

  void _buildBottomSheet() {
    bottomSheetScaffoldWidget(
      child: GestureDetector(onTap: () {}, child: BottomBarMenuWidget()),
    ).whenComplete(() {
      setState(() {
        _tabController.index = _previousTabIndex ?? 0;
        widget.shell.goBranch(_previousTabIndex ?? 0);
      });
    });
  }

  List<Widget> _buildTabs() {
    final selectedIndex = _tabController.index;

    final items = [
      ('Home', IconsConstant.house),
      ('Transações', IconsConstant.coins),
      ('Meu perfil', IconsConstant.user),
    ];

    return List.generate(items.length, (index) {
      final (label, iconName) = items[index];
      final isSelected = selectedIndex == index;

      return BottomBarItemWidget(
        icon: iconName,
        semanticLabel: label,
        color: isSelected ? Colors.red : Colors.black38,
      );
    });
  }
}
