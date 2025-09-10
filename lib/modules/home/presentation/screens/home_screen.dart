// import 'dart:math';

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:trocado/modules/home/domain/models/expense_model.dart';

import 'package:trocado/modules/core/presentation/viewmodels/livedata.dart';
import 'package:trocado/modules/core/presentation/viewmodels/eventqueue.dart';
import 'package:trocado/modules/home/presentation/viewmodels/expense_viewmodel.dart';

/*
import 'package:trocado/modules/core/presentation/states/view_state.dart';
import 'package:trocado/modules/home/presentation/notifiers/expense_notifier.dart';
import 'package:trocado/modules/core/presentation/builders/state_notifier_builder.dart';
import 'package:trocado/modules/core/presentation/extensions/view_state_extension.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('ROOT');
    return StateNotifierBuilder<ViewState, ExpensesNotifier>(
      create: () => ExpensesNotifier()..loadExpenses(),
      builder: (context, state, notifier) {
        return Scaffold(
          appBar: AppBar(title: const Text('Dashboard — Personal Finance')),

          body: Column(
            children: [
              state.maybeWhen<List<ExpenseModel>, String>(
                failure: (msg) => MaterialBanner(
                  content: Text('Error: $msg'),
                  actions: [
                    TextButton(
                      onPressed: notifier.loadExpenses,
                      child: const Text('Retry'),
                    ),
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(
                        context,
                      ).hideCurrentMaterialBanner(),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
                orElse: () => const SizedBox.shrink(),
              ),

              // --- KPIs (usando selectors para granularidade) ---
              Padding(
                padding: const EdgeInsets.all(16),
                child: _KpiRow(notifier: notifier),
              ),

              // --- Lista de despesas (apenas quando Success) ---
              Expanded(
                child: state.maybeWhen<List<ExpenseModel>, String>(
                  success: (expenses) => _ExpenseList(
                    expenses: expenses,
                    onRemove: notifier.removeExpense,
                  ),
                  orElse: () => state.when<List<ExpenseModel>, String>(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    initial: () => const Center(child: Text('No data yet')),
                    // se chegar aqui é Failure (banner já exibido), mostra fallback vazio
                    failure: (_) => const SizedBox.shrink(),
                    success: (_) => const SizedBox.shrink(), // nunca cai aqui
                  ),
                ),
              ),
            ],
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _FabActions(notifier: notifier),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// KPIs
// -----------------------------------------------------------------------------

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.notifier});

  final ExpensesNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _KpiCard<double>(
          title: 'Total',
          notifier: notifier,
          selector: (view) {
            if (view is SuccessState<List<ExpenseModel>>) {
              return view.success.fold<double>(0, (s, e) => s + e.amount);
            }
            return 0.0;
          },
          format: (v) => '\$${v.toStringAsFixed(2)}',
          icon: Icons.attach_money,
        ),
        _KpiCard<int>(
          title: 'Entries',
          notifier: notifier,
          selector: (view) => (view is SuccessState<List<ExpenseModel>>)
              ? view.success.length
              : 0,
          format: (v) => '$v',
          icon: Icons.list_alt,
        ),
        _KpiCard<double>(
          title: 'Avg Ticket',
          notifier: notifier,
          selector: (view) {
            if (view is SuccessState<List<ExpenseModel>>) {
              final list = view.success;
              if (list.isEmpty) return 0.0;
              final total = list.fold<double>(0, (s, e) => s + e.amount);
              return total / list.length;
            }
            return 0.0;
          },
          format: (v) => '\$${v.toStringAsFixed(2)}',
          icon: Icons.leaderboard,
        ),
        _KpiCard<double>(
          title: 'Biggest',
          notifier: notifier,
          selector: (view) {
            if (view is SuccessState<List<ExpenseModel>>) {
              final list = view.success;
              if (list.isEmpty) return 0.0;
              return list.map((e) => e.amount).reduce((a, b) => max(a, b));
            }
            return 0.0;
          },
          format: (v) => '\$${v.toStringAsFixed(2)}',
          icon: Icons.trending_up,
        ),
      ],
    );
  }
}

class _KpiCard<S> extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.selector,
    required this.notifier,
    required this.format,
    required this.icon,
  });

  final String title;
  final ExpensesNotifier notifier;
  final S Function(ViewState state) selector;
  final String Function(S value) format;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        elevation: 1.5,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Expanded(
                child:
                    StateNotifierSelectorBuilder<
                      ViewState,
                      ExpensesNotifier,
                      S
                    >(
                      notifier: notifier,
                      selector: selector,
                      builder: (_, selected) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            format(selected),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Lista
// -----------------------------------------------------------------------------

class _ExpenseList extends StatelessWidget {
  const _ExpenseList({required this.expenses, required this.onRemove});

  final List<ExpenseModel> expenses;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('No expenses yet'));
    }

    return ListView.separated(
      itemCount: expenses.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (_, i) {
        final e = expenses[i];
        return Dismissible(
          key: ValueKey(e.id),
          background: Container(
            color: Colors.red.withOpacity(0.1),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          secondaryBackground: Container(
            color: Colors.red.withOpacity(0.1),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          onDismissed: (_) => onRemove(e.id),
          child: ListTile(
            title: Text(e.title),
            subtitle: Text(
              e.date.toIso8601String(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              (e.amount >= 0 ? '+' : '') + e.amount.toStringAsFixed(2),
              style: TextStyle(
                color: e.amount >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// FABs (ações)
// -----------------------------------------------------------------------------

class _FabActions extends StatelessWidget {
  const _FabActions({required this.notifier});

  final ExpensesNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 12,
      children: [
        FloatingActionButton.extended(
          heroTag: 'addValid',
          onPressed: () {
            // valor válido aleatório para simular uso
            final value = (5 + Random().nextInt(95)) + Random().nextDouble();
            notifier.addExpense(
              'New expense',
              double.parse(value.toStringAsFixed(2)),
            );
          },
          label: const Text('Add'),
          icon: const Icon(Icons.add),
        ),
        FloatingActionButton.extended(
          heroTag: 'addInvalid',
          backgroundColor: Colors.red.shade700,
          onPressed: () {
            // força erro no middleware (amount <= 0)
            notifier.addExpense('Invalid', 0.0);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tried to add invalid expense (<= 0)'),
              ),
            );
          },
          label: const Text('Add invalid'),
          icon: const Icon(Icons.error_outline),
        ),
        FloatingActionButton.extended(
          heroTag: 'reload',
          backgroundColor: Colors.blueGrey,
          onPressed: notifier.loadExpenses,
          label: const Text('Reload'),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
*/

class HomeScreen extends StatelessWidget {
  final ExpensesViewModel viewModel = ExpensesViewModel();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log('ROOT');
    return SafeArea(
      child: EventListener<ExpenseEvent>(
        eventQueue: viewModel.events,
        onEvent: (context, event) async => switch (event) {
          ExpenseEvent.invalidExpense =>
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid expense (<= 0)')),
            ),
          ExpenseEvent.cleared => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('All expenses cleared'))),
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Expenses')),
          body: LiveDataBuilder<List<ExpenseModel>>(
            liveData: viewModel.expenses,
            builder: (_, expenses) => expenses.isEmpty
                ? const Center(child: Text('No expenses yet'))
                : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (_, index) {
                      final expense = expenses[index];
                      return ListTile(
                        title: Text(expense.title),
                        subtitle: Text(expense.date.toIso8601String()),
                        trailing: Text(
                          (expense.amount >= 0 ? '+' : '') +
                              expense.amount.toStringAsFixed(2),
                        ),
                        onLongPress: () => viewModel.removeExpense(expense.id),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => viewModel.addExpense('Coffee', 15),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
