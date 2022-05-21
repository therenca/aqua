import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {

	final List<dynamic> items;
	final ValueKey? key;
	final String? initValue;
	final Function? callback;
	final TextStyle? textStyle;
	final Color? dropdownColor;
	final Function? initCallback;
	final Color? iconEnabledColor;
	final bool? isExpanded;

	DropDown({
		required this.items,
		this.key,
		this.initValue,
		this.textStyle,
		this.callback,
		this.dropdownColor,
		this.iconEnabledColor,
		this.initCallback,
		this.isExpanded=false
	});

	@override
	_DropDownState createState() => _DropDownState();

}

class _DropDownState extends State<DropDown>{

	@override
	void initState(){
		super.initState();
		if(widget.initCallback != null){
			widget.initCallback!();
		}
	}

	String? selectedValue;
	Widget _buildDropDown(BuildContext context){
		return DropdownButton<dynamic>(
			key: widget.key,
			isExpanded: widget.isExpanded ?? false,
			dropdownColor: widget.dropdownColor,
			value: selectedValue ?? widget.initValue ?? widget.items.first,
			underline: Container(),
			onChanged: (dynamic newValue) async {
				setState(() {
					selectedValue = newValue;
				});

				if(widget.callback != null){
					await widget.callback!(newValue);
				}
			},
			iconEnabledColor: widget.iconEnabledColor,

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