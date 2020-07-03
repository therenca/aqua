import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIcon extends StatelessWidget{
	final double width;
	final double height;
	final double iconSize;
	final Color iconColor;
	final Color bgColor;
	final dynamic spinkitWidget;

	LoadingIcon({
		@required this.width, @required this.height, @required this.iconSize, @required this.iconColor, @required this.bgColor, this.spinkitWidget});

	@override
	Widget build(BuildContext context){
		return Container(
			color: bgColor,
			width: width,
			height: height,
			child: Center(
				child: spinkitWidget == null ? SpinKitWanderingCubes(
					size: iconSize,
					color: iconColor,
				) : spinkitWidget,
			),
		);
	}
}