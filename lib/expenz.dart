import 'package:expenz/model/expense.dart';
import 'package:expenz/widgets/expenses_list.dart';
import 'package:expenz/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenseList = [
    Expense(
      title: 'Breakfast',
      amount: 45,
      date: DateTime(2023, 5, 20),
      category: Category.Food,
    ),
    Expense(
      title: 'Flutter Course',
      amount: 500,
      date: DateTime.now(),
      category: Category.Work,
    ),
    Expense(
      title: 'Dress',
      amount: 1500,
      date: DateTime(2023, 5, 19),
      category: Category.Shopping,
    ),
    Expense(
      title: 'Cinema',
      amount: 250,
      date: DateTime(2023, 5, 17),
      category: Category.Leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(
        maxHeight: 500,
      ),
      builder: (context) => NewExpense(_addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenseList.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final index = _expenseList.indexOf(expense);
    setState(() {
      _expenseList.remove(expense);
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
              _expenseList.insert(index, expense);
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
    if (_expenseList.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _expenseList,
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
            const SizedBox(
              width: double.infinity,
              height: 100,
              child: Card(
                color: Color(0xFF303046),
              ),
            ),
            Expanded(
              child: mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
