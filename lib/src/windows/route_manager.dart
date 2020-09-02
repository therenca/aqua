import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart' as provider;

import 'package:aqua/aqua.dart' as aqua;
import 'helpers/switcher.dart';

class RouteManager extends StatefulWidget {

	final String type;
	final double width;
	final Widget header;
	final BuildContext context;
	final Map<String, Map<String, dynamic>> routes;

	RouteManager({
		@required this.routes,
		@required this.context,
		this.type='standard',
		this.width,
		this.header,
	}){
		routes.forEach((routeName, routeInfo){
			routeInfo['isHovering'] = false;
			IconData iconData = routeInfo.remove('iconData');
			routeInfo['icon'] = _buildIconRoute(iconData);
		});

		provider.Provider.of<aqua.NavigationModel>(context, listen: false).routes = routes;
	}

	@override
	_RouteManagerState createState() => _RouteManagerState();

	Widget _buildIconRoute(IconData iconData){
		return  Icon(iconData, size: 20.0, color: Colors.green,);
	}
}

class _RouteManagerState extends State<RouteManager>{

	bool isHovering = false;
	
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
						routes: widget.routes
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
		return ListView(
			children: _buildNavTypes(),
		);
	}

	@override
	Widget build(BuildContext context) => _buildRouteManager(context);

	Color _getCurrentSelectedColor(String routeName){
		Color selectedColor;
		String selectedRouteName = provider.Provider.of<aqua.NavigationModel>(context, listen: false).selectedRouteName;
		
		if(selectedRouteName == routeName){
			selectedColor = provider.Provider.of<aqua.NavigationModel>(context, listen: false).selectedColor;
		} else {
			selectedColor = Colors.transparent;
		}

		return selectedColor;
	}

	Color _hoverOnCurrentRoute(String routeName){
		Color hoverColor;

		if(widget.routes[routeName]['isHovering']){
			hoverColor = provider.Provider.of<aqua.NavigationModel>(context, listen: false).hoverColor;
		} else {
			hoverColor = Colors.transparent;
		}

		return hoverColor;
	}
}
