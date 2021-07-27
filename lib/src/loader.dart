
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {

	final double width;
	final double height;
	final Color color;

	Loader({
		@required this.width,
		@required this.height,
		this.color
	});

	@override
	Widget build(BuildContext context){
		return SizedBox(
			height: height,
			width: width,
			child: LinearProgressIndicator(
				backgroundColor: color != null ? color.withOpacity(0.4) : Colors.black.withOpacity(0.4),
				valueColor: AlwaysStoppedAnimation<Color>(
					color != null ? color.withOpacity(0.2) : Colors.black.withOpacity(0.2)),
			),
		);
	}
}