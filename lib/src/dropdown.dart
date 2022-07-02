import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
	final List<String> items;
	final String? initValue;
	final String? placeholder;
	final Function? callback;
	final TextStyle? textStyle;
	final Color? dropdownColor;
	final Function? initCallback;
	final Color? iconEnabledColor;
	final bool? isExpanded;
	final int? elevation;
	final double? itemHeight;
	DropDown({
		required this.items,
		this.initValue,
		this.textStyle,
		this.callback,
		this.dropdownColor,
		this.iconEnabledColor,
		this.initCallback,
		this.isExpanded=false,
		this.elevation,
		this.itemHeight,
		this.placeholder
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

		if(widget.placeholder != null){
			widget.items.insert(0, widget.placeholder!);
		}
	}

	String? selectedValue;
	Widget _buildDropDown(BuildContext context){
		return DropdownButton<String>(
			isExpanded: widget.isExpanded ?? false,
			dropdownColor: widget.dropdownColor,
			value: selectedValue ?? widget.initValue ?? widget.placeholder ?? widget.items.first,
			elevation: widget.elevation ?? 0,
			underline: Container(),
			onChanged: (String? newValue) async {
				setState(() {
					selectedValue = newValue;
				});

				if(widget.callback != null){
					await widget.callback!(newValue);
				}
			},
			itemHeight: widget.itemHeight,
			iconEnabledColor: widget.iconEnabledColor,
			items: widget.items.toSet()
				.map<DropdownMenuItem<String>>((String value){
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