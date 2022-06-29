
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {

	final Color? color;
	final double? width;
	final double? height;
	final double bgOpacity;
	final double fgOpacity;
	Loader({
		this.color,
		this.width,
		this.height,
		this.bgOpacity=0.4,
		this.fgOpacity=0.2
	});

	@override
	Widget build(BuildContext context){
		return SizedBox(
			height: height,
			width: width,
			child: LinearProgressIndicator(
				backgroundColor: color != null ? color!.withOpacity(bgOpacity) : Colors.black.withOpacity(bgOpacity),
				valueColor: AlwaysStoppedAnimation<Color>(
					color != null ? color!.withOpacity(fgOpacity) : Colors.black.withOpacity(fgOpacity)),
			),
		);
	}
}