import 'package:flutter/material.dart';

class Shadow extends StatelessWidget {

	final double width;
	final double height;

	final double top;
	final double left;
	final double right;
	final double bottom;
	final double? borderRadius;

	final Alignment? end;
	final Alignment? begin;

	final List<Color>? colors;

	Shadow({
		required this.width,
		required this.height,
		this.borderRadius,
		this.end, this.begin,
		this.top=0.0, this.left=0.0, this.right=0.0, this.bottom=0.0, this.colors});

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
					borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
					gradient: LinearGradient(
						colors: colors == null ? <Color>[
							Colors.transparent,
							Colors.black
						] : colors!,
						begin: begin == null ? Alignment.topCenter : begin!,
						end: end == null ? Alignment.bottomCenter: end!
					)
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildShadow(context);

}