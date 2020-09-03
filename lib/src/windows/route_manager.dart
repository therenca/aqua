import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'package:aqua/aqua.dart' as aqua;
import 'helpers/switcher.dart';


class RouteManager extends StatefulWidget {

	final String type;
	final double width;
	final double height;
	final Widget header;
	final List<Color> bgColors;
	final BuildContext context;
	final Map<String, Map<String, dynamic>> routes;

	final aqua.NavigationStreamer navStreamer;

	RouteManager({
		@required this.routes,
		@required this.context,
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

	Color hoverColor;
	Color selectedColor;
	bool isHovering = false;
	String selectedRouteName;

	@override
	void initState(){
		super.initState();


		widget.navStreamer.listen((data){
			aqua.pretifyOutput('[SETTINGS MINI SIDEBAR] data from nav stream: $data');
			
			hoverColor = data['hoverColor'];
			selectedRouteName = data['routeName'];
			selectedColor = data['selectedColor'];
		});
	}
	
	List<Widget> _buildStandard(){

		List<Widget> routeWidgets = [];
		widget.routes.forEach((routeName, routeInfo){
			Widget route = AnimatedContainer(
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
						routeInfo['icon'],
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

			Widget addGestureToRoute = GestureDetector(
				child: route,
				onTap: (){
					WindowSwitcher(
						routeName: routeName,
						context: context,
						routes: widget.routes,
						// streamController: widget.streamController
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

		return routeWidgets;
	}

	List<Widget> _buildNavTypes(){
		List<Widget> routeWidgets;

		switch(widget.type){

			case 'standard':
				routeWidgets = _buildStandard();
				if(widget.header != null){
					routeWidgets.insert(0, widget.header);
				}
				break;

			default:
				break;
		}

		return routeWidgets;
	}

	Widget _buildRouteManager(BuildContext context){

		List<Widget> nav = _buildNavTypes();
		Widget settings = nav.removeAt(nav.length - 1);

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

					Positioned(
						bottom: 10.0,
						child: settings,
					)
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildRouteManager(context);

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

		if(widget.routes[routeName]['isHovering']){
			if(hoverColor == null){
				hoverColor = Colors.grey;
			}
		} else {
			hoverColor = Colors.transparent;
		}

		return hoverColor;
	}
}
