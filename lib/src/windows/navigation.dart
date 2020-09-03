import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aqua/aqua.dart' as aqua;

import 'route_manager.dart';

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

	final NavigationStreamer navStreamer;

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
		@required this.navStreamer
	});

	@override
	_NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

	BuildContext currentContext;

	Widget _buildNavigation(BuildContext context){
		currentContext = context;

		return RouteManager(
			context: currentContext,
			routes: widget.routes,
			bgColors: widget.bgColors,
			header: widget.header,
			height: widget.height,
			width: widget.width,
			navStreamer: widget.navStreamer,
		);
	}

	@override
	Widget build(BuildContext context) => _buildNavigation(context);
}

class NavigationStreamer {
	
	StreamController<Map<String, dynamic>> _controller;

	NavigationStreamer(){
		_controller = StreamController.broadcast();
	}

	StreamController get controller => _controller;
	Stream get stream => _controller.stream;

	StreamSubscription listen(Function listenCallback){
		StreamSubscription sub = _controller.stream.distinct().listen(
			(data){
				listenCallback(data);
			},
			onError: (err){
				aqua.pretifyOutput('[MAIN NAV STREAM|Error] $err', color: 'red');
			},
			cancelOnError: false,
			onDone: (){
				aqua.pretifyOutput('[MAIN NAV STREAM] DONE');
			}
		);

		return sub;
	}

	void close(){
		_controller.close();
	}
}