import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  final _box = Hive.box('EXPENSETRACKER');
  List expense = [];
  //add to database
  void addExpense(String category, String date, String amount,
      String modeOfPayment, int id,String description) {
    _box.add({
      'id': id,
      'category': category,
      'date': date,
      'amount': amount,
      'modeOfPayment': modeOfPayment,
      'description':description
    });
  }

  //update database
  void updateExpense(int index, String category, String date, String amount,
      String modeOfPayment, int id,String description) {
    _box.putAt(index, {
      'id': id,
      'category': category,
      'date': date,
      'amount': amount,
      'modeOfPayment': modeOfPayment,
      'description':description,
    });
  }

  //delete from database based on id
  void deleteExpense(int id, var date) {
    for (int i = 0; i < _box.length; i++) {
      if (_box.getAt(i)['id'] == id && _box.getAt(i)['date'] == date) {
        _box.deleteAt(i);
      }
    }
  }

  //get all expenses
  List getExpense() {
    expense = [];
    for (int i = 0; i < _box.length; i++) {
      expense.add(_box.getAt(i));
    }
    return expense;
  }

  //clear database
  void clearExpense() {
    _box.clear();
  }

  int dayTotal(var date) {
    var total = 0;
    for (int i = 0; i < _box.length; i++) {
      if (expense[i]['date'] == date)
        total += int.parse(_box.getAt(i)['amount']);
    }
    print(total);
    return total;
  }
}
