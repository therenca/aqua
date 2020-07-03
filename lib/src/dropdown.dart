import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {

	final String initValue;
	final List<String> items;
	// final Function callback;

	DropDown({@required this.initValue, @required this.items});

	@override
	_DropDownState createState() => _DropDownState();

}

class _DropDownState extends State<DropDown>{

	String selectedValue;

	@override
	void initState(){
		super.initState();

		selectedValue = widget.initValue;
	}

	Widget _buildDropDown(BuildContext context){
		return DropdownButton<String>(
			value: selectedValue,

			style: TextStyle(color: Colors.white),
			underline: Container(),
			onChanged: (String newValue){
				setState(() {
					selectedValue = newValue;
				});
			},

			items: widget.items
				.map<DropdownMenuItem<String>>((String value){
					return DropdownMenuItem<String>(
						value: value,
						child: Text(value),
					);
				}).toList()
		);
	}

	Widget build(BuildContext context) => _buildDropDown(context);

}