import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 3000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0)
    .animate(_controller);

    _animation.addStatusListener((status){
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MyHomePage()),
            (route) => route == null);
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Image.network("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548927905251&di=e7d6e427e5da900e4e4f347605c66fe3&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0106875816bdcfa84a0e282be73852.jpg%401280w_1l_2o_100sh.jpg",
      scale: 2.0,
      fit: BoxFit.cover,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page"),),
      body: Center(
        child: Text("home"),
      ),
    );
  }
}