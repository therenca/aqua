import 'dart:math' as math;
import 'package:flutter/material.dart';

const double degrees2Radians = math.pi / 180.0;

class ClippedCircle extends StatelessWidget {

	final Widget child;
	final Color color;
	final double ratio;
	final Color ratioColor;
	final double strokeWidth;

	ClippedCircle({
		@required this.child,
		this.color=Colors.white,
		this.strokeWidth=2.0,
		this.ratio,
		this.ratioColor
	});

	Widget _buildClippedWidget() => ClipPath(
		clipper: ColoredBorderClipper(),
		child: child,
	);

	Widget _addPathColorToClippedWidget(child) => CustomPaint(
		painter: _ClipperBorderPainter(
			color: color,
			ratio: ratio,
			ratioColor: ratioColor,
			strokeWidth: strokeWidth,
			clipper: ColoredBorderClipper()
		),
		child: child,
	);

	Widget _buildClippedCircle(BuildContext context){
		Widget widget = _buildClippedWidget();
		return _addPathColorToClippedWidget(widget);
	}

	@override
	Widget build(BuildContext context) => _buildClippedCircle(context);

}

class ColoredBorderClipper extends CustomClipper<Path> {

	@override
	Path getClip(Size size){
		Path path = Path();
		path.addOval(Rect.fromCircle(
			center: Offset(size.width * 0.5, size.height * 0.5),
			radius: size.width * 0.5,
		));
		path.close();
		return path;
	}

	@override
	bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}

class _ClipperBorderPainter extends CustomPainter {

	final Color color;
	final double strokeWidth;
	final double ratio;
	final Color ratioColor;
	final CustomClipper clipper;

	_ClipperBorderPainter({
		@required this.clipper, this.color=Colors.white, this.ratio, this.ratioColor, this.strokeWidth});

	@override
	void paint(Canvas canvas, Size size){
		Paint paint = Paint()
			..style = PaintingStyle.stroke
			..strokeWidth = strokeWidth
			..color = color;

		Path path = clipper.getClip(size);
		canvas.drawPath(path, paint);
		path.close();

		if(ratio != null){
			var deg = ratio * 360;
			var radians = deg * degrees2Radians;
			Path _path = Path();
			_path.addArc(Rect.fromCircle(
				center: Offset(size.width * 0.5, size.height * 0.5),
				radius: size.width * 0.5,
			), 0.0, radians);
			Paint _paint = Paint()
				..style = PaintingStyle.stroke
				..strokeWidth = 4.0
				..color = ratioColor == null ? Colors.red : ratioColor;
			canvas.drawPath(_path, _paint);
			_path.close();
		}
	}

	@override
	bool shouldRepaint(CustomPainter oldPainter) => false;

}