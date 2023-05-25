import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenz/model/expense.dart';

class DatabaseSerive {
  final CollectionReference _expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  Future addExpense(Expense expense) async {
    return await _expenseCollection.doc().set({
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date,
      'category': expense.category.toString(),
    });
  }

  Future removeExpense(String id) async {
    return await _expenseCollection.doc(id).delete();
  }

  List<Expense> _expenseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Expense(
        title: doc['title'],
        amount: doc['amount'],
        date: doc['date'].toDate(),
        category: Category.values
            .firstWhere((e) => e.toString() == 'Category.${doc['category']}'),
      );
    }).toList();
  }

  Stream<List<Expense>> get expenses {
    return _expenseCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(_expenseListFromSnapshot);
  }
}
