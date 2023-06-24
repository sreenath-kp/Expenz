import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Database {
  static Future<Response> send(Map<String, dynamic> data) async {
    final url = Uri.https(
        'expenz-f4a64-default-rtdb.firebaseio.com', 'expenz-list.json');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'title': data['title'],
          'amount': data['amount'],
          'date': data['date'].toUtc().toString(),
          'category': data['category'].toString(),
        },
      ),
    );
    return response;
  }
}
