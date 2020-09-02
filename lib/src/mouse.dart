import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MouseInteractivity extends StatelessWidget {

	final Widget child;

	MouseInteractivity({@required this.child});

	Widget _buildMouseInteractivity(BuildContext context){
		return MouseRegion(
			cursor: SystemMouseCursors.click,
			child: child,
		);
	}

	@override
	Widget build(BuildContext context) => _buildMouseInteractivity(context);

}