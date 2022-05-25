import 'dart:async';
import 'package:flutter/material.dart';

class CustomNavigator{

	bool forward;
	bool replaceSingle;
	bool replaceAll;
	String namedRoute;
	Function buildScreen;
	BuildContext context;

	CustomNavigator({
		this.forward=true,
		this.replaceSingle=false,
		this.replaceAll=false,
		this.namedRoute='',
		required this.buildScreen,
		required this.context
	});

	Future<dynamic> navigateToPage() async {
		Completer<dynamic> completer = Completer();
		if(forward){
			if(namedRoute.isNotEmpty){
				// named route
				// routes already defined at the root of the application

				if(replaceSingle){
					var results = await Navigator.pushReplacementNamed(
						context,
						namedRoute
					);
					completer.complete(results);
				} else if(replaceAll){

					// to remove all the routes below this route
					// use a predicate that always returns a false,
					// otherwise use ModalRoute.withName('/) to match
					// to a certain route

					var results = Navigator.pushNamedAndRemoveUntil(
						context,
						namedRoute,
						// ModalRoute.withName('/'),
						(Route<dynamic> route) => false
					);
					completer.complete(results);

				} else {
					var results = Navigator.pushNamed(
						context,
						namedRoute
					);
					completer.complete(results);
				}
			} else {

				// unnamed route
				// rendering screens using buildScreen method

				if(replaceSingle){

					var results = Navigator.pushReplacement(
						context,
						MaterialPageRoute(
							maintainState: false,
							builder: (BuildContext context) => buildScreen()
						)
					);
					completer.complete(results);
				} else if(replaceAll){
					var results = Navigator.pushAndRemoveUntil(
						context, 
						MaterialPageRoute(
							maintainState: false,
							builder: (BuildContext context) => buildScreen()
						),
						(Route<dynamic> route) => false
					);
					completer.complete(results);
				} else {
					var results = Navigator.push(
						context,
						MaterialPageRoute(
							maintainState: true,
							builder: (BuildContext context) => buildScreen()
						)
					);
					completer.complete(results);
				}
			}
		} else {
			Navigator.pop(context);
		}

		return completer.future;
	}
}