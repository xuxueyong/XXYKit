import 'package:flutter/material.dart';
import 'views/welcome_page/index.dart';
import 'package:fluro/fluro.dart';
import 'routers/routers.dart';
import 'routers/application.dart';

void main() => runApp(MyApp());

const int themeColor = 0xFFC91B3A;

class MyApp extends StatelessWidget {

  MyApp() {
    final router = Router();
    Routers.configRouters(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Color(themeColor),
      ),
      home: Scaffold(
        body: WelcomePage(),
      ),
      onGenerateRoute: Application.router.generator,
    );
  }
}

