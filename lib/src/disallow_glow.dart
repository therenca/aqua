import 'package:flutter/material.dart';

Widget disallowGlow(ListView child) => NotificationListener<OverscrollIndicatorNotification>(
	onNotification: (overscroll){
		overscroll.disallowGlow();
		return false;
	},
	child: child
);