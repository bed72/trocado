// ignore_for_file: invalid_use_of_protected_member, overridden_fields

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trocado/modules/core/presentation/notifiers/state_notifier.dart';

@immutable
final class _FakeUser {
  final int age;
  final String name;
  const _FakeUser(this.name, this.age);

  _FakeUser copyWith({String? name, int? age}) =>
      _FakeUser(name ?? this.name, age ?? this.age);

  @override
  String toString() => 'User(name: $name, age: $age)';

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FakeUser &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;
}

final class _FakeUserNotifier extends StateNotifier<_FakeUser> {
  @override
  final bool autoDispose;

  _FakeUserNotifier({required this.autoDispose})
    : super(const _FakeUser('Alice', 20), autoDispose: autoDispose);

  void changeAge(int age) => state = state.copyWith(age: age);
  void changeName(String name) => state = state.copyWith(name: name);
}

void main() {
  group('StateNotifier', () {
    test('should expose initial state', () {
      final notifier = _FakeUserNotifier(autoDispose: false);
      expect(notifier.history, isEmpty);
      expect(notifier.disposed, isFalse);
      expect(notifier.state, const _FakeUser('Alice', 20));
    });

    test('should update state and notify listeners', () {
      bool called = false;
      final notifier = _FakeUserNotifier(autoDispose: false);
      notifier.addListener(() => called = true);

      notifier.changeName('Bob');

      expect(called, isTrue);
      expect(notifier.state.name, 'Bob');
    });

    test('should not notify listeners if state remains the same', () {
      bool called = false;
      final notifier = _FakeUserNotifier(autoDispose: false);

      notifier.addListener(() => called = true);
      notifier.state = const _FakeUser('Alice', 20);

      expect(called, isFalse);
    });

    test('should call onBeforeChange and onAfterChange callbacks', () {
      final notifier = _FakeUserNotifier(autoDispose: false);
      StateChangeEvent<_FakeUser>? afterEvent;
      StateChangeEvent<_FakeUser>? beforeEvent;

      notifier.onBeforeChange = (event) => beforeEvent = event;
      notifier.onAfterChange = (event) => afterEvent = event;

      notifier.changeName('Charlie');

      expect(beforeEvent, isNotNull);
      expect(afterEvent, isNotNull);
      expect(beforeEvent!.previous, const _FakeUser('Alice', 20));
      expect(beforeEvent!.next, const _FakeUser('Charlie', 20));
      expect(afterEvent!.previous, const _FakeUser('Alice', 20));
      expect(afterEvent!.next, const _FakeUser('Charlie', 20));
    });

    test('should record history of state changes', () {
      final notifier = _FakeUserNotifier(autoDispose: false);

      notifier.changeName('Dave');
      notifier.changeAge(30);

      expect(notifier.history.length, 2);
      expect(notifier.history[0], const _FakeUser('Dave', 20));
      expect(notifier.history[1], const _FakeUser('Dave', 30));
    });

    test('should apply middleware to transform state', () {
      final notifier = _FakeUserNotifier(autoDispose: false);
      notifier.addMiddleware(
        (prev, next) =>
            next.name == 'Eve' ? next.copyWith(name: 'Intercepted') : next,
      );

      notifier.changeName('Eve');

      expect(notifier.state.name, 'Intercepted');
    });

    test('should block state change in middleware', () {
      final notifier = _FakeUserNotifier(autoDispose: false);
      notifier.addMiddleware((prev, next) => prev);

      notifier.changeName('Fail');

      expect(notifier.state.name, 'Alice');
      expect(notifier.history, isEmpty);
    });

    test('should autoDispose when no listeners remain', () {
      final autoDisposedNotifier = _FakeUserNotifier(autoDispose: true);

      void listener1() {}
      void listener2() {}

      autoDisposedNotifier.addListener(listener1);
      autoDisposedNotifier.addListener(listener2);

      autoDisposedNotifier.removeListener(listener1);
      autoDisposedNotifier.removeListener(listener2);

      expect(autoDisposedNotifier.disposed, isTrue);
    });

    test('should throw StateError if updating after dispose', () {
      final notifier = _FakeUserNotifier(autoDispose: false);
      notifier.dispose();

      expect(() => notifier.changeName('Fail'), throwsStateError);
    });

    test('should trigger onDispose callback when disposed', () {
      bool called = false;
      final notifier = _FakeUserNotifier(autoDispose: false);
      notifier.onDispose = () => called = true;

      notifier.dispose();

      expect(called, isTrue);
      expect(notifier.disposed, isTrue);
    });

    group('Selectors', () {
      test('should notify only when selected field changes', () {
        bool ageNotified = false;
        bool nameNotified = false;
        final notifier = _FakeUserNotifier(autoDispose: false);
        final ageSelector = notifier.select((u) => u.age);
        final nameSelector = notifier.select((u) => u.name);

        ageSelector.addListener(() => ageNotified = true);
        nameSelector.addListener(() => nameNotified = true);

        notifier.changeName('Bob');

        expect(nameNotified, isTrue);
        expect(ageNotified, isFalse);
      });

      test('should update selector value correctly', () {
        final notifier = _FakeUserNotifier(autoDispose: false);
        final ageSelector = notifier.select((u) => u.age);

        expect(ageSelector.value, 20);

        notifier.changeAge(40);

        expect(ageSelector.value, 40);
      });

      test('should dispose selectors when notifier is disposed', () {
        final notifier = _FakeUserNotifier(autoDispose: false);
        final nameSelector = notifier.select((u) => u.name);

        nameSelector.addListener(() {});

        notifier.dispose();

        expect(notifier.disposed, isTrue);
        expect(() => nameSelector.value, returnsNormally);
      });
    });
  });
}
