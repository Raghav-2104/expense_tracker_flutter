import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  
  final _box=Hive.box('EXPENSETRACKER');
  List expense = [];
  //add to database
  void addExpense(String category, String date, String amount) {
    _box.add({
      'category': category,
      'date': date,
      'amount': amount,
    });
  }

  //update database
  void updateExpense(int index, String category, String date, String amount) {
    _box.putAt(index, {
      'category': category,
      'date': date,
      'amount': amount,
    });
  }

  //delete from database
  void deleteExpense(int index) {
    _box.deleteAt(index);
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
  void clearExpense(){
    _box.clear();
  }
}
