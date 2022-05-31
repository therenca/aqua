import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
	final Color color;
	final double dashWidth;
	final double dashHeight;

	DottedLine({
		Key? key,
		this.dashHeight=1,
		this.dashWidth=10.0,
		this.color=Colors.black,
	}) : super(key: key);

	@override
	Widget build(BuildContext context){
		return LayoutBuilder(
			builder: (BuildContext context, BoxConstraints constraints){
				final boxWidth = constraints.constrainWidth();
				final dashCount = (boxWidth / (2*dashWidth)).floor();
				return Flex(
					direction: Axis.horizontal,
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: List.generate(dashCount, (_){
						return SizedBox(
							width: dashWidth,
							height: dashHeight,
							child: DecoratedBox(
								decoration: BoxDecoration(color: color),
							),
						);
					})
				);
			},
		);
	}
}