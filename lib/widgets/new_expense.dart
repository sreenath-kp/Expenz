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
      // builder: (context, child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: const ColorScheme.light(
      //         primary: Color(0xFF303046),
      //         onPrimary: Colors.white,
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
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
    final newExpense = Expense(
      title: _title.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category:
          _selectedCategory == null ? Category.Others : _selectedCategory!,
    );
    widget.addExpense(newExpense);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _title,
            // cursorColor: const Color(0xFF0E0D0D),
            maxLength: 50,
            decoration: const InputDecoration(
              labelText: 'Title',
              // labelStyle: TextStyle(
              //   color: Color(0xFF0E0D0D),
              // ),
              // focusedBorder: UnderlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Color(0xFF0E0D0D),
              //   ),
              // ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amount,
                  // cursorColor: const Color(0xFF0E0D0D),
                  decoration: const InputDecoration(
                    prefixText: '₹',
                    labelText: 'Amount',
                    // labelStyle: TextStyle(
                    //   color: Color(0xFF0E0D0D),
                    // ),
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Color(0xFF0E0D0D),
                    //   ),
                    // ),
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
              )
            ],
          ),
          const SizedBox(height: 10),
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
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: ButtonStyle(
                  // foregroundColor: MaterialStateProperty.all(Colors.black54),
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
                // style: ButtonStyle(
                //   backgroundColor:
                //       MaterialStateProperty.all(const Color(0xFF0E0D0D)),
                // ),
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
