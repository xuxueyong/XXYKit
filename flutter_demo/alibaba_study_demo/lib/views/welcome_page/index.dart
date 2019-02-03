import 'package:flutter/material.dart';
import 'fourth_page.dart';

class WelcomePage extends StatefulWidget {
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
       child: FourthPage(),
    );
  }
}