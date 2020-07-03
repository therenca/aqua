import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fonts extends StatelessWidget {

	final String text;
	final String name;
	final Color color;
	final double fontSize;
	final FontStyle fontStyle;
	final double letterSpacing;
	final FontWeight fontWeight;
	final TextDecoration decoration;


	Fonts({
		@required this.text,
		this.name='roboto',
		this.fontSize=15.0,
		this.letterSpacing=0.0,
		this.color=Colors.white,
		this.fontStyle=FontStyle.normal,
		this.fontWeight=FontWeight.normal,
		this.decoration=TextDecoration.none
	});

	TextStyle _selectFontStyle(){
		TextStyle textStyle;
		
		switch(name){

			case 'roboto':
				textStyle = GoogleFonts.roboto(
					color: color,
					fontSize: fontSize,
					fontStyle: fontStyle,
					fontWeight: fontWeight,
					decoration: decoration,
					letterSpacing: letterSpacing
				);

				break;
		}

		return textStyle;
	}

	Widget _buildFonts(BuildContext context){
		return Text(
			text,
			style: _selectFontStyle()
		);
	}

	@override
	Widget build(BuildContext context) => _buildFonts(context);

}