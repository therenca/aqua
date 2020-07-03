import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {

	final double width;
	final double height;
	final String imgStr;

	BackgroundImage({
		@required this.width, @required this.height, @required this.imgStr});

	Widget _buildBackgroundImage(BuildContext context){
		return Container(
			width: width,
			height: height,
			child: Image(
				fit: BoxFit.cover,
				image: AssetImage(imgStr)
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildBackgroundImage(context);

}