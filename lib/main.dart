import 'package:flutter/cupertino.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:motherley/app.dart';
import 'models/const.dart';


void main()
{
  Gemini.init(apiKey: GEMINI_API_KEY,);
  runApp(const Motherley());
}