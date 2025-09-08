import 'package:flutter/foundation.dart';

/// A middleware that can intercept and transform state changes
/// before they are applied.
///
/// It receives the previous state and the next state, and must
/// return the final state that will be set.
typedef StateMiddleware<T> = T Function(T next, T previous);

/// Immutable event object representing a transition between two states.
///
/// Useful for logging, analytics, or reacting to specific changes.
class StateChangeEvent<T> {
  /// The state after the change.
  final T next;

  /// The state before the change.
  final T previous;

  const StateChangeEvent({required this.next, required this.previous});
}

/// A reactive state holder similar to [ChangeNotifier] but with additional
/// capabilities:
///
/// - Strongly typed immutable state.
/// - Automatic updates when setting [state].
/// - Middlewares to intercept, block or transform state changes.
/// - Before/after change callbacks for side effects (e.g. logging).
/// - State history for debugging or time travel.
/// - Optional auto-dispose when no listeners remain.
/// - `onDispose` callback and [disposed] flag.
///
/// This class is designed to provide predictable and testable state
/// management without external dependencies.
abstract class StateNotifier<T> extends ChangeNotifier {
  /// Creates a new [StateNotifier] with an initial [state].
  ///
  /// If [autoDispose] is true, the notifier will automatically
  /// call [dispose] once the last listener is removed.
  StateNotifier(this._state, {this.autoDispose = false});

  T _state;
  final bool autoDispose;
  final List<T> _history = [];
  final List<StateMiddleware<T>> _middlewares = [];

  /// Callback invoked right before the state is updated.
  void Function(StateChangeEvent<T> event)? onBeforeChange;

  /// Callback invoked right after the state has been updated.
  void Function(StateChangeEvent<T> event)? onAfterChange;

  /// Callback invoked when [dispose] is called.
  VoidCallback? onDispose;

  /// Whether this notifier has already been disposed.
  bool _disposed = false;
  bool get disposed => _disposed;

  /// Current state value (read-only).
  T get state => _state;

  /// Immutable history of all previously applied states.
  List<T> get history => List.unmodifiable(_history);

  /// Registers a [middleware] that will be executed for every state change.
  ///
  /// Middlewares run in order and can:
  /// - Transform the next state.
  /// - Block a transition by returning the previous state.
  void addMiddleware(StateMiddleware<T> middleware) {
    _middlewares.add(middleware);
  }

  /// Updates the state and notifies listeners if the value has changed.
  ///
  /// Runs all middlewares and invokes [onBeforeChange] and [onAfterChange].
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

    onAfterChange?.call(event);
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

    onDispose?.call();
    super.dispose();
  }
}
