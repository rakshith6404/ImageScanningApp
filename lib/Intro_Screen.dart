import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_scanner/LogInScreen.dart';
import 'package:introduction_screen/introduction_screen.dart';

class onboarding_screen extends StatelessWidget {
  onboarding_screen({Key? key}) : super(key: key);

  final List<PageViewModel> pages = [
    PageViewModel(
        title: "Welcome to Image Scanner",
        body:
        "Here you can scan Phone Numbers , Email IDs and WebLinks by and also can edit or save the informations needed.",
        image: Center(
          child: Image.asset('assets/First_page.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ))),
    PageViewModel(
        title: "SCAN WEBSITES",
        body: "Letting you to scan any WEBSITE LINKS from the IMAGE.",
        image: Center(
          child: Image.asset('assets/online-url-scanner.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ))),
    PageViewModel(
        title: "SCAN EMAIL IDs",
        body: "Scanning EMAIL IDs and saving it to your phone with an ease.",
        image: Center(
          child: Image.asset('assets/Mail_scanner.png'),
        ),
        decoration: const PageDecoration(
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IntroductionScreen(
          pages: pages,
          dotsDecorator: const DotsDecorator(
            size: Size(5, 5),
            color: Colors.grey,
            activeSize: Size.square(15),
            activeColor: Colors.black,
          ),
          showDoneButton: true,
          done: const Text(
            'Log In',
            style: TextStyle(fontSize: 20),
          ),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(fontSize: 20),
          ),
          showNextButton: false,
          onDone: () => onDone(context),
        ));
  }

  void onDone(context) async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login_Screen()));
  }
}
