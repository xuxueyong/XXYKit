import 'dart:math';
import 'package:flutter/material.dart';

class PageReveal extends StatelessWidget {

  final double revealPercent;
  final Widget child;

  PageReveal({
    this.revealPercent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      clipper: CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {

  final double revealPercent;

  CircleRevealClipper(
    this.revealPercent,
  );

  @override
  Rect getClip(Size size) {
    final epiCenter = Offset(size.width / 2.0, size.height * 0.9);
    final theta = atan(epiCenter.dy / epiCenter.dx);
    final distanceToCorner = epiCenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;
    final diameter = 2 * radius;
    return Rect.fromLTWH(epiCenter.dx - radius, epiCenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}