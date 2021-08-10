import 'package:flutter/material.dart';

Widget requestFocus(Widget child, BuildContext context, {FocusNode? focusNode}){
	return GestureDetector(
		child: child,
		onTap: () => FocusScope.of(context).requestFocus(focusNode == null ? new FocusNode() : focusNode)
	);
}