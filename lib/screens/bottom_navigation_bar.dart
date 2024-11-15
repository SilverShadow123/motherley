import 'package:flutter/material.dart';
import 'package:motherley/screens/ai_chatbot.dart';
import 'package:motherley/screens/baby_kick_counter_screen.dart';
import 'package:motherley/screens/discover_screen.dart';
import 'package:motherley/screens/help_line.dart';
import 'package:motherley/screens/home_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final DateTime? dueDate;
  final String motherName;

  const BottomNavigationBarScreen(
      {Key? key, this.dueDate, required this.motherName})
      : super(key: key);

  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(
        dueDate: widget.dueDate,
        motherName: widget.motherName,
      ),
      Discover(),
      const BabyKickCounterScreen(),
      const AIChatBot(),
      const HelplineScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pregnant_woman),
            label: 'Baby Kick Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_outlined),
            label: 'AI Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.personal_injury_outlined),
            label: 'AI Chatbot',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        showSelectedLabels: false,
        unselectedItemColor: Colors.pinkAccent,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        }, // Handle item tap
      ),
    );
  }
}
