import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motherley/screens/bottom_navigation_bar.dart';

import '../calculation/date_calculation.dart';

class FirstDayOfLastMenstrualPeriodDate extends StatefulWidget {
  final String motherName;

  const FirstDayOfLastMenstrualPeriodDate(
      {required this.motherName, super.key});

  @override
  _FirstDayOfLastMenstrualPeriodDateState createState() =>
      _FirstDayOfLastMenstrualPeriodDateState();
}

class _FirstDayOfLastMenstrualPeriodDateState
    extends State<FirstDayOfLastMenstrualPeriodDate> {
  final TextEditingController dayTextEditingController =
      TextEditingController();
  final TextEditingController monthTextEditingController =
      TextEditingController();
  final TextEditingController yearTextEditingController =
      TextEditingController();

  void _onTapToHomeScreen() async {
    if (dayTextEditingController.text.isEmpty ||
        monthTextEditingController.text.isEmpty ||
        yearTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter all Fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int day = int.tryParse(dayTextEditingController.text) ?? 0;
    int month = int.tryParse(monthTextEditingController.text) ?? 0;
    int year = int.tryParse(yearTextEditingController.text) ?? 0;

    DateCalculator dateCalculator = DateCalculator();
    if (!dateCalculator.isValidDate(day, month, year)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid date!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    DateTime lmpDate = DateTime(year, month, day);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lmpDate', lmpDate.toIso8601String());

    DateTime dueDate = dateCalculator.calculateDueDate(lmpDate);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationBarScreen(
          dueDate: dueDate,
          motherName: widget.motherName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "LMP Date",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: dayTextEditingController,
                decoration: const InputDecoration(
                  labelText: "Day",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: monthTextEditingController,
                decoration: const InputDecoration(
                  labelText: "Month",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: yearTextEditingController,
                decoration: const InputDecoration(
                  labelText: "Year",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onTapToHomeScreen,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
