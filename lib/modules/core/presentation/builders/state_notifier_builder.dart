import 'package:flutter/widgets.dart';

import 'package:trocado/modules/core/presentation/notifiers/state_notifier.dart';

/// A convenience widget for consuming a [StateNotifier] in the widget tree.
///
/// This widget is responsible for:
/// - Creating the [StateNotifier] instance using [create].
/// - Listening to its state changes.
/// - Rebuilding the UI through the [builder] callback whenever the state changes.
/// - Disposing the [StateNotifier] automatically when removed from the tree.
///
/// It is conceptually similar to:
/// - `Consumer` in Provider
/// - `Observer` in MobX
/// - `StateNotifierProvider` in Riverpod
///
/// Example:
///
/// ```dart
/// class CounterNotifier extends StateNotifier<int> {
///   CounterNotifier() : super(0);
///
///   void increment() => state++;
/// }
///
/// class CounterScreen extends StatelessWidget {
///   const CounterScreen({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return StateNotifierBuilder<int, CounterNotifier>(
///       create: () => CounterNotifier(),
///       builder: (context, state, notifier) {
///         return Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: [
///             Text('Count: $state'),
///             ElevatedButton(
///               onPressed: notifier.increment,
///               child: const Text('Increment'),
///             ),
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
///
/// This widget is useful for local state, when you don't want to manage
/// the [StateNotifier] lifecycle manually.
class StateNotifierBuilder<T, N extends StateNotifier<T>>
    extends StatefulWidget {
  /// Function that creates the [StateNotifier] instance.
  ///
  /// This function is called only once during [initState].
  final N Function() create;

  /// Builds the UI whenever the [StateNotifier] emits a new [state].
  ///
  /// Provides the [BuildContext], the current [state], and the [notifier] itself
  /// so that actions can be triggered directly from the UI.
  final Widget Function(BuildContext context, T state, N notifier) builder;

  /// Creates a new [StateNotifierBuilder].
  ///
  /// - [create] must return a new [StateNotifier] instance.
  /// - [builder] will be called every time the notifier's state changes.
  const StateNotifierBuilder({
    super.key,
    required this.create,
    required this.builder,
  });

  @override
  State<StateNotifierBuilder<T, N>> createState() =>
      _StateNotifierBuilderState<T, N>();
}

class _StateNotifierBuilderState<T, N extends StateNotifier<T>>
    extends State<StateNotifierBuilder<T, N>> {
  late final N notifier;

  @override
  void initState() {
    super.initState();
    notifier = widget.create();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: notifier,
    builder: (_, _) => widget.builder(context, notifier.state, notifier),
  );
}
