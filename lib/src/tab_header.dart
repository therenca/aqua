import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget{

	final Color bgColor;
	final Color underline;
	final List<String> tabListing;
	final Border border;
	final Function onTap;
	final TabController controller;
	final double borderRadius;
	final TextStyle textStyle;

	TabHeader({
		@required this.tabListing,
		this.bgColor,
		this.underline,
		this.border,
		this.onTap,
		this.controller,
		this.borderRadius,
		this.textStyle
	});

	Widget _buildTabHeader(BuildContext context){
		
		List<Widget> tabs = [];

		for(int index=0; index<tabListing.length; index++){
			Tab tab = Tab(
				child: Container(
					// padding: EdgeInsets.only(left: 10.0),
					alignment: Alignment.centerLeft,
					// decoration: underline != null ? BoxDecoration(
					// 	border: Border(
					// 		bottom: BorderSide(
					// 			width: 2.0,
					// 			color: underline
					// 		)
					// 	)
					// ) : null,
					child: Text(
						tabListing[index],
						style: textStyle != null ? textStyle : TextStyle(
							fontSize: 15.0,
							color: Colors.black,
							fontWeight: FontWeight.bold
						),
					),
				),
			);

			tabs.add(tab);
		}		

		return TabBar(
			controller: controller,
			indicatorColor: underline,
			indicator: bgColor != null ? BoxDecoration(
				color: bgColor.withOpacity(0.6),
				borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : null,
			) : null,
			tabs: tabs,
			onTap: onTap != null ? onTap : null,
		);

	}

	@override
	Widget build(BuildContext context) => _buildTabHeader(context);

}