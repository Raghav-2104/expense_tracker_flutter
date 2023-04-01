import 'package:expense_tracker/Database/Database.dart';
import 'package:expense_tracker/Screens/AddDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _box = Hive.box('EXPENSETRACKER');
  Database db = Database();

  var selectedDate = DateTime.now().toString();
  var year = '';
  var month = '';
  var day = '';

  @override
  Widget build(BuildContext context) {
    List<dynamic> expenses = _box.values
        .toList()
        .where((expense) => expense['date'] == selectedDate)
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[200],
        foregroundColor: Colors.red[900],
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () {
                //Navigate to AddDetail screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddDetails()));
              },
              icon: const Icon(Icons.add))
        ],
      ),

      //display all expenses from database
      body: Container(
        child: Column(
          children: [
            CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
                onDateChanged: (value) {
                  setState(() {
                    year = value.year.toString();
                    month = value.month.toString();
                    day = value.day.toString();
                    selectedDate = '$day-$month-$year';
                  });
                  print(selectedDate);
                }),
            Expanded(
              // ignore: deprecated_member_use
              child: WatchBoxBuilder(
                box: _box,
                builder: (context, box) {
                  List<dynamic> expenses = box.values
                      .toList()
                      .where((expense) => expense['date'] == selectedDate)
                      .toList();
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      print(_box.length);
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    db.deleteExpense(index);
                                    print(_box.length);
                                  });
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(expenses[index]['category']),
                            subtitle: Text(expenses[index]['date']),
                            trailing: Text(expenses[index]['amount']),
                          ),
                        ),
                      );
                    },
                    itemCount: expenses.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
