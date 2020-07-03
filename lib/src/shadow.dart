import 'package:flutter/material.dart';

class Shadow extends StatelessWidget {

	final double width;
	final double height;

	final double top;
	final double left;
	final double right;
	final double bottom;

	final Alignment end;
	final Alignment begin;

	final List<Color> colors;

	Shadow({
		@required this.width,
		@required this.height,
		this.end, this.begin,
		this.top, this.left, this.right, this.bottom, this.colors});

	Widget _buildShadow(BuildContext context){
		return Positioned(
			top: top,
			left: left,
			right: right,
			bottom: bottom,
			child: Container(
				width: width,
				height: height,
				decoration: BoxDecoration(
					gradient: LinearGradient(
						colors: colors == null ? <Color>[
							Colors.transparent,
							Colors.black
						] : colors,
						begin: begin == null ? Alignment.topCenter : begin,
						end: end == null ? Alignment.bottomCenter: end
					)
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildShadow(context);

}