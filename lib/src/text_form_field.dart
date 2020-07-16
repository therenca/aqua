import 'package:flutter/material.dart';

class  TextFormFieldCustom extends StatelessWidget {

	final Widget prefix;
	final Widget prefixIcon;
	final Widget suffixIcon;
	final dynamic beforeInput;
	final double fontSize;
	final Color textColor;
	final Color hintColor;
	final Color labelColor;
	final Color borderColor;
	final Color focusedBorderColor;
	final double borderWidth;
	final double focusBorderWidth;
	final double borderRadius;
	final String labelText;
	final String hintText;

	final bool isOutlineBorder;
	final bool isObscureText;

	final int maxLines;
	final double verticalPadding;
	final double horizontalPadding;
	final TextInputType keyboardType;
	
	final Function onChanged;
	final Function validator;
	final Function onSubmitted;

	final FocusNode focusNode;
	final TextInputAction textInputAction;
	final TextEditingController controller;

	final TextStyle hintTextStyle;
	final TextStyle labelTextStyle;

	final bool isFilled;
	final Color filledColor;

	TextFormFieldCustom({
		this.prefixIcon,
		this.suffixIcon,
		this.beforeInput,
		this.fontSize=13.0,
		this.textColor=Colors.black,
		this.hintColor=Colors.black,
		this.labelColor=Colors.black,
		this.borderColor=Colors.black,
		this.focusedBorderColor=Colors.black,
		this.borderWidth=2.0,
		this.focusBorderWidth=2.0,
		this.borderRadius=4.0,
		this.labelText='',
		this.hintText='',
		this.prefix,
		this.isOutlineBorder=false,
		this.isObscureText=false,
		this.maxLines=1,
		this.verticalPadding=25.0,
		this.horizontalPadding=10.0,
		this.keyboardType=TextInputType.text,
		this.validator,
		this.onSubmitted,
		this.onChanged,
		this.focusNode,
		this.textInputAction,
		this.controller,
		this.hintTextStyle,
		this.labelTextStyle,
		this.isFilled=false,
		this.filledColor
	});

	Widget _buildTextFormField(BuildContext context){

		BorderSide borderSide = BorderSide(
			width: borderWidth,
			color: borderColor
		);

		BorderSide focusedBorderSide = BorderSide(
			width: focusBorderWidth,
			color: focusedBorderColor
		);

		return TextFormField(
			style: TextStyle(
				fontSize: fontSize,
				color: textColor
			),
			keyboardType: keyboardType,
			obscureText: isObscureText,
			validator: (inputValue) => validator(inputValue),
			maxLines: maxLines,
			controller: controller,
			focusNode: focusNode,
			textInputAction: textInputAction,
			onFieldSubmitted: (inputValue) => onSubmitted(inputValue),
			decoration: InputDecoration(
				icon: beforeInput,
				enabledBorder: isOutlineBorder ? OutlineInputBorder(
					borderSide: borderSide,
					borderRadius: BorderRadius.circular(borderRadius)
				) : UnderlineInputBorder(
					borderSide: borderSide,
				),
				focusedBorder: isOutlineBorder ? OutlineInputBorder(
					borderSide: focusedBorderSide,
					borderRadius: BorderRadius.circular(borderRadius)
				) : UnderlineInputBorder(
					borderSide: focusedBorderSide
				),
				contentPadding: EdgeInsets.symmetric(
					vertical: verticalPadding,
					horizontal: horizontalPadding
				),
				labelText: labelText,
				labelStyle: labelTextStyle,
				hintText: hintText,
				hintStyle: hintTextStyle,
				prefix: prefix,
				prefixIcon: prefixIcon,
				suffixIcon: suffixIcon,
				filled: isFilled,
				fillColor: filledColor
			),
			onChanged: onChanged,
		);
	}

	@override
	Widget build(BuildContext context) => _buildTextFormField(context);

}

// thoughts
// when the TextInputAction variable is initialized, there has to be an 
// onFieldSubmitted callback too