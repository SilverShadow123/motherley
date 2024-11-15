import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motherley/screens/motherNameScreen.dart';
import 'package:motherley/screens/bottom_navigation_bar.dart';
import 'package:motherley/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleSplashScreenNavigation();
  }

  Future<void> _handleSplashScreenNavigation() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? motherName = prefs.getString('motherName');
    String? lmpDate = prefs.getString('lmpDate');

    if (motherName != null && lmpDate != null) {
      DateTime? dueDate = DateTime.tryParse(lmpDate);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationBarScreen(
            dueDate: dueDate,
            motherName: motherName,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Mothernamescreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.color,
      body: _screenUtils(),
    );
  }

  Widget _screenUtils() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/one_mother_and_her_one_newborn-removebg-preview.png',
            scale: 2,
          ),
        ),
        const Text(
          'Motherley',
          style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontSize: 35,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 5.0,
                  color: Colors.grey,
                ),
              ]),
        ),
      ],
    );
  }
}
