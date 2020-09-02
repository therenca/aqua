import 'package:flutter/material.dart';

Widget requestFocus(Widget child, {BuildContext context}){
	return GestureDetector(
		child: child,
		onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
	);
}