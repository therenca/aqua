import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class DropDown extends StatefulWidget {
	final Key? key;
	final List<String> items;
	final Function? callback;
	final TextStyle? textStyle;
	final Color? dropdownColor;
	final Function? initCallback;
	final Color? iconEnabledColor;
	final bool? isExpanded;
	final int? elevation;
	final double? itemHeight;
  final String? selected;
	DropDown({
		required this.items,
		this.key,
		this.textStyle,
		this.callback,
		this.dropdownColor,
		this.iconEnabledColor,
		this.initCallback,
		this.isExpanded=false,
		this.elevation,
		this.itemHeight,
    this.selected
	});

	@override
	DropDownState createState() => DropDownState();

}

class DropDownState extends State<DropDown>{
	String? selectedValue;
	late List<String> _items;
	@override
	void initState(){
		super.initState();
		_items = widget.items;
		selectedValue = widget.selected ?? widget.items.first;
    widget.initCallback?.call();
	}

	Widget _buildDropDown(BuildContext context){
		return DropdownButton<String>(
			isExpanded: widget.isExpanded ?? false,
			dropdownColor: widget.dropdownColor,
			value: selectedValue ?? widget.selected,
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
			items: _items.toSet()
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

	@override
	Widget build(BuildContext context) => _buildDropDown(context);

	void redraw(List<String>? values, [String? selected]){
		setState((){
			if(values != null) _items = values;
			selectedValue = selected ?? _items.firstOrNull;
		});
	}
}