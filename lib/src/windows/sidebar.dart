import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:aqua/aqua.dart' as aqua;

import 'helpers/switcher.dart';

class SideBar extends StatefulWidget {

	final String? type;
	final Widget? header;
	final Alignment? begin;
	final Alignment? end;
	final Color? selectedColor;
	final Color? textColor;
	final Color? hoverTextColor;
	final double? fontSize;
	final FontWeight? fontWeight;
	final List<Color>? bgColors;
	final aqua.NavigationStreamer navStreamer;
	final Map<String, Map<String, dynamic>> routes;

	SideBar({
		required this.routes,
		required this.navStreamer,
		this.type,
		this.header,
		this.bgColors,
		this.begin,
		this.end,
		this.selectedColor,
		this.textColor,
		this.hoverTextColor,
		this.fontSize,
		this.fontWeight
	});

	@override
	SidebarState createState() => SidebarState();
}

class SidebarState extends State<SideBar>{

	bool isHovering = false;
	String? selectedRouteName;

	@override
	void initState(){
		super.initState();

		widget.navStreamer.listen((data){
			selectedRouteName = data['routeName'];
		});
	}

	List<Widget> _buildRoutes(double width){

		int tracker = 1;
		List<Widget> routeWidgets = [];
		widget.routes.forEach((routeName, routeInfo){
			Widget? route;
			switch(widget.type){

				case 'standard': {
					route = _buildStandardRoute(
						width,
						routeName,
						routeInfo['icon'],
						tracker
					);
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
					isHovering = false;
					setState((){});

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
					widget.routes[routeName]!['isHovering'] = true;
					setState((){});
				},
				onExit: (PointerExitEvent event){
					isHovering = false;
					widget.routes[routeName]!['isHovering'] = false;
					setState((){});
				},
				child: addGestureToRoute,
			);

			routeWidgets.add(addMouseRegion);

			tracker++;
		});

		if(widget.header != null){
			routeWidgets.insert(0, widget.header!);
		}

		return routeWidgets;
	}

	Widget _buildSideBar(BuildContext context){
		return aqua.DynamicDimensions(
			renderWidget: (double width, double height){
				var isPositionedBottom = false;
				List<Widget> nav = _buildRoutes(width);

				Widget? settings;
				if(widget.type == 'standard'){
					if(widget.header != null && nav.length > 2) {
						isPositionedBottom = true;
						settings = nav.removeAt(nav.length - 1);
					}
				}

				Widget background;
				if(widget.bgColors != null){
					if(widget.bgColors!.length == 1){
						background = Container(
							width: width,
							height: height,
							color: widget.bgColors![0],
						);
					} else {
						background = aqua.Shadow(
							width: width,
							height: height,
							colors: widget.bgColors,
							begin: widget.begin,
							end: widget.end,
						);
					}
				} else {
					background = Container(
						width: width,
						height: height,
						color: Colors.white,
					);
				}

				return Container(
					width: width,
					height: height,
					child: Stack(
						children: [
							background,

							SizedBox(
								width: width,
								height: height,
								child: ListView(
									children: nav
								)
							),

							widget.type == 'standard' && isPositionedBottom ? Positioned(
								bottom: 10.0,
								child: settings!,
							) : Container()
						],
					),
				);
			},
		);

	}

	@override
	Widget build(BuildContext context) => _buildSideBar(context);

	Color _getCurrentSelectedColor(String routeName, int tracker){

		if(selectedRouteName == null && tracker == 1){
			return widget.selectedColor!;
		} else if(selectedRouteName == routeName){
			return widget.selectedColor!;
		} else {
			return Colors.transparent;
		}
	}

	List<Color> _hoverOnCurrentRoute(String routeName){
		Color hoverColor;
		Color hoverTextColor;
		if(widget.routes[routeName]!['isHovering']){
			hoverColor = widget.routes[routeName]!['hoverColor'];
			hoverTextColor = widget.hoverTextColor == null ? Colors.black : widget.hoverTextColor!;
		} else {
			hoverColor = Colors.transparent;
			hoverTextColor = widget.textColor == null ? Colors.black : widget.textColor!;
		}
	
		return [hoverColor, hoverTextColor];
	}

	Widget _buildStandardRoute(double width, String routeName, Icon icon, int tracker){

		var hoverColors = _hoverOnCurrentRoute(routeName);

		return  AnimatedContainer(
			duration: Duration(milliseconds: 300),
			// color: isHovering ? _hoverOnCurrentRoute(routeName) : _getCurrentSelectedColor(routeName, tracker),
			color: isHovering ? hoverColors[0] :  _getCurrentSelectedColor(routeName, tracker),
			padding: EdgeInsets.only(
				top: 10.0,
				left: 20.0,
				bottom: 10.0
			),
			width: width,
			child: Row(
				children: [
					icon,
					SizedBox(width: 15.0),
					Text(
						routeName,
						style: TextStyle(
							fontSize: widget.fontSize == null ? 13.0 : widget.fontSize,
							color: isHovering ? hoverColors[1] : widget.textColor == null ? Colors.black : widget.textColor,
							fontWeight: widget.fontWeight == null ? FontWeight.bold : widget.fontWeight
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
						width:1.0,
						// color: Color(0xFFF8F9FF),
						color: Colors.grey.withOpacity(0.1),
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
									color: Colors.white,
									fontSize: widget.fontSize == null ? fontSize : widget.fontSize,
									fontWeight: widget.fontWeight == null ? FontWeight.bold : widget.fontWeight
								),
							),
							SizedBox(height: 5.0,),
							Text(
								extra,
								style: TextStyle(
									color: Colors.grey,
									fontSize: widget.fontSize == null ? fontSize : widget.fontSize,
									fontWeight: widget.fontWeight == null ? FontWeight.bold : widget.fontWeight
								),
							),
						],
					)
				],
			),
		);
	}
}