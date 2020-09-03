import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:aqua/aqua.dart' as aqua;

import 'helpers/switcher.dart';


class SideBar extends StatefulWidget {

	final String type;
	final double width;
	final double height;
	final Widget header;
	final List<Color> bgColors;
	final aqua.NavigationStreamer navStreamer;
	final Map<String, Map<String, dynamic>> routes;

	SideBar({
		@required this.width,
		@required this.height,
		@required this.routes,
		@required this.navStreamer,
		this.type,
		this.header,
		this.bgColors,
	});

	@override
	SidebarState createState() => SidebarState();

}

class SidebarState extends State<SideBar>{

	Color selectedColor;
	bool isHovering = false;
	String selectedRouteName;

	@override
	void initState(){
		super.initState();

		widget.navStreamer.listen((data){
			aqua.pretifyOutput('[SETTINGS MINI SIDEBAR] data from nav stream: $data');
			
			selectedRouteName = data['routeName'];
			selectedColor = data['selectedColor'];
		});
	}

	List<Widget> _buildRoutes(){

		List<Widget> routeWidgets = [];
		widget.routes.forEach((routeName, routeInfo){
			Widget route;
			switch(widget.type){

				case 'standard': {
					route = _buildStandardRoute(routeName, routeInfo['icon']);
					break;
				}

				case 'compact': {
					route = _buildCompactRoute(
						routeName,
						routeInfo['icon'],
						routeInfo['extra']
					);

					break;
				}

				default: {
					break;
				}
			}


			Widget addGestureToRoute = GestureDetector(
				child: route,
				onTap: (){
					WindowSwitcher(
						routeName: routeName,
						routes: widget.routes,
						navStreamer: widget.navStreamer
					).switcher();
				},
			);


			Widget addMouseRegion = MouseRegion(
				cursor: SystemMouseCursors.click,
				onEnter: (PointerEnterEvent event){
					isHovering = true;
					widget.routes[routeName]['isHovering'] = isHovering;
					setState((){});
				},
				onExit: (PointerExitEvent event){
					isHovering = false;
					widget.routes[routeName]['isHovering'] = isHovering;
					setState((){});
				},
				child: addGestureToRoute,
			);

			routeWidgets.add(addMouseRegion);
		});

		if(widget.header != null){
			routeWidgets.insert(0, widget.header);
		}

		return routeWidgets;
	}

	Widget _buildSideBar(BuildContext context){

		List<Widget> nav = _buildRoutes();

		Widget settings;
		if(widget.type == 'standard'){
			settings = nav.removeAt(nav.length - 1);
		}

		return Container(
			width: widget.width,
			height: widget.height,
			child: Stack(
				children: [
					aqua.Shadow(
						width: widget.width,
						height: widget.height,
						colors: widget.bgColors,
					),

					SizedBox(
						width: widget.width,
						height: widget.height,
						child: ListView(
							children: nav
						)
					),

					widget.type == 'standard' ? Positioned(
						bottom: 10.0,
						child: settings,
					) : Container()
				],
			),
		);

	}

	@override
	Widget build(BuildContext context) => _buildSideBar(context);

	Color _getCurrentSelectedColor(String routeName){

		if(selectedRouteName == routeName){
			if(selectedColor == null){
				return Colors.cyan;
			}
		} else {
			selectedColor = Colors.transparent;
		}

		return selectedColor;
	}

	Color _hoverOnCurrentRoute(String routeName){
		Color hoverColor;

		if(widget.routes[routeName]['isHovering']){
			hoverColor = widget.routes[routeName]['hoverColor'];
		} else {
			hoverColor = Colors.transparent;
		}

		return hoverColor;
	}

	Widget _buildStandardRoute(String routeName, Icon icon){
		return  AnimatedContainer(
			duration: Duration(milliseconds: 300),
			color: isHovering ? _hoverOnCurrentRoute(routeName) : _getCurrentSelectedColor(routeName),
			padding: EdgeInsets.only(
				top: 10.0,
				left: 20.0,
				bottom: 10.0
			),
			width: widget.width,
			child: Row(
				children: [
					icon,
					SizedBox(width: 15.0),
					Text(
						routeName,
						style: TextStyle(
							color: Colors.black,
							fontWeight: FontWeight.bold
						),
					),
				],
			),
		);
	}

	Widget _buildCompactRoute(String routeName, Icon icon, String extra){
		return Container(
			child: Row(
				children: [
					icon,
					SizedBox(width: 15.0),
					Column(
						children: [
							Text(
								routeName,
								style: TextStyle(

								),
							),
							SizedBox(height: 10.0,),
							Text(
								extra,
								style: TextStyle(

								),
							),
						],
					)
				],
			),
		);
	}

}