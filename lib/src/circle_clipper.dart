import 'package:flutter/material.dart';

class ClippedCircle extends StatefulWidget {
	final Widget child;
	final Color color;
	final double? strokeWidth;

	ClippedCircle({
		required this.child,
		this.color=Colors.white,
		this.strokeWidth=2.0,
	});

	@override
	ClippedCircleState createState() => ClippedCircleState();

}

class ClippedCircleState extends State<ClippedCircle>{

	
	@override
	Widget build(BuildContext context){
		Widget clipped = ClipPath(
			clipper: _ColoredBorderClipper(),
			child: widget.child,
		);
		return CustomPaint(
			painter: _ClipperBorderPainter(
				color: widget.color,
				strokeWidth: widget.strokeWidth,
				clipper: _ColoredBorderClipper()
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
	final double? strokeWidth;
	final CustomClipper clipper;

	_ClipperBorderPainter({
		required this.clipper, this.color=Colors.white, this.strokeWidth});

	@override
	void paint(Canvas canvas, Size size){
		Paint paint = Paint()
			..style = PaintingStyle.stroke
			..strokeWidth = strokeWidth!
			..color = color;

		Path path = clipper.getClip(size);
		canvas.drawPath(path, paint);
		path.close();
	}

	@override
	bool shouldRepaint(CustomPainter oldPainter) => true;
}