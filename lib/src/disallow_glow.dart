import 'package:flutter/material.dart';

Widget disallowGlow(Widget child) => NotificationListener<OverscrollIndicatorNotification>(
	onNotification: (overscroll){
		overscroll.disallowIndicator();
		return false;
	},
	child: child
);