import 'package:expenz/data/database.dart';
import 'package:flutter/material.dart';
import 'package:expenz/expenz.dart';
import 'model/expense.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: DatabaseSerive().expenses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expenses(expenseList: snapshot.data!);
        } else {
          return Container();
        }
      },
    );
  }
}
