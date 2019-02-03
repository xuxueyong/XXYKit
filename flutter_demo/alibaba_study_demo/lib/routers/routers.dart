import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routers {

  static String home = "/home";

  static void configRouters(Router router) {
    router.define(home, handler: homeHandler);
  }
}