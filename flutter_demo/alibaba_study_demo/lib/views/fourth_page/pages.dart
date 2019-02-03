import 'package:flutter/material.dart';

final pages = [
new PageViewModel(
      const Color(0xFFcd344f),
      //'assets/mountain.png',
      'assets/images/p2.png',
      'FlutterGo是什么？',
      '【FlutterGo】 是由"阿里拍卖"前端团队几位 Flutter 粉丝，用业余时间开发的一款，用于 Flutter 教学帮助的App，这里没有高大尚的概念，只有一个一个亲历的尝试，用最直观的方式展示的 Flutter 官方demo',
      'assets/images/plane.png'),
  new PageViewModel(
      const Color(0xFF638de3),
      //'assets/world.png',
      'assets/images/p1.png',
      'FLutterGo的背景',
      '🐢 官网文档示例较不够健全，不够直观\n🐞 运行widget demo要到处翻阅资料\n🐌 英文文档翻译生涩难懂，学习资料太少\n🚀 需要的效果不知道用哪个widget\n',
      'assets/images/calendar.png'),
  new PageViewModel(
    const Color(0xFFFF682D),
    //'assets/home.png',
    'assets/images/p3.png',
    'FlutterGo的特点',
    '🐡 详解常用widget多达 140+ 个\n🦋 持续迭代追新官方版本\n🐙 配套Demo详解widget用法\n🚀 一站式搞定所有常用widget,开箱即查\n',
    'assets/images/house.png',
  ),
];


class Page extends StatelessWidget {
   final PageViewModel viewModel;
   final double percentVisible;

  Page({
    this.viewModel,
    this.percentVisible = 1.0,
  });

  Widget createButton(BuildContext context, String txt, IconData iconName, String type) {
    return RaisedButton.icon(
      onPressed: (){
        if (type == "startHome") {
          _goHomePage(context);
        } else if (type == "github") {
            // Application.ce
        }
      },
      elevation: 10.0,
      color: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Icon(iconName, color: Colors.white, size: 20.0,),
      label: Text(
        txt,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _goHomePage(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: viewModel.color,
      padding: const EdgeInsets.all(0.0),
      child: Opacity(
        opacity: percentVisible,
        child: ListView(
          children: <Widget>[
            layout(context),
          ],
        ),
      ),
    );
  }

  Column layout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0, 30.0 * (1.0 - percentVisible), 0.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Image.asset(viewModel.heroAssetPath,
            width: 160.0, height: 160.0,),
          ),
        ),

        Transform(
          transform: Matrix4.translationValues(0, 30.0 * (1.0 - percentVisible), 0.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              viewModel.title,
              style: TextStyle(
                fontSize: 28.0,
                color: Colors.white,
                fontFamily: 'FlamanteRoma',
              )
            ),
          ),
        ),

        Transform(
          transform: Matrix4.translationValues(0, 30.0 * (1.0 - percentVisible), 0.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              viewModel.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.2,
                fontSize: 18.0,
                color: Colors.white,
                fontFamily: 'FlamanteRomaItalic',
              )
            ),
          ),
        ),

        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            createButton(context, "开始使用", Icons.add_circle_outline, "startHome"),
            createButton(context, "GitHiub", Icons.arrow_forward, "github"),
          ],
        ),
      ],
    );
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPaht;

  PageViewModel(
    this.color,
    this.heroAssetPath,
    this.title,
    this.body,
    this.iconAssetPaht,
  );
}
