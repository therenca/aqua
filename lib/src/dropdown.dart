import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {

	final String initValue;
	final List<dynamic> items;
	final Function callback;
	final TextStyle textStyle;

	DropDown({
		@required this.items,
		this.initValue,
		this.textStyle,
		this.callback
	});

	@override
	_DropDownState createState() => _DropDownState();

}

class _DropDownState extends State<DropDown>{

	String selectedValue;

	String _getSelectedValue(){
		// return selectedValue == null ? widget.initValue : selectedValue;
		// return selectedValue == null ? widget.items.first : widget.items.contains(selectedValue) ? selectedValue : widget.items.first;

		return selectedValue == null ? widget.initValue == null ? widget.items.first : widget.initValue : widget.items.contains(selectedValue) ? selectedValue : widget.items.first;
	}

	Widget _buildDropDown(BuildContext context){
		return DropdownButton<dynamic>(
			value: _getSelectedValue(),
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
						child: Text(
							value,
							style: widget.textStyle == null ? TextStyle(
								color: Colors.black,
							) : widget.textStyle
						),
					);
				}).toList()
		);
	}

	Widget build(BuildContext context) => _buildDropDown(context);

}