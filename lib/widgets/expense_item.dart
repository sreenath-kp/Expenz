import 'package:expenz/model/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;

  @override
  State<ExpenseItem> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  bool showButtonBar = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              setState(() {
                showButtonBar = !showButtonBar;
              });
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: Icon(
                categoryIcons[widget.expense.category],
                color: const Color(0xFF0E0D0D),
              ),
            ),
            title: Text(
              widget.expense.title,
            ),
            subtitle: Row(
              children: [
                Text(
                  widget.expense.formattedDate,
                ),
                const Spacer(),
                Text(
                  '₹ ${widget.expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          showButtonBar
              ? ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Edit'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Delete'),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
