import 'package:flutter/material.dart';

class Line extends StatelessWidget{

	final Color color;
	final double width;
	final double height;

	Line({
		required this.color,
		required this.width,
		required this.height
	});

	@override
	Widget build(BuildContext context){

		return Container(
			width: width,
			height: height,
			color: color,
		);
	}
}