import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello demo"),),
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: BottomClipper(),
            child: Container(
              color: Colors.deepPurpleAccent,
              height: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {


    // 一个控制点的贝塞尔曲线 
  
    // var path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height - 50);
    
    // var firstControlPoint = Offset(size.width / 2, size.height);
    // var firstEndPoint = Offset(size.width, size.height - 50);
    // path.quadraticBezierTo(firstControlPoint.dx,
    //                        firstControlPoint.dy,
    //                            firstEndPoint.dx, 
    //                           firstEndPoint.dy);

    // path.lineTo(size.width, size.height - 50);
    // path.lineTo(size.width, 0);

    // return path;     


    // 两个控制点的贝塞尔曲线
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx,
                           firstControlPoint.dy,
                               firstEndPoint.dx, 
                              firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 4 * 3, size.height - 90);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx,
                           secondControlPoint.dy,
                               secondEndPoint.dx, 
                              secondEndPoint.dy);                  
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}