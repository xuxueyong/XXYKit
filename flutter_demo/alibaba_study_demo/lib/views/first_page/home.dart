import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("首页"),),
      body: Center(
        child: Text(
          "这是个首页",
          style: TextStyle(
            fontSize: 30,
          )
        ),
      ),
    );
  }
}