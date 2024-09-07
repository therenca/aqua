import 'package:flutter/material.dart';

class DynamicDimensions extends StatelessWidget {
  final bool withColumn;
	final Function renderWidget;

	DynamicDimensions({
		required this.renderWidget,
    this.withColumn=true
	});

	@override
	Widget build(BuildContext context){
		return withColumn ? Column(
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
		) : Expanded(
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
    );
	}
}