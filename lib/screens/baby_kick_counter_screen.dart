import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BabyKickCounterScreen extends StatefulWidget {
  const BabyKickCounterScreen({super.key});

  @override
  _BabyKickCounterScreenState createState() => _BabyKickCounterScreenState();
}

class _BabyKickCounterScreenState extends State<BabyKickCounterScreen> {
  int _kickCount = 0;
  List<Map<String, dynamic>> _kickHistory = [];

  @override
  void initState() {
    super.initState();
    _loadKickData();
  }

  void _loadKickData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    String? kickHistoryString = prefs.getString('kickHistory');
    if (kickHistoryString != null) {
      _kickHistory = List<Map<String, dynamic>>.from(jsonDecode(kickHistoryString));
    }

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map<String, dynamic>? todayEntry = _kickHistory.firstWhere(
            (entry) => entry['date'] == today, orElse: () => <String, dynamic>{});

    if (todayEntry.isNotEmpty) {
      setState(() {
        _kickCount = todayEntry['kicks'];
      });
    }
  }

  void _saveKickData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    Map<String, dynamic>? todayEntry = _kickHistory.firstWhere(
            (entry) => entry['date'] == today, orElse: () => <String, dynamic>{});

    if (todayEntry.isNotEmpty) {
      todayEntry['kicks'] = _kickCount;
    } else {

      _kickHistory.add({'date': today, 'kicks': _kickCount});
    }


    await prefs.setString('kickHistory', jsonEncode(_kickHistory));
  }

  void _incrementKickCount() {
    setState(() {
      _kickCount++;
    });
    _saveKickData();
  }

  void _resetKickCount() {
    setState(() {
      _kickCount = 0;
    });
    _saveKickData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Kicks Today:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$_kickCount',
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _incrementKickCount,
                child: const Text(
                  'Log a Kick',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetKickCount,
                child: const Text(
                  'Reset Counter',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: _buildKickHistoryList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKickHistoryList() {
    return ListView.builder(
      itemCount: _kickHistory.length,
      itemBuilder: (context, index) {
        String date = _kickHistory[index]['date'];
        int kicks = _kickHistory[index]['kicks'];

        return Card(
          child: ListTile(
            title: Text(
              'Date: $date',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Kicks: $kicks'),
          ),
        );
      },
    );
  }
}
