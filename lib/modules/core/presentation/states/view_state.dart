import 'package:flutter/foundation.dart';

/// Represents the state of an asynchronous operation in a strongly typed way.
///
/// A [ViewState] can be in one of four states:
/// - [InitialState]  → The operation has not started yet.
/// - [LoadingState]  → The operation is in progress.
/// - [SuccessState]  → The operation completed successfully with data of type [S].
/// - [FailureState]  → The operation failed with an error of type [F].
///
/// This sealed hierarchy is useful for modeling UI state in a predictable and
/// exhaustive way, especially when combined with `switch` expressions or
/// extension methods like `when` and `map`.
@immutable
sealed class ViewState {
  const ViewState();
}

/// The operation has not started yet.
///
/// Example: a login form before the user submits credentials.
@immutable
final class InitialState extends ViewState {
  const InitialState();
}

/// The operation is currently in progress.
///
/// Example: showing a loading spinner while a network request is running.
@immutable
final class LoadingState extends ViewState {
  const LoadingState();
}

/// The operation completed successfully and produced a result of type [S].
///
/// Example: receiving a `User` object after a successful login.
@immutable
final class SuccessState<S> extends ViewState {
  final S success;
  const SuccessState(this.success);
}

/// The operation failed with an failure of type [F].
///
/// Example: a network failure, validation failure, or unexpected exception.
@immutable
final class FailureState<F> extends ViewState {
  final F failure;
  const FailureState(this.failure);
}
