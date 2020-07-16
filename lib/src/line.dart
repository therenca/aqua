import 'package:flutter/material.dart';

class Line extends StatelessWidget{

	final Color color;

	final double width;
	final double height;
	final double borderWidth;

	final bool horizontal;

	Line({this.color, this.width, this.height, this.horizontal, this.borderWidth});

	@override
	Widget build(BuildContext context){

		return Container(
			width: width,
			height: height,
			decoration: BoxDecoration(
				border: horizontal ? Border(
					bottom: BorderSide(
						color: color,
						width: height
					)
				) : Border(
					right: BorderSide(
						color: color,
						width: width,
					)
				)
			),
		);
	}
}