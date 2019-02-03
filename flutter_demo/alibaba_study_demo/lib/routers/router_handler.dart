import "package:fluro/fluro.dart";
import 'package:flutter/material.dart';
import '../views/first_page/home.dart';

var homeHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> parameters){
    return AppPage();
  }
);