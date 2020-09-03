import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:aqua/aqua.dart' as aqua;

import '../helpers/switcher.dart';


class Standard extends StatefulWidget {

	final double width;
	final double height;
	final Widget header;
	final List<Color> bgColors;
	final aqua.NavigationStreamer navStreamer;
	final Map<String, Map<String, dynamic>> routes;

	Standard({
		@required this.width,
		@required this.height,
		@required this.routes,
		@required this.navStreamer,
		this.header,
		this.bgColors,
	});

	@override
	StandardState createState() => StandardState();

}

class StandardState extends State<Standard>{

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

	Widget _buildStandard(BuildContext context){

		List<Widget> nav = _buildRoutes();
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
	Widget build(BuildContext context) => _buildStandard(context);

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

}