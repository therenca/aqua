import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget{

	final Color bgColor;
	final double borderRadius;
	final Color underline;
	final List<String> tabListing;
	final Function onTap;
	final TabController controller;
	final TextStyle textStyle;
	final Color unselectedLabelColor;
	final Color labelColor;
	final TextStyle unselectedLabelStyle;
	final BoxDecoration decoration;
	final Alignment alignment;
	final EdgeInsets padding;

	final double tabHeight;

	TabHeader({
		@required this.tabListing,
		this.bgColor,
		this.borderRadius,
		this.underline,
		this.onTap,
		this.controller,
		this.textStyle,
		this.unselectedLabelStyle,
		this.unselectedLabelColor,
		this.labelColor,
		this.decoration,
		this.alignment,
		this.padding,
		this.tabHeight
	});

	Widget _buildTabHeader(BuildContext context){
		
		List<Widget> tabs = [];

		for(int index=0; index<tabListing.length; index++){
			Tab tab = Tab(
				child: Container(
					padding: padding,
					alignment: alignment == null ? Alignment.centerLeft : alignment,
					height: tabHeight,
					decoration: decoration,
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
			unselectedLabelColor: unselectedLabelColor,
			unselectedLabelStyle: unselectedLabelStyle,
			labelColor: labelColor,
			onTap: onTap != null ? onTap : null,
		);

	}

	@override
	Widget build(BuildContext context) => _buildTabHeader(context);

}