import 'package:flutter/foundation.dart';

/// A function type that intercepts and potentially transforms state changes.
///
/// Middlewares run in the order they are registered and can:
/// - Transform the next state before it is applied.
/// - Block a state change by returning the previous state.
/// - Add side effects such as logging or analytics.
///
/// Example:
/// ```dart
/// notifier.addMiddleware((next, prev) {
///   if (next == prev) return prev; // block redundant updates
///   print('State changing from $prev to $next');
///   return next;
/// });
/// ```
typedef StateMiddleware<T> = T Function(T next, T previous);

/// Immutable event object representing a transition between two states.
///
/// Passed into [StateNotifier.onBeforeChange] and [StateNotifier.onAfterChange]
/// to provide detailed information about the change that is about to happen
/// or has just happened.
///
/// Example:
/// ```dart
/// notifier.onBeforeChange = (event) {
///   print('Before: ${event.previous} → ${event.next}');
/// };
/// notifier.onAfterChange = (event) {
///   print('After: ${event.previous} → ${event.next}');
/// };
/// ```
final class StateChangeEvent<T> {
  /// The new state that will replace the previous one.
  final T next;

  /// The state that is being replaced.
  final T previous;

  const StateChangeEvent({required this.next, required this.previous});
}

/// A reactive state holder inspired by [ChangeNotifier] but with additional capabilities.
///
/// Compared to a plain [ChangeNotifier], `StateNotifier` offers:
/// - Strongly typed immutable state via [state].
/// - Automatic notifications whenever [state] is updated.
/// - Middlewares to intercept, transform or block updates.
/// - Before/after change callbacks for side effects (logging, metrics).
/// - State history for debugging or time travel.
/// - Optional auto-dispose when no listeners remain.
/// - Granular selectors that allow observing only parts of the state.
///
/// This makes it a lightweight alternative to solutions like MobX or Riverpod,
/// while remaining simple and dependency-free.
///
/// ## Example
///
/// ```dart
/// class CounterNotifier extends StateNotifier<int> {
///   CounterNotifier() : super(0);
///
///   void increment() => state = state + 1;
///   void decrement() => state = state - 1;
/// }
///
/// final counter = CounterNotifier();
///
/// counter.addListener(() {
///   print('New state: ${counter.state}');
/// });
///
/// counter.increment(); // prints: New state: 1
/// ```
///
/// ## Granular selectors
///
/// ```dart
/// class User {
///   final String name;
///   final int age;
///   const User(this.name, this.age);
/// }
///
/// class UserNotifier extends StateNotifier<User> {
///   UserNotifier() : super(const User('Alice', 20));
///   void setName(String name) => state = User(name, state.age);
///   void setAge(int age) => state = User(state.name, age);
/// }
///
/// final userNotifier = UserNotifier();
///
/// // Listen only to changes in the `name` field
/// ValueListenableBuilder(
///   valueListenable: userNotifier.select((u) => u.name),
///   builder: (_, name, _) => Text('Name: $name'),
/// );
/// ```
abstract class StateNotifier<T> extends ChangeNotifier {
  T _state;
  final bool autoDispose;
  final List<T> _history = [];
  final List<StateMiddleware<T>> _middlewares = [];

  /// Whether this notifier has already been disposed.
  bool _disposed = false;

  /// Callback invoked when [dispose] is called.
  VoidCallback? onDispose;

  /// The current state value.
  T get state => _state;
  bool get disposed => _disposed;

  /// Immutable history of all previously applied states.
  List<T> get history => List.unmodifiable(_history);

  /// Callback invoked right after the state has been updated.
  void Function(StateChangeEvent<T> event)? onAfterChange;

  /// Callback invoked right before the state is updated.
  void Function(StateChangeEvent<T> event)? onBeforeChange;

  /// Creates a new [StateNotifier] with the given initial [state].
  ///
  /// If [autoDispose] is true, the notifier will automatically
  /// call [dispose] once the last listener is removed.
  StateNotifier(this._state, {this.autoDispose = false});

  /// Registers a [middleware] that will be executed for every state change.
  ///
  /// Middlewares run in the order they are registered and can:
  /// - Modify the new state.
  /// - Prevent an update by returning the previous state.
  /// - Trigger side effects such as logging.
  void addMiddleware(StateMiddleware<T> middleware) {
    _middlewares.add(middleware);
  }

  /// Updates the state and notifies listeners if the value has changed.
  ///
  /// - Applies all registered [middlewares].
  /// - Invokes [onBeforeChange] before updating.
  /// - Appends the new state to [history].
  /// - Notifies listeners and granular selectors.
  /// - Invokes [onAfterChange] after updating.
  @protected
  set state(T value) {
    if (_disposed) {
      throw StateError(
        'Attempted to modify state on a disposed StateNotifier.',
      );
    }

    T next = value;
    for (final mw in _middlewares) {
      next = mw(_state, next);
    }

    if (next == _state) return;

    final event = StateChangeEvent(previous: _state, next: next);
    onBeforeChange?.call(event);

    _history.add(next);
    _state = next;

    notifyListeners();
    _notifySelectors(_state, event);

    onAfterChange?.call(event);
  }

  /// Internal registry of active selectors for granular subscriptions.
  final List<_SelectorSubscription<T, dynamic>> _selectors = [];

  /// Creates a granular [ValueListenable] for a specific projection of the state.
  ///
  /// Example:
  /// ```dart
  /// final nameListenable = userNotifier.select((u) => u.name);
  ///
  /// ValueListenableBuilder(
  ///   valueListenable: nameListenable,
  ///   builder: (_, name, _) => Text(name),
  /// );
  /// ```
  ValueListenable<P> select<P>(P Function(T state) selector) {
    final subscription = _SelectorSubscription<T, P>(selector, _state);
    _selectors.add(subscription);
    return subscription;
  }

  void _notifySelectors(T newState, StateChangeEvent<T> event) {
    for (final sub in _selectors) {
      sub.update(newState);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (autoDispose && !hasListeners) dispose();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    for (final sub in _selectors) {
      sub.dispose();
    }
    _selectors.clear();

    onDispose?.call();
    super.dispose();
  }
}

/// A granular subscription created by [StateNotifier.select].
///
/// Implements [ValueListenable] so it can be consumed with
/// [ValueListenableBuilder] or similar widgets.
/// Each subscription tracks the last projected value of the state
/// and only notifies listeners when that projection changes.
///
/// Example:
/// ```dart
/// final ageListenable = userNotifier.select((u) => u.age);
///
/// ValueListenableBuilder(
///   valueListenable: ageListenable,
///   builder: (_, age, _) => Text('$age years old'),
/// );
/// ```
class _SelectorSubscription<T, P> extends ChangeNotifier
    implements ValueListenable<P> {
  P _lastValue;
  final P Function(T) selector;

  @override
  P get value => _lastValue;

  _SelectorSubscription(this.selector, T state) : _lastValue = selector(state);

  /// Updates the projected value when the underlying state changes.
  ///
  /// If the projection result is equal to the previous one,
  /// listeners are not notified.
  void update(T newState) {
    final selected = selector(newState);
    if (selected == _lastValue) return;
    _lastValue = selected;
    notifyListeners();
  }
}
