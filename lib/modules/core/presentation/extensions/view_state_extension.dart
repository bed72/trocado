import 'package:flutter/material.dart';

import 'package:trocado/modules/core/presentation/states/view_state.dart';

extension ViewStateExtension on ViewState {
  /// Transforms the current [ViewState] into a value of type [R].
  ///
  /// - [initial] → executed when state is [InitialState].
  /// - [loading] → executed when state is [LoadingState].
  /// - [success] → executed when state is [SuccessState], passing the [S] value.
  /// - [failure] → executed when state is [FailureState], passing the [F] error.
  ///
  /// This method is useful for **non-UI logic**, for example:
  ///
  /// ```dart
  /// final ViewState<int, String> state = SuccessState(42);
  ///
  /// final message = state.map(
  ///   initial: () => "Idle",
  ///   loading: () => "Loading...",
  ///   success: (success) => "Got $success",
  ///   failure: (failure) => "Failure: $failure",
  /// );
  ///
  /// print(message); // Got 42
  /// ```
  R map<S, F, R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(F failure) failure,
    required R Function(S success) success,
  }) => switch (this) {
    InitialState() => initial(),
    LoadingState() => loading(),
    SuccessState(success: final success) => success(success as S),
    FailureState(failure: final failure) => failure(failure as F),
  };

  /// Builds a [Widget] depending on the current [ViewState],
  /// but allows handling only the cases you care about.
  ///
  /// - [initial] → optional builder for [InitialState].
  /// - [loading] → optional builder for [LoadingState].
  /// - [success] → optional builder for [SuccessState], passing the [S] success.
  /// - [failure] → optional builder for [FailureState], passing the [F] failure.
  /// - [orElse]  → fallback builder that is required and executed
  ///   if no specific case is handled.
  ///
  /// This method is useful when you don’t want to provide
  /// all cases explicitly, unlike [when].
  ///
  /// Example:
  ///
  /// ```dart
  /// state.maybeWhen<String, Exception>(
  ///   success: (success) => Text("Hello $success"),
  ///   orElse: () => const Text("Nothing yet"),
  /// );
  /// ```
  Widget maybeWhen<S, F>({
    required Widget Function() orElse,
    Widget Function()? initial,
    Widget Function()? loading,
    Widget Function(F failure)? failure,
    Widget Function(S success)? success,
  }) => switch (this) {
    InitialState() => initial?.call() ?? orElse(),
    LoadingState() => loading?.call() ?? orElse(),
    SuccessState(success: final success) =>
      success?.call(success as S) ?? orElse(),
    FailureState(failure: final failure) =>
      failure?.call(failure as F) ?? orElse(),
  };

  /// Builds a [Widget] depending on the current state.
  ///
  /// - [initial] → called if state is [InitialState].
  /// - [loading] → called if state is [LoadingState].
  /// - [success] → called if state is [SuccessState], passing [S] data.
  /// - [failure] → called if state is [FailureState], passing [F] error.
  ///
  /// If a callback is not provided for a given case,
  /// it will default to [SizedBox.shrink] for UI or a simple fallback.
  Widget when<S, F>({
    Widget Function()? initial,
    Widget Function()? loading,
    required Widget Function(F failure) failure,
    required Widget Function(S success) success,
  }) => switch (this) {
    InitialState() => initial?.call() ?? const SizedBox.shrink(),
    LoadingState() => loading?.call() ?? const CircularProgressIndicator(),
    SuccessState(success: final success) => success(success),
    FailureState(failure: final failure) => failure(failure),
  };
}
