import 'package:flutter/material.dart';
import 'package:aqua/aqua.dart' as aqua;
import 'sidebar.dart';

class RouteManager extends StatefulWidget {

	final String type;
	final double width;
	final double height;
	final Widget header;
	final List<Color> bgColors;
	final Map<String, Map<String, dynamic>> routes;

	final aqua.NavigationStreamer navStreamer;

	RouteManager({
		@required this.routes,
		@required this.navStreamer,
		this.type='standard',
		this.header,
		this.width,
		this.height,
		this.bgColors,
	}){
		routes.forEach((routeName, routeInfo){
			routeInfo['isHovering'] = false;
			IconData iconData = routeInfo.remove('iconData');
			routeInfo['icon'] = _buildIconRoute(iconData);
		});

	}

	@override
	_RouteManagerState createState() => _RouteManagerState();

	Widget _buildIconRoute(IconData iconData){
		return  Icon(iconData, size: 20.0, color: Colors.green,);
	}
}

class _RouteManagerState extends State<RouteManager>{

	Color selectedColor;
	bool isHovering = false;
	String selectedRouteName;

	@override
	void initState(){
		super.initState();

	}

	Widget _buildRouteManager(BuildContext context){
		return SideBar(
			type: widget.type,
			width: widget.width,
			height: widget.height,
			routes: widget.routes,
			header: widget.header,
			bgColors: widget.bgColors,
			navStreamer: widget.navStreamer,
		);
	}

	@override
	Widget build(BuildContext context) => _buildRouteManager(context);
}
