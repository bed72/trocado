import 'package:modugo/modugo.dart';
import 'package:flutter/material.dart';

import 'package:trocado/modules/core/domain/constant/icons_constant.dart';
import 'package:trocado/modules/core/domain/constant/routes_constant.dart';
import 'package:trocado/modules/core/presentation/actions/quick_actions.dart';

import 'package:trocado/modules/core/presentation/widgets/indicator_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bottom_sheet_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bottom/bottom_bar_menu_widget.dart';
import 'package:trocado/modules/core/presentation/widgets/bottom/bottom_bar_item_widget.dart';

enum _BottomBarItens {
  transaction(position: 1),
  profile(position: 2);

  final int position;

  const _BottomBarItens({required this.position});
}

class BottomBarWidget extends StatefulWidget {
  final StatefulNavigationShell shell;

  const BottomBarWidget({super.key, required this.shell});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget>
    with TickerProviderStateMixin {
  int? _previousTabIndex;

  late final int _maxVisible = 3;
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _maxVisible);
    _controller.index = widget.shell.currentIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      quickAction(
        action: (type) {
          type == QuickActionsType.input.name
              ? _onTap(_BottomBarItens.profile.position)
              : _onTap(_BottomBarItens.transaction.position);
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    final branchIndex = index;

    if (branchIndex == _BottomBarItens.transaction.position) {
      _buildBottomSheet();
      return;
    }

    _setPreviousIndex();
    setState(() => _controller.index = branchIndex);
    widget.shell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.shell.currentIndex,
    );
  }

  void _setPreviousIndex() {
    if (_controller.index == _BottomBarItens.transaction.position) return;
    _previousTabIndex = _controller.index;
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
                controller: _controller,
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
        _controller.index = _previousTabIndex ?? 0;
        widget.shell.goBranch(_previousTabIndex ?? 0);
      });
    });
  }

  List<Widget> _buildTabs() {
    final selectedIndex = _controller.index;

    final items = [
      ('Home', IconsConstant.receipt, IconsConstant.receiptFilled),
      ('Transações', IconsConstant.wallet, IconsConstant.walletFilled),
      ('Meu perfil', IconsConstant.user, IconsConstant.userFilled),
    ];

    return List.generate(items.length, (index) {
      final isSelected = selectedIndex == index;
      final (label, unselectedIcon, selectedIcon) = items[index];

      return BottomBarItemWidget(
        semanticLabel: label,
        icon: isSelected ? selectedIcon : unselectedIcon,
        color: isSelected ? Colors.red : Colors.black38,
      );
    });
  }
}
