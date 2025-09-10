import 'package:uuid/uuid.dart';

import 'package:trocado/modules/home/domain/models/expense_model.dart';

import 'package:trocado/modules/core/presentation/viewmodels/livedata.dart';
import 'package:trocado/modules/core/presentation/viewmodels/viewmodel.dart';
import 'package:trocado/modules/core/presentation/viewmodels/eventqueue.dart';

final class ExpensesViewModel extends ViewModel {
  final MutableLiveData<List<ExpenseModel>> _expenses =
      MutableLiveData<List<ExpenseModel>>(<ExpenseModel>[]);

  LiveData<List<ExpenseModel>> get expenses => _expenses;

  final MutableEventQueue<ExpenseEvent> events = MutableEventQueue();

  void loadMock() {
    _expenses.value = [
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
  }

  void addExpense(String title, double amount) {
    if (amount <= 0) {
      events.push(ExpenseEvent.invalidExpense);
      return;
    }

    final entry = ExpenseModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    final current = List<ExpenseModel>.from(_expenses.value);
    current.add(entry);

    _expenses.value = current;
  }

  void removeExpense(String id) {
    final current = List<ExpenseModel>.from(_expenses.value);
    current.removeWhere((e) => e.id == id);
    _expenses.value = current;
  }

  void clearAll() {
    _expenses.value = <ExpenseModel>[];
    events.push(ExpenseEvent.cleared);
  }
}
