import 'dart:convert';
import 'package:expenz/model/expense.dart';
import 'package:expenz/widgets/chart.dart';
import 'package:expenz/widgets/expenses_list.dart';
import 'package:expenz/widgets/new_expense.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  late List<Expense> _expenseList = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'expenz-f4a64-default-rtdb.firebaseio.com', 'expenz-list.json');
    final response = await http.get(url);
    final Map<String, dynamic>? listData = json.decode(response.body);

    final List<Expense> loadedItems = [];
    if (listData != null) {
      for (final item in listData.entries) {
        loadedItems.add(
          Expense(
            id: item.key,
            title: item.value['title'],
            amount: item.value['amount'],
            date: DateTime.parse(item.value['date']),
            category: Category.values.byName(
              item.value['category'],
            ),
          ),
        );
      }
    }
    setState(() {
      _expenseList = loadedItems;
    });
  }

  void _openAddExpenseOverlay() async {
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
    _loadItems();
  }

// TODO: Delete function need to be set
  void _removeExpense(Expense expense) {
    final index = _expenseList.indexOf(expense);
    // final url = Uri.https(
    //     'expenz-f4a64-default-rtdb.firebaseio.com', 'expenz-list.json');
    setState(() {
      _expenseList.remove(expense);
    });
    // http.delete(
    //   url,
    //   body: json.encode(
    //     {
    //       'title': expense.title,
    //       'amount': expense.amount,
    //       'date': expense.date.toUtc().toString(),
    //       'category': expense.category.name.toString(),
    //     },
    //   ),
    // );

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
    final width = MediaQuery.of(context).size.width;
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Expenz'),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _expenseList),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(children: [
              Expanded(
                child: Chart(expenses: _expenseList),
              ),
              Expanded(
                child: mainContent,
              ),
            ]),
    );
  }
}
