import 'package:flutter/material.dart';

class ImageFit extends StatelessWidget {
	final Widget child;
	const ImageFit({
		Key? key,
		required this.child
	}) : super(key: key);

	@override
	Widget build(BuildContext context){
		return Stack(
			children: [
				Positioned(
					top: 0,
					left: 0,
					right: 0,
					bottom: 0,
					child: child
				)
			],
		);
	}
}