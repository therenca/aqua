import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIcon extends StatelessWidget{
	final double iconSize;
	final Color iconColor;
	final Color bgColor;
	final Widget spinkitWidget;

	LoadingIcon({
		this.iconSize=40.0, this.iconColor, this.bgColor, this.spinkitWidget});

	@override
	Widget build(BuildContext context){
		return Container(
			color: bgColor == null ? Colors.transparent : bgColor,
			child: Center(
				child: spinkitWidget == null ? SpinKitWanderingCubes(
					size: iconSize,
					color: iconColor == null ? Colors.blue : iconColor
				) : spinkitWidget,
			),
		);
	}
}