import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' as provider;

import 'package:aqua/aqua.dart' as aqua;

class WindowSwitcher {
	
	String routeName;
	BuildContext context;
	Map<String, Map<String, dynamic>> routes;

	WindowSwitcher({this.routeName, this.routes, this.context});

	Widget switcher(){
		Map<String, Map<String, dynamic>> routes = provider.Provider.of<aqua.NavigationModel>(context, listen: false).routes;

		provider.Provider.of<aqua.NavigationModel>(context, listen: false).selectedWidget = routes[routeName]['window'];

		provider.Provider.of<aqua.NavigationModel>(context, listen: false).selectedColor = routes[routeName]['selectedColor'];

		provider.Provider.of<aqua.NavigationModel>(context, listen: false).selectedRouteName = routeName;

		return routes[routeName]['window'];
	}
}