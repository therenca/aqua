import 'package:flutter/material.dart';
import 'package:aqua/aqua.dart' as aqua;

class SteppedProgress extends StatefulWidget {
	final List<String> steps;
	final double thickness;
	final double dashWidth;
	final int currentStep;
	final TextStyle textStyle;
	final EdgeInsets padding;
	const SteppedProgress({
		Key? key,
		required this.steps,
		required this.currentStep,
		this.thickness=3.0,
		this.dashWidth=6.0,
		this.textStyle=const TextStyle(
			fontSize: 13.0,
			color: Colors.black,
			fontWeight: FontWeight.bold
		),
		this.padding = const EdgeInsets.only(
			left: 20.0,
			right: 20.0
		)
	}) : super(key: key);

	@override
	State<SteppedProgress> createState() => _SteppedProgressState();
}

class _SteppedProgressState extends State<SteppedProgress> {
	GlobalKey parentKey = GlobalKey();
	bool isShowText = false;
	List<int> previousSteps = [];
	List<int> previousDottedSections = [];
	Map<int, GlobalKey> stepKeys = {};
	Map<int, int> plottedToReal = {};
	Map<int, int> realToPlotted = {};
	Map<int, GlobalKey> offstageKeys = {};

	double leftPadding = 0;
	double rightPadding = 0;

	List<Widget> stackChildren = [];

	@override
	void initState(){
		super.initState();

		List<int> temp = []; // same length as widgets.steps
		List.generate(_getTotalSteps(), (index){
			index = index+1;
			var isEven = index % 2 == 0;
			if(isEven == false){
				temp.add(index);
			}
		});

		for(var index=0; index<temp.length; index++){ // same length as widgets.steps
			stepKeys[temp[index]] = GlobalKey<_SteppedProgressState>();
			plottedToReal[temp[index]] = widget.steps.indexOf(widget.steps[index]) + 1;
			realToPlotted[index+1] = temp[index];
			offstageKeys[index] = GlobalKey<_SteppedProgressState>(); // first index = 0
		}

		// aqua.pretifyOutput('keys: $stepKeys');
		// aqua.pretifyOutput('plotted to real: $plottedToReal');
		// aqua.pretifyOutput('real to plotted: $realToPlotted');

		WidgetsBinding.instance!.addPostFrameCallback((_){
			offstageKeys.forEach((index, globalKey) {
				var textSize = _getWidgetSize(globalKey);
				var pointSize = _getWidgetSize(stepKeys[realToPlotted[index+1]]!);
				var pointOffset = _getWidgetOffset(stepKeys[realToPlotted[index+1]]!);
				var _width = (textSize.width - pointSize.width) / 2;
				Offset _offset = Offset(pointOffset.dx - _width, 0);

				Widget child = Positioned(
					top: _offset.dy,
					left: _offset.dx,
					child: Text(
						widget.steps[index],
						style: widget.textStyle
					)
				);

				stackChildren.add(child);
			});
			setState((){
				isShowText = true;
				leftPadding = _getWidgetSize(offstageKeys[0]!).width / 2;
				rightPadding = _getWidgetSize(offstageKeys[widget.steps.length-1]!).width / 2;
			});
		});
	}

	Widget _buildPoint(int index, int step, bool isHighlighted){		
		aqua.pretifyOutput('index: $index, step: $step');
		var innerSize = isHighlighted ? 12.0 : 8.0;
		// aqua.pretifyOutput('key: ${plottedToReal[index]} ==> ${widget.steps[plottedToReal[index]! -1]} ==> ${stepKeys[index]}');
		return Container(
			key: stepKeys[index],
			padding: EdgeInsets.all(isHighlighted ? 3.0: 2.0),
			decoration: BoxDecoration(
				color: Colors.white,
				shape: BoxShape.circle,
				border: Border.all(
					width: widget.thickness,
					color: isHighlighted ? Colors.orange : step > index ? Colors.green : Colors.grey
				)
			),
			child: Container(
				width: innerSize,
				height: innerSize,
				decoration: BoxDecoration(
					color: isHighlighted ? Colors.orange : step > index ? Colors.green : Colors.grey,
					shape: BoxShape.circle
				),
				child: step > index ? Icon(Icons.check, color: Colors.white, size: innerSize,) : Container()
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		int totalSteps = _getTotalSteps();
		return Column(
			key: parentKey,
			children: [
				Padding(
					padding: widget.padding,
					child: Row(
						children: List.generate(totalSteps, (index){
							index = index+1;
							var isEven = index % 2 == 0;
							var step = _getCurrentStep();
							var dottedStep = step + 1;
							if(isEven){
								bool isHighlighted = index == dottedStep;
								return Expanded(child: aqua.DottedLine(
										dashWidth: widget.dashWidth,
										dashHeight: widget.thickness,
										color: isHighlighted ? Colors.orange : dottedStep > index ? Colors.green : Colors.grey,
									),
								); 
							} else {
								return _buildPoint(index, step, step == index);
							}
						}),
					),
				),
				const SizedBox(height: 5.0,),
				Offstage(
					child: Row(
						children: List.generate(widget.steps.length, (index) => Container(
							key: offstageKeys[index],
							child: Text(
								widget.steps[index],
							),
						)),
					),
				),
				isShowText ? Row(
					children: [
						Expanded(
							child: SizedBox(
								height: 20.0,
								child: Stack(
									children: stackChildren,
								),
							),
						),
					],
				) : Container(),
			],
		);
	}

	int _getCurrentStep() => widget.currentStep == 1 ? 1 : widget.currentStep + (widget.currentStep-1);

	int _getTotalSteps() => (widget.steps.length * 2) - 1;

	Offset _getWidgetOffset(GlobalKey key){
		final parentBox = parentKey.currentContext!.findRenderObject() as RenderBox;
		var parentOffset = parentBox.localToGlobal(Offset.zero);
		var box = key.currentContext!.findRenderObject() as RenderBox;
		var offset = box.localToGlobal(Offset.zero);
		return Offset(offset.dx-parentOffset.dx, offset.dy-parentOffset.dy);
	}

	Size _getWidgetSize(GlobalKey key) => key.currentContext!.size!;
}