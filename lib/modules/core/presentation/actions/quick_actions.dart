import 'package:quick_actions/quick_actions.dart';

enum QuickActionsType { input, output }

void quickAction({required void Function(String) action}) {
  QuickActions()
    ..initialize(action)
    ..setShortcutItems(_items);
}

List<ShortcutItem> get _items => <ShortcutItem>[
  ShortcutItem(
    // icon: 'AppIcon',
    localizedTitle: 'Nova saída',
    type: QuickActionsType.output.name,
    localizedSubtitle: 'Cadastrar nova saída',
  ),
  ShortcutItem(
    // icon: 'ic_launcher',
    localizedTitle: 'Nova entrada',
    type: QuickActionsType.input.name,
    localizedSubtitle: 'Cadastrar nova entrada',
  ),
];
