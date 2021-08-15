import 'package:flutter/material.dart';

class Shadow extends StatelessWidget {

	final double top;
	final double left;
	final double right;
	final Widget? child;
	final double bottom;
	final double? borderRadius;

	final Alignment? end;
	final Alignment? begin;

	final List<Color>? colors;

	Shadow({
		this.child,
		this.borderRadius,
		this.end, this.begin,
		this.top=0.0, this.left=0.0, this.right=0.0, this.bottom=0.0, this.colors});

	Widget _buildShadow(BuildContext context){
		return Container(
			child: Stack(
				children: [
					child != null ? child! : Container(),
					Positioned(
						top: top,
						left: left,
						right: right,
						bottom: bottom,
						child: Container(
							decoration: BoxDecoration(
								borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
								gradient: LinearGradient(
									colors: colors == null ? <Color>[
										Colors.transparent,
										Colors.black
									] : colors!,
									begin: begin == null ? Alignment.topCenter : begin!,
									end: end == null ? Alignment.bottomCenter: end!
								)
							),
						),
					)
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildShadow(context);

}