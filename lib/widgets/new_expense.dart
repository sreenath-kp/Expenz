import 'dart:convert';
import 'package:expenz/database.dart';
import 'package:flutter/material.dart';
import 'package:expenz/model/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense, {super.key});
  final Function addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;

  void datePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() async {
    final enteredAmount = double.tryParse(_amount.text);
    final amountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_title.text.trim().isEmpty || amountInvalid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text('Invalid Input'),
          content: const Text('Please enter valid input'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }

    final response = await Database.send(
      {
        'title': _title.text,
        'amount': enteredAmount,
        'date': _selectedDate!,
        'category': _selectedCategory == null
            ? Category.Others.name
            : _selectedCategory!.name
      },
    );
    // new expense sent to database
    final Map<String, dynamic> responseData = json.decode(response.body);
    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    // new expense is added locally
    widget.addExpense(
      Expense(
        id: responseData['name'],
        title: _title.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category:
            _selectedCategory == null ? Category.Others : _selectedCategory!,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    final width = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: width < 600 ? 500 : double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0 + keyboardspace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (constraints.maxWidth >= 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _title,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                      ),
                      const SizedBox(width: 100),
                      Expanded(
                        child: TextField(
                          controller: _amount,
                          decoration: const InputDecoration(
                            prefixText: '₹',
                            labelText: 'Amount',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _title,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                if (constraints.maxWidth >= 600)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton(
                            hint: const Text('Select Category'),
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toString()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        const SizedBox(width: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null
                                ? 'Select Date'
                                : formatter.format(_selectedDate!)),
                            IconButton(
                              onPressed: datePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _amount,
                              decoration: const InputDecoration(
                                prefixText: '₹',
                                labelText: 'Amount',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_selectedDate == null
                                    ? 'Select Date'
                                    : formatter.format(_selectedDate!)),
                                IconButton(
                                  onPressed: datePicker,
                                  icon: const Icon(Icons.calendar_month),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      DropdownButton(
                          hint: const Text('Select Category'),
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                    ],
                  ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                          (states) => const Color(0xFF0E0D0D).withOpacity(0.2),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text('Add Expense'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
