import 'package:flutter/material.dart';
import 'smooth_corner.dart';

class RoundedCornersClipper extends CustomClipper<Path> {
  double ratio;
  bool? topLeft = true;
  bool? topRight = true;
  bool? bottomLeft = true;
  bool? bottomRight = true;

  RoundedCornersClipper(
      {this.ratio = 0.2,
      this.bottomLeft,
      this.bottomRight,
      this.topLeft,
      this.topRight});

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    Path path = Path();

    double secondRatio = 1 - ratio;

    // points
    // Offset firstPoint = Offset(0.0, height * 0.2);
    // Offset secondPoint = Offset(width * 0.2, 0.0);
    // Offset thirdPoint = Offset(width * 0.8, 0.0);
    // Offset fourthPoint = Offset(width, height * 0.2);
    // Offset fifthPoint = Offset(width, height * 0.8);
    // Offset sixthPoint = Offset(width * 0.8, height);
    // Offset seventhPoint = Offset(width * 0.2, height);
    // Offset eighthPoint = Offset(0.0, height * 0.8);

    Offset firstPoint = Offset(0.0, height * ratio);
    Offset secondPoint = Offset(width * ratio, 0.0);
    Offset thirdPoint = Offset(width * secondRatio, 0.0);
    Offset fourthPoint = Offset(width, height * ratio);
    Offset fifthPoint = Offset(width, height * secondRatio);
    Offset sixthPoint = Offset(width * secondRatio, height);
    Offset seventhPoint = Offset(width * ratio, height);
    Offset eighthPoint = Offset(0.0, height * secondRatio);

    // ctrl points
    Offset firstCtrlPoint = Offset(0.0, 0.0);
    Offset secondCtrlPoint = Offset(width, 0.0);
    Offset thirdCtrlPoint = Offset(width, height);
    Offset fourthCtrlPoint = Offset(0.0, height);

    path.moveTo(firstPoint.dx, firstPoint.dy);
    SmoothCorner(
            path: path, controlPoint: firstCtrlPoint, targetPoint: secondPoint)
        .getTopLeftSmoothCorner();

    path.lineTo(thirdPoint.dx, thirdPoint.dy);
    SmoothCorner(
      path: path,
      controlPoint: secondCtrlPoint,
      targetPoint: fourthPoint,
    ).getTopRightSmoothCorner();

    path.lineTo(fifthPoint.dx, fifthPoint.dy);
    SmoothCorner(
            path: path, controlPoint: thirdCtrlPoint, targetPoint: sixthPoint)
        .getBottomLeftSmoothCorner();

    path.lineTo(seventhPoint.dx, seventhPoint.dy);
    SmoothCorner(
            path: path, controlPoint: fourthCtrlPoint, targetPoint: eighthPoint)
        .getBottomRightSmoothCorner();

    path.close();
    return path;
  }

  @override
  bool shouldReclip(RoundedCornersClipper oldDelegate) => true;
}
