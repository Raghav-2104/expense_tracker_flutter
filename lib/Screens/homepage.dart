import 'package:expense_tracker/Database/Database.dart';
import 'package:expense_tracker/Screens/AddDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    // db.clearExpense();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        shadowColor: Colors.deepPurple[300],
        backgroundColor: Colors.deepPurple[400],
        actions: [
          IconButton(
              onPressed: () {
                //Navigate to AddDetail screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddDetails()));
              },
              icon: const Icon(Icons.add))
        ],
      ),

      //display all expenses from database
      body: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
        ),
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
                }),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _box.listenable(),
                builder: (context, index, _) {
                  return ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Center(
                          child: Text(
                        'Day Total = ₹ ${db.dayTotal(selectedDate)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ));
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 15,
              // ignore: deprecated_member_use
              child: WatchBoxBuilder(
                box: _box,
                builder: (context, box) {
                  List<dynamic> expenses = box.values
                      .toList()
                      .where((expense) => expense['date'] == selectedDate)
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          // Text('Day total: ${db.dayTotal(selectedDate)}'),
                          Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      db.deleteExpense(
                                          expenses[index]['id'], selectedDate);
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 5, 25, 10),
                              child: Card(
                                color: Colors.yellow[100],
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      db.icon[expenses[index]['categoryIcon']],
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(expenses[index]['category'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        '${expenses[index]['modeOfPayment']}   ${expenses[index]['description']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red[400],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(
                                    '₹ ${expenses[index]['amount']}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
