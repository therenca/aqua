import 'package:flutter/material.dart';

class ClippedCircle extends StatelessWidget {

	final Widget child;
	final Color color;

	ClippedCircle({
		@required this.child,
		this.color=Colors.white
	});

	Widget _buildClippedWidget() => ClipPath(
		clipper: ColoredBorderClipper(),
		child: child,
	);

	Widget _addPathColorToClippedWidget(child) => CustomPaint(
		painter: ClipperBorderPainter(
			color: color,
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

class ClipperBorderPainter extends CustomPainter {

	final Color color;
	final CustomClipper clipper;

	ClipperBorderPainter({
		@required this.clipper, this.color=Colors.white});

	@override
	void paint(Canvas canvas, Size size){
		Paint paint = Paint()
			..style = PaintingStyle.stroke
			..strokeWidth = 2.0
			..color = color;

		// Path path = Path();

		// path.addOval(Rect.fromCircle(
		// 	center: Offset(size.width * 0.5, size.height * 0.5),
		// 	radius: size.width * 0.5,
		// ));

		// path.close();

		Path path = clipper.getClip(size);
		canvas.drawPath(path, paint);

	}

	@override
	bool shouldRepaint(CustomPainter oldPainter) => false;

}