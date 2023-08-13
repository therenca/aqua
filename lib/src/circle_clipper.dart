import 'dart:math' as math;
import 'package:flutter/material.dart';

const double degrees2Radians = math.pi / 180.0;

class ClippedCircle extends StatefulWidget {
	final Color color;
	final Widget child;
	final Color? bgColor;
	final double? ratio;
	final Color? ratioColor;
	final double? strokeWidth;

	ClippedCircle({
		required this.child,
		this.strokeWidth=2.0,
		this.color=Colors.white,
		this.bgColor=Colors.transparent,
		this.ratio,
		this.ratioColor
	});

	@override
	ClippedCircleState createState() => ClippedCircleState();
}

class ClippedCircleState extends State<ClippedCircle>{
	@override
	Widget build(BuildContext context){
		Widget clipped = ClipPath(
			clipper: _ColoredBorderClipper(),
			child: Container(
				color: widget.bgColor,
				child: widget.child,
			)
		);
		return CustomPaint(
			painter: _ClipperBorderPainter(
				color: widget.color,
				strokeWidth: widget.strokeWidth,
				clipper: _ColoredBorderClipper(),
				ratio: widget.ratio,
				ratioColor: widget.ratioColor
			),
			child: clipped,
		);
	}
}

class _ColoredBorderClipper extends CustomClipper<Path> {
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
	final double? ratio;
	final Color? ratioColor;
	final double? strokeWidth;
	final CustomClipper clipper;

	_ClipperBorderPainter({
		required this.clipper,
		this.color=Colors.white,
		this.strokeWidth,
		this.ratio,
		this.ratioColor
	});

	@override
	void paint(Canvas canvas, Size size){
		Paint paint = Paint()
			..style = PaintingStyle.stroke
			..strokeWidth = strokeWidth!
			..color = color;

		Path path = clipper.getClip(size);
		canvas.drawPath(path, paint);
		path.close();
		if(ratio != null){
			var deg = ratio! * 360;
			var radians = deg * degrees2Radians;
			Path _path = Path();
			_path.addArc(Rect.fromCircle(
				center: Offset(size.width * 0.5, size.height * 0.5),
				radius: size.width * 0.5,
			), 0.0, radians);
			Paint _paint = Paint()
				..style = PaintingStyle.stroke
				..strokeWidth = 4.0
				..color = ratioColor == null ? Colors.red : ratioColor!;
			canvas.drawPath(_path, _paint);
			_path.close();
		}
	}

	@override
	bool shouldRepaint(CustomPainter oldPainter) => true;
}