import 'package:expenz/model/expense.dart';
import 'package:expenz/widgets/chart.dart';
import 'package:expenz/widgets/expenses_list.dart';
import 'package:expenz/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expenz/data/database.dart';

class Expenses extends StatefulWidget {
  const Expenses({required this.expenseList, super.key});
  final List<Expense> expenseList;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final database = DatabaseSerive();
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(
        maxHeight: 500,
      ),
      builder: (context) => NewExpense(_addExpense),
    );
  }

  void _addExpense(Expense expense) async {
    setState(() {
      // widget.expenseList.add(expense);
      database.addExpense(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final index = widget.expenseList.indexOf(expense);
    setState(() {
      // widget.expenseList.remove(expense);
      database.removeExpense(expense.id);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text('${expense.title} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.expenseList.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses added yet!'),
    );
    if (widget.expenseList.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: widget.expenseList,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF303046),
        title: const Text('Expenz'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Chart(expenses: widget.expenseList),
            Expanded(
              child: mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
