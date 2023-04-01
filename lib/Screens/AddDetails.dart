import 'package:expense_tracker/Database/Database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({super.key});

  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  //Database
  final _box = Hive.box('EXPENSETRACKER');
  Database db = Database();
  //Category List
  var category = ['Food', 'Groceries', 'Utilities', 'Others'];
  var categoryValue = 'Food';

  //Date
  DateTime date = DateTime.now();
  var year = DateTime.now().year;
  var month = DateTime.now().month;
  var day = DateTime.now().day;
  //amount
  var amount = '';

  @override
  Widget build(BuildContext context) {
    // db.clearExpense();
    var selectedDate = '$day-$month-$year';
    // print(date);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //Calendar

            CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
                onDateChanged: (value) {
                  setState(() {
                    year = value.year;
                    month = value.month;
                    day = value.day;
                    selectedDate = '$day-$month-$year';
                  });
                  print('After change $selectedDate');
                }),

            //DropDown for Expense Category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Category'),
                const SizedBox(
                  width: 25,
                ),
                DropdownButton(
                  value: categoryValue,
                  items: category.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryValue = value!;
                      // print(categoryValue);
                    });
                  },
                ),
              ],
            ),

            //Amount Textfield
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 25, bottom: 25),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Enter Amount',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
            ),

            //Add Buttom
            ElevatedButton(
                onPressed: () {
                  //Add to database
                  setState(() {
                    _box.add({
                    'category': categoryValue,
                    'date': selectedDate.toString(),
                    'amount': amount,
                  });
                  });
                  print(db.getExpense());
                  Navigator.pop(context);
                },
                child: Text('Add Expense')),
          ],
        ),
      ),
    );
  }
}
