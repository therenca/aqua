import 'package:flutter/material.dart';

class ClippedCircle extends StatelessWidget {
	final Widget child;
	final Color color;
	final double? strokeWidth;

	ClippedCircle({
		required this.child,
		this.color=Colors.white,
		this.strokeWidth=2.0,
	});

	Widget _buildClippedWidget() => ClipPath(
		clipper: _ColoredBorderClipper(),
		child: child,
	);

	Widget _addPathColorToClippedWidget(child) => CustomPaint(
		painter: _ClipperBorderPainter(
			color: color,
			strokeWidth: strokeWidth,
			clipper: _ColoredBorderClipper()
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
	bool shouldRepaint(CustomPainter oldPainter) => false;
}