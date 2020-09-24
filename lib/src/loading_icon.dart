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
		this.width=40.0, this.height=40.0, this.iconSize=40.0, this.iconColor, this.bgColor, this.spinkitWidget});

	@override
	Widget build(BuildContext context){
		return Container(
			width: width,
			height: height,
			color: bgColor == null ? Colors.transparent : bgColor,
			child: Center(
				child: spinkitWidget == null ? SpinKitWanderingCubes(
					size: iconSize,
					color: iconColor == null ? Colors.red : iconColor
				) : spinkitWidget,
			),
		);
	}
}