import 'package:flutter/widgets.dart';

class Dimensions {
	double _width;
	double _height;

	BuildContext context;

	Dimensions(this.context){
		_width = MediaQuery.of(context).size.width;
		_height = MediaQuery.of(context).size.height;
	}
	
	double get width => _width;
	double get height => _height;

}