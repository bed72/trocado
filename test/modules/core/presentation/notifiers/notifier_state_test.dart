import 'package:flutter_test/flutter_test.dart';

import 'package:trocado/modules/core/presentation/notifiers/state_notifier.dart';

final class _FakeCounterNotifier extends StateNotifier<int> {
  _FakeCounterNotifier({super.autoDispose}) : super(0);

  void increment() => state = state + 1;
  void setValue(int value) => state = value;
}

void main() {
  group('StateNotifier', () {
    test('should expose the initial state when created', () {
      final notifier = _FakeCounterNotifier();
      expect(notifier.state, 0);
      expect(notifier.history, isEmpty);
    });

    test('should update the state and notify listeners when state changes', () {
      bool called = false;
      final notifier = _FakeCounterNotifier();

      notifier.addListener(() => called = true);
      notifier.increment();

      expect(called, isTrue);
      expect(notifier.state, 1);
    });

    test('should not notify listeners if the state remains the same', () {
      int callCount = 0;
      final notifier = _FakeCounterNotifier();

      notifier.addListener(() => callCount++);
      notifier.setValue(0);

      expect(callCount, 0);
      expect(notifier.state, 0);
    });

    test('should apply middlewares in the order they were added', () {
      final notifier = _FakeCounterNotifier();

      notifier.addMiddleware((prev, next) => next + 1);
      notifier.addMiddleware((prev, next) => next * 2);

      notifier.increment();

      expect(notifier.state, 4);
    });

    test(
      'should block a state change if middleware returns the previous state',
      () {
        final notifier = _FakeCounterNotifier();

        notifier.addMiddleware((prev, next) => prev);
        notifier.increment();

        expect(notifier.state, 0);
        expect(notifier.history, isEmpty);
      },
    );

    test('should transform the next state using middleware', () {
      final notifier = _FakeCounterNotifier();

      notifier.addMiddleware((prev, next) => next + 5);
      notifier.increment();

      expect(notifier.state, 6);
    });

    test('should call onBeforeChange before updating the state', () {
      final notifier = _FakeCounterNotifier();
      StateChangeEvent<int>? received;

      notifier.onBeforeChange = (event) => received = event;
      notifier.increment();

      expect(received, isNotNull);
      expect(received!.previous, 0);
      expect(received!.next, 1);
    });

    test('should call onAfterChange after updating the state', () {
      final notifier = _FakeCounterNotifier();
      StateChangeEvent<int>? received;

      notifier.onAfterChange = (event) => received = event;
      notifier.increment();

      expect(received, isNotNull);
      expect(received!.previous, 0);
      expect(received!.next, 1);
    });

    test('should add every new state to the history', () {
      final notifier = _FakeCounterNotifier();

      notifier.increment();
      notifier.increment();

      expect(notifier.history, [1, 2]);
    });

    test('should keep history immutable when accessed externally', () {
      final notifier = _FakeCounterNotifier();

      expect(notifier.history, isA<List<int>>());
    });

    test(
      'should dispose automatically when no listeners remain if autoDispose is true',
      () {
        final notifier = _FakeCounterNotifier(autoDispose: true);
        expect(notifier.disposed, isFalse);

        void listener() {}
        notifier.addListener(listener);
        notifier.removeListener(listener);

        expect(notifier.disposed, isTrue);
      },
    );

    test('should not dispose automatically when autoDispose is false', () {
      final notifier = _FakeCounterNotifier(autoDispose: false);
      expect(notifier.disposed, isFalse);

      void listener() {}
      notifier.addListener(listener);
      notifier.removeListener(listener);

      expect(notifier.disposed, isFalse);
    });

    test('should mark notifier as disposed after dispose is called', () {
      final notifier = _FakeCounterNotifier();
      notifier.dispose();
      expect(notifier.disposed, isTrue);
    });

    test('should call onDispose callback when disposed', () {
      bool called = false;
      final notifier = _FakeCounterNotifier();

      notifier.onDispose = () => called = true;
      notifier.dispose();

      expect(called, isTrue);
    });

    test(
      'should throw StateError if trying to change state after disposal',
      () {
        final notifier = _FakeCounterNotifier();
        notifier.dispose();

        expect(() => notifier.increment(), throwsStateError);
      },
    );

    test('should not call dispose twice if already disposed', () {
      int called = 0;
      final notifier = _FakeCounterNotifier();

      notifier.onDispose = () => called++;
      notifier.dispose();
      notifier.dispose();

      expect(called, 1);
      expect(notifier.disposed, isTrue);
    });
  });
}
