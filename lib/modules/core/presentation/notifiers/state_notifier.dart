import 'package:flutter/foundation.dart';

/// A function type that intercepts and potentially transforms state changes.
///
/// Middlewares run **in the order they were added** and can:
/// - Transform the next state before it is applied.
/// - Block a state change by returning the previous state.
/// - Add side effects such as logging or analytics.
///
/// Signature contract:
/// - `next` is the candidate state about to be applied
/// - `previous` is the current state before the change
///
/// Example:
/// ```dart
/// notifier.addMiddleware((next, previous) {
///   if (next == previous) return previous; // block redundant updates
///   debugPrint('State changing: $previous → $next');
///   return next;
/// });
/// ```
typedef StateMiddleware<T> = T Function(T previous, T next);

/// Immutable event object representing a transition between two states.
///
/// Passed into [StateNotifier.onBeforeChange] and [StateNotifier.onAfterChange]
/// to provide detailed information about the change that is about to happen
/// or has just happened.
///
/// Example:
/// ```dart
/// notifier.onBeforeChange = (e) => debugPrint('Before: ${e.previous} → ${e.next}');
/// notifier.onAfterChange  = (e) => debugPrint('After:  ${e.previous} → ${e.next}');
/// ```
final class StateChangeEvent<T> {
  /// The new state that will replace the previous one.
  final T next;

  /// The state that is being replaced.
  final T previous;

  const StateChangeEvent({required this.next, required this.previous});
}

/// A reactive, dependency-free state holder inspired by [ChangeNotifier]
/// with extra capabilities:
///
/// - Strongly typed, immutable-style state via [state].
/// - `emit`/`update` helpers for ergonomic state changes.
/// - Middlewares to intercept, transform or block updates.
/// - Before/after change callbacks for side effects (logging, metrics).
/// - State history for debugging or time travel.
/// - Optional auto-dispose when no listeners remain.
/// - Granular selectors that allow observing only parts of the state.
///
/// This makes it a lightweight alternative to more opinionated solutions,
/// while remaining simple and testable.
///
/// ## Quick example
///
/// ```dart
/// class CounterNotifier extends StateNotifier<int> {
///   CounterNotifier() : super(0);
///
///   void increment() => update((c) => c + 1);
///   void decrement() => emit(state - 1);
/// }
///
/// final counter = CounterNotifier()
///   ..addMiddleware((next, prev) => next < 0 ? prev : next); // disallow negatives
/// ```
///
/// ## Granular selectors
///
/// Use [select] to listen only to a projection of the state (reduces rebuilds):
///
/// ```dart
/// final nameListenable = userNotifier.select((u) => u.name);
/// ValueListenableBuilder(
///   valueListenable: nameListenable,
///   builder: (_, name, __) => Text('Name: $name'),
/// );
/// ```
abstract class StateNotifier<T> extends ChangeNotifier {
  /// Creates a new [StateNotifier] with the given initial [state].
  ///
  /// If [autoDispose] is true, the notifier will automatically call [dispose]
  /// once the last listener is removed.
  StateNotifier(this._state, {this.autoDispose = false});

  // ----------------------- Internal fields -----------------------

  T _state;
  bool _disposed = false;
  final bool autoDispose;
  final List<T> _history = [];
  final List<StateMiddleware<T>> _middlewares = [];

  /// Registry of active granular selectors.
  final List<_SelectorSubscription<T, dynamic>> _selectors = [];

  // ----------------------- Lifecycle & flags ---------------------

  /// Whether this notifier has already been disposed.
  bool get disposed => _disposed;

  /// Callback invoked when [dispose] is called.
  VoidCallback? onDispose;

  // ----------------------- State accessors -----------------------

  /// The current state value.
  T get state => _state;

  /// Immutable history of all **applied** states (snapshots *after* middlewares).
  List<T> get history => List.unmodifiable(_history);

  // ----------------------- Hooks & middleware --------------------

  /// Callback invoked right before the state is updated.
  void Function(StateChangeEvent<T> event)? onBeforeChange;

  /// Callback invoked right after the state has been updated.
  void Function(StateChangeEvent<T> event)? onAfterChange;

  /// Registers a [middleware] that will be executed for every state change.
  ///
  /// Middlewares run in the order they are registered and can:
  /// - Modify the new state.
  /// - Prevent an update by returning the previous state.
  /// - Trigger side effects such as logging.
  void addMiddleware(StateMiddleware<T> middleware) {
    _middlewares.add(middleware);
  }

  // ----------------------- Emission APIs (Cubit-like) ------------

  /// Emits a new state synchronously, just like Cubit's `emit`.
  ///
  /// This will go through middlewares, call before/after callbacks,
  /// update history, notify listeners and selectors, and respect disposal.
  @nonVirtual
  void emit(T value) {
    state = value; // delegate to the protected setter
  }

  /// Tries to emit a new state. Returns `false` if this notifier is disposed.
  @nonVirtual
  bool tryEmit(T value) {
    if (_disposed) return false;
    state = value;
    return true;
  }

  /// Computes a new state based on the current one, then emits it.
  ///
  /// Useful to avoid reading and writing in two steps:
  ///   `update((prev) => prev.copyWith(...));`
  @nonVirtual
  void update(T Function(T previous) reducer) {
    final next = reducer(_state);
    state = next;
  }

  /// Emits `value` only if [test] returns true for `(previous, next)`.
  @nonVirtual
  void emitIf(bool Function(T previous, T next) test, T value) {
    if (test(_state, value)) state = value;
  }

  /// Emits `value` only if it differs from the current state.
  ///
  /// Provide a custom [equals] if you need structural equality
  /// different from `==`.
  @nonVirtual
  void emitWhenChanged(T value, {bool Function(T a, T b)? equals}) {
    final eq = equals ?? (T a, T b) => a == b;
    if (!eq(_state, value)) state = value;
  }

  // ----------------------- Core state update ---------------------

  /// Updates the state and notifies listeners **if** the value has changed.
  ///
  /// - Applies all registered [middlewares] **in order**.
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

    // Apply middlewares (respect typedef: (next, previous))
    T next = value;
    for (final mw in _middlewares) {
      next = mw(_state, next);
    }

    // Short-circuit if nothing changed
    if (next == _state) return;

    final event = StateChangeEvent(previous: _state, next: next);
    onBeforeChange?.call(event);

    _history.add(next);
    _state = next;

    // Notify listeners and selectors
    notifyListeners();
    _notifySelectors(_state);

    onAfterChange?.call(event);
  }

  // ----------------------- Selectors (granular) ------------------

  /// Creates a granular [ValueListenable] for a specific projection of the state.
  ///
  /// Example:
  /// ```dart
  /// final nameListenable = userNotifier.select((u) => u.name);
  ///
  /// ValueListenableBuilder(
  ///   valueListenable: nameListenable,
  ///   builder: (_, name, __) => Text(name),
  /// );
  /// ```
  ValueListenable<P> select<P>(P Function(T state) selector) {
    final subscription = _SelectorSubscription<T, P>(selector, _state);
    _selectors.add(subscription);
    return subscription;
  }

  void _notifySelectors(T newState) {
    for (final sub in _selectors) {
      sub.update(newState);
    }
  }

  // ----------------------- ChangeNotifier overrides --------------

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
///   builder: (_, age, __) => Text('$age years old'),
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
