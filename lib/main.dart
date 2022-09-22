import 'package:flutter/material.dart';
import 'package:image_scanner/HomeScreen.dart';
import 'package:image_scanner/Intro_Screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_scanner/LogInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final isIn = prefs.getBool('isIn') ?? false;
  await Firebase.initializeApp();
  runApp(MyApp(isLoggedIn: isLoggedIn,isIn: isIn));

}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isIn;
  const MyApp({super.key,required this.isLoggedIn,required this.isIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.pink[100]
      ),
      home: isLoggedIn ? HomeScreen() : (isIn ? Login_Screen() : onboarding_screen())
    );
  }
}

