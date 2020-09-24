import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget{

	final List<String> tabListing;

	TabHeader({@required this.tabListing});

	Widget _buildTabHeader(BuildContext context){
		
		List<Widget> tabs = [];

		for(int index=0; index<tabListing.length; index++){
			Tab tab = Tab(
				child: Container(
					padding: EdgeInsets.only(left: 10.0),
					alignment: Alignment.centerLeft,
					child: Text(
						tabListing[index]
					),
				),
			);

			tabs.add(tab);
		}		

		return TabBar(
			tabs: tabs,
		);

	}

	@override
	Widget build(BuildContext context) => _buildTabHeader(context);

}