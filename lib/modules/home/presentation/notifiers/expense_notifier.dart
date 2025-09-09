import 'package:uuid/uuid.dart';

import 'package:trocado/modules/home/domain/models/expense_model.dart';

import 'package:trocado/modules/core/presentation/states/view_state.dart';
import 'package:trocado/modules/core/presentation/notifiers/state_notifier.dart';

final class ExpensesNotifier extends StateNotifier<ViewState> {
  ExpensesNotifier() : super(const InitialState()) {
    addMiddleware((previous, next) {
      if (next is SuccessState<List<ExpenseModel>>) {
        final hasInvalid = next.success.any((e) => e.amount <= 0);
        if (hasInvalid) {
          return const FailureState<String>(
            'Invalid expense detected (amount <= 0)',
          );
        }
      }
      return next;
    });
  }

  Future<void> loadExpenses() async {
    emit(const LoadingState());
    await Future.delayed(const Duration(seconds: 1));

    try {
      final mock = <ExpenseModel>[
        ExpenseModel(
          id: const Uuid().v4(),
          title: 'Coffee',
          amount: 15.0,
          date: DateTime.now(),
        ),
        ExpenseModel(
          id: const Uuid().v4(),
          title: 'Groceries',
          amount: 120.0,
          date: DateTime.now(),
        ),
      ];

      emit(SuccessState<List<ExpenseModel>>(mock));
    } catch (e) {
      emit(FailureState<String>(e.toString()));
    }
  }

  void addExpense(String title, double amount) {
    update((prev) {
      final entry = ExpenseModel(
        id: const Uuid().v4(),
        title: title,
        amount: amount,
        date: DateTime.now(),
      );

      return prev is SuccessState<List<ExpenseModel>>
          ? SuccessState<List<ExpenseModel>>([...prev.success, entry])
          : SuccessState<List<ExpenseModel>>([entry]);
    });
  }

  void removeExpense(String id) {
    emitIf(
      (prev, _) => prev is SuccessState<List<ExpenseModel>>,
      _deriveRemoved(id),
    );
  }

  void clearAll() {
    emitIf(
      (prev, _) => prev is SuccessState<List<ExpenseModel>>,
      const SuccessState<List<ExpenseModel>>(<ExpenseModel>[]),
    );
  }

  void fail(String message) => emit(FailureState<String>(message));

  ViewState _deriveRemoved(String id) {
    final prev = state;
    if (prev is! SuccessState<List<ExpenseModel>>) return prev;
    final nextList = prev.success
        .where((e) => e.id != id)
        .toList(growable: false);
    return SuccessState<List<ExpenseModel>>(nextList);
  }
}
