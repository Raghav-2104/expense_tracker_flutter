import 'package:expense_tracker/Screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main()async {
  await Hive.initFlutter();
  var box = await Hive.openBox('EXPENSETRACKER');
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

