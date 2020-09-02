import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../shadow.dart';
import 'route_manager.dart';
import 'models/m_navigation.dart' as m_nav;

class NavigationModel extends m_nav.Navigation {}

class Navigation extends StatefulWidget {

	final double width;
	final double height;

	final Alignment end;
	final Alignment begin;
	final List<Color> bgColors;
	final BuildContext parentContext;
	
	final String type;

	final Widget header;
	final Map<String, Map<String, dynamic>> routes;

	Navigation({
		@required this.width,
		@required this.height,
		this.bgColors,
		this.begin,
		this.end,

		this.header,
		this.parentContext,
		this.type='standard',
		@required this.routes,
	});

	@override
	_NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

	BuildContext currentContext;

	// List<Widget> _buildNavTypes(){

	// 	List<Widget> nav;

	// 	nav = RouteManager(
	// 		header: widget.header,
	// 		type: widget.type,
	// 		width: widget.width,
	// 		routes: widget.routes,
	// 		context: currentContext,
	// 		// context: widget.parentContext
	// 	);

	// 	return nav;
	// }

	Widget _buildNavigation(BuildContext context){
		currentContext = context;
		return Container(
			width: widget.width,
			height: widget.height,
			child: Stack(
				children: [
					Shadow(
						width: widget.width,
						height: widget.height,
						colors: widget.bgColors,
					),
					SizedBox(
						width: widget.width,
						height: widget.height,
						child: RouteManager(
							header: widget.header,
							type: widget.type,
							width: widget.width,
							routes: widget.routes,
							context: currentContext,
							// context: widget.parentContext
						)
					)
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildNavigation(context);
}