import 'package:flutter/material.dart';

class Line extends StatelessWidget{

	final Color color;
	final double borderWidth;

	final dynamic width;
	final dynamic height;

	final bool horizontal;

	Line({this.color, this.borderWidth, this.width, this.height, this.horizontal});

	@override
	Widget build(BuildContext context){

		return Container(
			width: width,
			height: height,
			decoration: BoxDecoration(
				border: horizontal ? Border(
					bottom: BorderSide(
						color: color,
						width: borderWidth
					)
				) : Border(
					right: BorderSide(
						color: color,
						width: borderWidth
					)
				)
			),
		);
	}
}