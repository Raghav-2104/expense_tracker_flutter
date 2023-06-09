import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  final _box = Hive.box('EXPENSETRACKER');
  List expense = [];

  List<Widget> icon = [
    const Icon(
      Icons.food_bank,
      color: Colors.black,
    ),
    Image.asset(
      'assets/grocery.png',
      scale: 20,
    ),
    const Icon(Icons.light, color: Colors.black),
    const Icon(Icons.train_outlined, color: Colors.black),
    const Icon(Icons.account_balance, color: Colors.black),
    const Icon(Icons.medication, color: Colors.black),
    const Icon(Icons.add_shopping_cart_rounded, color: Colors.black)
  ];
  //add to database
  void addExpense(String category, String date, String amount,
      String modeOfPayment, int id, String description, int categoryIcon) {
    _box.add({
      'id': id,
      'category': category,
      'date': date,
      'amount': amount,
      'modeOfPayment': modeOfPayment,
      'description': description,
      'categoryIcon': categoryIcon
    });
  }

  //update database
  void updateExpense(int index, String category, String date, String amount,
      String modeOfPayment, int id, String description, String categoryIcon) {
    _box.putAt(index, {
      'id': id,
      'category': category,
      'date': date,
      'amount': amount,
      'modeOfPayment': modeOfPayment,
      'description': description,
      'categoryIcon': categoryIcon
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

  //get total expense for a day

  double dayTotal(var date) {
    if (_box.isEmpty) {
      return 0.0;
    }
    double total = 0;
    for (int i = 0; i < _box.length; i++) {
      if (_box.getAt(i)['date'] == date) {
        total += int.parse(_box.getAt(i)['amount']);
      }
    }

    return total.toDouble();
  }
}
