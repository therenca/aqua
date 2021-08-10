import 'package:flutter/material.dart';

class DynamicDimensions extends StatelessWidget {

	final Function renderWidget;

	DynamicDimensions({
		required this.renderWidget
	});

	@override
	Widget build(BuildContext context){
		return Column(
			children: [
				Expanded(
					child: Row(
						children: [
							Expanded(
								child: LayoutBuilder(
									builder: (BuildContext context, BoxConstraints constraints){
										return renderWidget(
											constraints.maxWidth,
											constraints.maxHeight
										);
									},
								),
							),
						],
					),
				),
			],
		);
	}
}