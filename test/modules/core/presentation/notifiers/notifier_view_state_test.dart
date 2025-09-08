// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter_test/flutter_test.dart';

import 'package:trocado/modules/core/presentation/states/view_state.dart';
import 'package:trocado/modules/core/presentation/notifiers/state_notifier.dart';

final class _FakeLoginNotifier extends StateNotifier<ViewState> {
  _FakeLoginNotifier() : super(const InitialState());

  Future<void> login({bool shouldFail = false}) async {
    state = const LoadingState();

    await Future.delayed(const Duration(milliseconds: 10));

    state = shouldFail
        ? const FailureState<String>('Invalid credentials')
        : const SuccessState<String>('token_123');
  }
}

void main() {
  group('LoginNotifier with ViewState', () {
    test('initial state should be InitialState', () {
      final notifier = _FakeLoginNotifier();
      expect(notifier.history, isEmpty);
      expect(notifier.state, isA<InitialState>());
    });

    test(
      'should emit LoadingState then SuccessState on successful login',
      () async {
        final states = <ViewState>[];
        final notifier = _FakeLoginNotifier();

        notifier.addListener(() => states.add(notifier.state));

        await notifier.login();

        expect(states[0], isA<LoadingState>());
        expect(states[1], isA<SuccessState<String>>());

        final success = states[1] as SuccessState<String>;
        expect(success.success, 'token_123');
      },
    );

    test(
      'should emit LoadingState then FailureState on failed login',
      () async {
        final states = <ViewState>[];
        final notifier = _FakeLoginNotifier();

        notifier.addListener(() => states.add(notifier.state));

        await notifier.login(shouldFail: true);

        expect(states[0], isA<LoadingState>());
        expect(states[1], isA<FailureState<String>>());

        final failure = states[1] as FailureState<String>;
        expect(failure.failure, 'Invalid credentials');
      },
    );

    test('should trigger onBeforeChange and onAfterChange callbacks', () async {
      final notifier = _FakeLoginNotifier();
      final afterEvents = <StateChangeEvent<ViewState>>[];
      final beforeEvents = <StateChangeEvent<ViewState>>[];

      notifier.onAfterChange = (event) => afterEvents.add(event);
      notifier.onBeforeChange = (event) => beforeEvents.add(event);

      await notifier.login();

      expect(afterEvents.length, 2);
      expect(beforeEvents.length, 2);

      expect(beforeEvents[0].previous, isA<InitialState>());
      expect(beforeEvents[0].next, isA<LoadingState>());

      expect(beforeEvents[1].previous, isA<LoadingState>());
      expect(beforeEvents[1].next, isA<SuccessState<String>>());

      expect(afterEvents[0].previous, isA<InitialState>());
      expect(afterEvents[0].next, isA<LoadingState>());

      expect(afterEvents[1].previous, isA<LoadingState>());
      expect(afterEvents[1].next, isA<SuccessState<String>>());
    });

    test('should record history of emitted states', () async {
      final notifier = _FakeLoginNotifier();

      await notifier.login();

      expect(notifier.history.length, 2);
      expect(notifier.history[0], isA<LoadingState>());
      expect(notifier.history[1], isA<SuccessState<String>>());
    });

    test('should apply middleware to transform state', () async {
      final notifier = _FakeLoginNotifier();

      notifier.addMiddleware(
        (prev, next) => next is SuccessState<String>
            ? const SuccessState<String>('patched_token')
            : next,
      );

      await notifier.login();

      final state = notifier.state as SuccessState<String>;
      expect(state.success, 'patched_token');
    });

    test('should not allow state changes after dispose', () {
      final notifier = _FakeLoginNotifier();
      notifier.dispose();

      expect(() => notifier.state = const LoadingState(), throwsStateError);
    });
  });
}
