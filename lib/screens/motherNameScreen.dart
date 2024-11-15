import 'package:flutter/material.dart';
import 'package:motherley/widgets/screen_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FirstDayOfLastMensturalPeriodDateScreen.dart';


class Mothernamescreen extends StatefulWidget {
  const Mothernamescreen({super.key});

  @override
  _MothernamescreenState createState() => _MothernamescreenState();
}

class _MothernamescreenState extends State<Mothernamescreen> {
  final TextEditingController nameTextEditingController = TextEditingController();

  void _onTapToFirstDayOfLastMenstrualPeriodDateScreen() async {
    if (nameTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter Mother\'s Name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('motherName', nameTextEditingController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstDayOfLastMenstrualPeriodDate(
          motherName: nameTextEditingController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 100),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mother Name",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 24,),
                  TextField(
                    controller: nameTextEditingController,
                    decoration: const InputDecoration(labelText: "Enter Mother's Name",border: OutlineInputBorder()),
          
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onTapToFirstDayOfLastMenstrualPeriodDateScreen,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
