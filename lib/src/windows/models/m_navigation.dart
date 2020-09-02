import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Navigation extends ChangeNotifier {

	Color selectedColor;
	BuildContext context;
	bool _isHovering = false;
	Color hoverColor = Colors.white;

	Widget _selectedWidget;
	String selectedRouteName;
	Map<String, Map<String, dynamic>> routes;


	bool get isHovering => _isHovering;
	Widget get selectedWidget => _selectedWidget;

	set selectedWidget(Widget child){
		_selectedWidget = child;
		notifyListeners();
	}

	set isHovering(bool flag){
		_isHovering = flag;
		notifyListeners();
	}
}