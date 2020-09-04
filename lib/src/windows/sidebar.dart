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
	final Alignment begin;
	final Alignment end;
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
		this.begin,
		this.end
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

		Widget background;
		if(widget.bgColors != null){
			if(widget.bgColors.length == 1){
				background = Container(
					width: widget.width,
					height: widget.height,
					color: widget.bgColors[0],
				);
			} else {
				background = aqua.Shadow(
					width: widget.width,
					height: widget.height,
					colors: widget.bgColors,
					begin: widget.begin,
					end: widget.end,
				);
			}
		} else {
			background = Container(
				width: widget.width,
				height: widget.height,
				color: Colors.white,
			);
		}

		return Container(
			width: widget.width,
			height: widget.height,
			child: Stack(
				children: [
					background,

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
			return selectedColor;
		} else {
			return null;
		}
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
		double fontSize = 12.0;
		return Container(
			padding: EdgeInsets.symmetric(
				vertical: 20.0,
				horizontal: 20.0,
			),
			decoration: BoxDecoration(
				border: Border(
					bottom: BorderSide(
						width: 2.0,
						color: Color(0xFFF8F9FF),
						// color: Colors.grey,
						// style: BorderStyle.solid
					)
				)
			),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					icon,
					SizedBox(width: 15.0),
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								routeName,
								style: TextStyle(
									fontSize: fontSize,
									fontWeight: FontWeight.bold
								),
							),
							SizedBox(height: 5.0,),
							Text(
								extra,
								style: TextStyle(
									fontSize: fontSize,
									color: Colors.grey,
									fontWeight: FontWeight.bold
								),
							),
						],
					)
				],
			),
		);
	}
}