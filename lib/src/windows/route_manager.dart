import 'package:flutter/material.dart';
import 'package:aqua/aqua.dart' as aqua;
import 'sidebar.dart';

class RouteManager extends StatefulWidget {

	final String type;
	final Widget header;
	final Color textColor;
	final Color hoverTextColor;
	final List<Color> bgColors;
	final Color selectedColor;
	final Color hoverColor;
	final aqua.NavigationStreamer navStreamer;
	final Map<String, Map<String, dynamic>> routes;

	final Alignment begin;
	final Alignment end;

	RouteManager({
		@required this.routes,
		@required this.navStreamer,
		this.type='standard',
		this.selectedColor,
		this.hoverColor,
		this.textColor,
		this.hoverTextColor,
		this.header,
		this.bgColors,
		this.begin,
		this.end
	}){
		routes.forEach((routeName, routeInfo){
			routeInfo['isHovering'] = false;
			routeInfo['hoverColor'] = hoverColor;
			routeInfo['selectedColor'] = selectedColor;
		});
	}

	@override
	_RouteManagerState createState() => _RouteManagerState();

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
			end: widget.end,
			begin: widget.begin,
			type: widget.type,
			routes: widget.routes,
			header: widget.header,
			bgColors: widget.bgColors,
			navStreamer: widget.navStreamer,
			selectedColor: widget.selectedColor,
			textColor: widget.textColor,
			hoverTextColor: widget.hoverTextColor
		);
	}

	@override
	Widget build(BuildContext context) => _buildRouteManager(context);
}
