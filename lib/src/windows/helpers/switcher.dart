import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:aqua/aqua.dart' as aqua;

class WindowSwitcher {
	
	String routeName;
	BuildContext context;
	aqua.NavigationStreamer navStreamer;
	StreamController<Map<String, dynamic>> streamController;
	Map<String, Map<String, dynamic>> routes;

	WindowSwitcher({
		this.routeName,
		this.routes,
		this.context,
		this.navStreamer,
		this.streamController
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