import 'dart:convert';
import 'package:expenz/model/expense.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Database {
  static Future<Response> send(Expense newExpense) async {
    final url = Uri.https(
        'expenz-f4a64-default-rtdb.firebaseio.com', 'expenz-list.json');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'title': newExpense.title,
          'amount': newExpense.amount,
          'date': newExpense.date.toUtc().toString(),
          'category': newExpense.category.name.toString(),
        },
      ),
    );
    return response;
  }
}
