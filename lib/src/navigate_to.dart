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

	void navigateToPage(){
		if(forward){
			if(namedRoute.isNotEmpty){
				// named route
				// routes already defined at the root of the application

				if(replaceSingle){
					Navigator.pushReplacementNamed(
						context,
						namedRoute
					);
				} else if(replaceAll){

					// to remove all the routes below this route
					// use a predicate that always returns a false,
					// otherwise use ModalRoute.withName('/) to match
					// to a certain route

					Navigator.pushNamedAndRemoveUntil(
						context,
						namedRoute,
						// ModalRoute.withName('/'),
						(Route<dynamic> route) => false
					);

				} else {
					Navigator.pushNamed(
						context,
						namedRoute
					);
				}
			} else {

				// unnamed route
				// rendering screens using buildScreen method

				if(replaceSingle){

					Navigator.pushReplacement(
						context,
						MaterialPageRoute(
							maintainState: false,
							builder: (BuildContext context) => buildScreen()
						)
					);

				} else if(replaceAll){
					Navigator.pushAndRemoveUntil(
						context, 
						MaterialPageRoute(
							maintainState: false,
							builder: (BuildContext context) => buildScreen()
						),
						(Route<dynamic> route) => false
					);
				} else {
					Navigator.push(
						context,
						MaterialPageRoute(
							maintainState: true,
							builder: (BuildContext context) => buildScreen()
						)
					);
				}
			}
		} else {
			Navigator.pop(context);
		}
	}

}