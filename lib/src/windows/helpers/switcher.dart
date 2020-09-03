import 'package:flutter/widgets.dart';
import 'package:aqua/aqua.dart' as aqua;

class WindowSwitcher {
	
	String routeName;
	aqua.NavigationStreamer navStreamer;
	Map<String, Map<String, dynamic>> routes;

	WindowSwitcher({
		this.routeName,
		this.routes,
		this.navStreamer,
	});

	Widget switcher(){

		Map<String, dynamic> selectedWidget = {
			'routeName': routeName,
			'window': routes[routeName]['window'],
			'hoverColor': routes[routeName]['hoverColor'],
			'selectedColor': routes[routeName]['selectedColor'],
		};

		navStreamer.controller.sink.add(selectedWidget);

		return routes[routeName]['window'];
	}
}