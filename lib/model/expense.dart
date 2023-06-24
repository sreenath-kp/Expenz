import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMMMd();

// ignore: constant_identifier_names
enum Category { Food, Travel, Shopping, Bills, Leisure, Work, Others }

const categoryIcons = {
  Category.Food: Icons.lunch_dining_outlined,
  Category.Travel: Icons.flight_takeoff_outlined,
  Category.Shopping: Icons.shopping_bag_outlined,
  Category.Bills: Icons.receipt_outlined,
  Category.Leisure: Icons.local_movies_outlined,
  Category.Work: Icons.book_outlined,
  Category.Others: Icons.more_horiz_outlined,
};

class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  ExpenseBucket({
    required this.category,
    required this.expenses,
  });
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpense {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
