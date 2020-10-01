import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {

	final String initValue;
	final List<dynamic> items;
	final Function callback;

	DropDown({
		@required this.initValue,
		@required this.items,
		this.callback
	});

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
		return DropdownButton<dynamic>(
			value: selectedValue,

			style: TextStyle(color: Colors.white),
			underline: Container(),
			onChanged: (dynamic newValue) async {
				setState(() {
					selectedValue = newValue;
				});

				if(widget.callback != null){
					await widget.callback(newValue);
				}
			},

			items: widget.items
				.map<DropdownMenuItem<String>>((dynamic value){
					return DropdownMenuItem<String>(
						value: value,
						child: Text(value),
					);
				}).toList()
		);
	}

	Widget build(BuildContext context) => _buildDropDown(context);

}