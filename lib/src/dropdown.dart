import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {

	final ValueKey key;
	final String initValue;
	final List<dynamic> items;
	final Function callback;
	final TextStyle textStyle;
	final Color dropdownColor;
	final Function initCallback;

	DropDown({
		@required this.items,
		this.key,
		this.initValue,
		this.textStyle,
		this.callback,
		this.dropdownColor,
		this.initCallback
	});

	@override
	_DropDownState createState() => _DropDownState();

}

class _DropDownState extends State<DropDown>{

	@override
	void initState(){
		super.initState();
		widget.initCallback != null ? widget.initCallback() : print('');
	}

	String selectedValue;

	String _getSelectedValue(){
		// return selectedValue == null ? widget.initValue : selectedValue;
		// return selectedValue == null ? widget.items.first : widget.items.contains(selectedValue) ? selectedValue : widget.items.first;

		return selectedValue == null ? widget.initValue == null ? widget.items.first : widget.initValue : widget.items.contains(selectedValue) ? selectedValue : widget.items.first;
	}

	Widget _buildDropDown(BuildContext context){
		return DropdownButton<dynamic>(
			key: widget.key,
			dropdownColor: widget.dropdownColor,
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