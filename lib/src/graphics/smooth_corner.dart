import 'package:flutter/material.dart';

class SmoothCorner {
	Path path;
	Offset targetPoint;
	Offset controlPoint;

	SmoothCorner({@required this.path, @required this.targetPoint, @required this.controlPoint});

	Path _getSmoothCurve(){
		path.quadraticBezierTo(
			controlPoint.dx, controlPoint.dy, 
			targetPoint.dx, targetPoint.dy
		);
		return path;
	}

	Path getCurve() => _getSmoothCurve();

	Path getTopRightSmoothCorner() => _getSmoothCurve();

	Path getTopLeftSmoothCorner() => _getSmoothCurve();

	Path getBottomLeftSmoothCorner() => _getSmoothCurve();

	Path getBottomRightSmoothCorner() => _getSmoothCurve();
}