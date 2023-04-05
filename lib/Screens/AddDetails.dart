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
  var category = [
    'Food',
    'Groceries',
    'Utilities',
    'Travel',
    'Loan Repayment',
    'Medicines',
    'Others'
  ];
  var categoryIndex = 0;
  var description = '';
  var categoryValue = 'Food';

  //Mode of Payment List
  var modeOfPayment = ['Cash', 'Card', 'UPI', 'Net Banking'];
  var modeOfPaymentValue = 'Cash';
  int count = 0;
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

    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: const Text('Add Expenses'),
        backgroundColor: Colors.deepPurple[400],
        shadowColor: Colors.deepPurple[300],
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
                  
                }),

            //DropDown for Expense Category
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
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
                          categoryIndex = category.indexOf(categoryValue);
                          // print(categoryValue);
                        });
                      },
                    ),
                  ],
                ),

                const VerticalDivider(),

                //DropDown for Mode of Payment
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mode of Payment',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    DropdownButton(
                      value: modeOfPaymentValue,
                      items: modeOfPayment.map((String modeOfPayment) {
                        return DropdownMenuItem(
                          value: modeOfPayment,
                          child: Text(modeOfPayment),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          modeOfPaymentValue = value!;
                        });
                      },
                    ),
                  ],
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

            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 0, bottom: 25),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  hintText: 'Description',
                ),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
            ),

            //Add Buttom
            ElevatedButton(
                onPressed: () {
                  //Add to database
                  setState(() {
                    if (description == '') {
                      description = 'No Description';
                    }
                    if (amount == '') {
                      amount = '0.0';
                    }
                    _box.add({
                      'id': count,
                      'category': categoryValue,
                      'date': selectedDate.toString(),
                      'amount': amount,
                      'modeOfPayment': modeOfPaymentValue,
                      'description': description,
                      'categoryIcon': categoryIndex,
                    });
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Expense Added'),
                            content: const Text('Expense Added Successfully'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                    count++;
                  });
                  // print(db.getExpense());
                  // Navigator.pop(context);
                },
                child: const Text('Add Expense'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple[400],
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
