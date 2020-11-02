# Aqua

Utility classes/functions to help with UI development using the Flutter framework.

It is recommended to use the `as` keyword with the `import` statement when importing the package to prevent name conflicts, for example...
> `import 'package:aqua/aqua.dart' as aqua`

To log output to file 
```dart
await aqua.log('data to log', logFile: 'path/to/file', clear: true, time: true);
```

To save data to device
```dart
Future<void> save() async {
	var id = 'id';
	var _value = 1920;
	await aqua.Pref.set(id, value);
	var value = await aqua.Pref.get(id);
}
```
To put a block of code in a try catch
```dart

// the argument for tryCatch could either be a callback to a function or a future

// as a function
Widget  _buildWidget(){
	// may fail to build for some reason
}
var child = await aqua.tryCatch(_buildWidget());

// as a future
Future<Widget> _buildWidget() async {
	// may fail to build for some reason
}

var future = _buildWidget();
var child = await aqua.tryCatch(future);


if(child != null){
	// proceed
}

```

When fetching data from server in json, or posting a query to server in json
```dart
// posting to an endpoint
var fromServer = await aqua.Client(
	'192.168.1.100', //ip
	8080, // port
	'/test', // endpoint
	query: {
		'id': 1,
	}, // post parameters
	// verbose: true
).getResponse();

// a real end point would look like this
// the end point is free to use
// you can find the rest of the endpoints here: https://www.coingecko.com/en/api
var fromServer = await aqua.Client(
	'api.coingecko.com',
	443,
	'/api/v3/coins/markets',
	isSecured: true,
	query: {
		'vs_currency': 'usd',
		'order': 'market_cap_desc',
		'per_page': '20',
		'page': '1',
		'sparkline': 'true'
	}
).getResponse(method: 'GET');
```

**`DESKTOP ONLY`** To allow for mouse pointers to change to click icons on hovering on a clickable widget
```dart
@override
Widget build(BuildContext context){
	
	// some code
	// then
	return aqua.MouseInteractivity(
		child: child
	);
}
```

To get a random index between a range of indexes
```dart
var index = aqua.getRandomNumber(min: 10, max: 10000);
```

To output info on screen with different colors
```dart

aqua.pretifyOutput('to print on screen'); // will print in green
aqua.pretifyOutput('to print on screen', color: 'red');
```

To add a shadowy effect on an image
```dart
@override
Widget build(BuildContext context){
	return Stack(
		children: [
			_buildImage(),
			aqua.Shadow(
				width: width,
				height: height,
			)
		]
	);
}
```

A quick drop down widget
```dart
@override
Widget build(BuildContext context){
	return aqua.DropDown(
		initValue: 'one',
		items: ['one', 'two', 'three', 'four', 'five', 'six']
	);
}
```

A quick TabBar. Tabs without scaffold...
```dart
@override
Widget build(BuildContext context){
	return Material(
		child: DefaultTabController(
			length: 3,
			child: Column(
				children: [
					aqua.TabHeader(
						tabListing: ['car', 'transit', 'bike'],
					),

					TabBarView(
						children: [
							Icon(Icons.directions_car),
							Icon(Icons.directions_transit),
							Icon(Icons.directions_bike),
						],
					),
				],
			),
		)
	);
}
```

To get screen dimensions in scale
```dart
@override
Widget build(BuildContext context){

	aqua.Dimensions().init(context);

	return Container(
		width: aqua.Dimensions.width, // full width of screen
		height: aqua.Dimensions.height, // full height of screen
		color: Colors.red
	);
}
```

To captilaize a word
```dart
var capitalized = aqua.capitalize('alphabet');
print('capitalized: $capitalized);
```

To create a file quickly (will also create the recursive directories on the path)
```dart
await aqua.createFile('/path/to/file');

// to clear a file/truncate a file
await aqua.createFile('/path/to/file', clear: true);
```
To generate a random ID
```dart
var id = aqua.generateUUID(length: 30);
```

To navigate
```dart

// some code
// then

aqua.Dimensions().init(context);
Widget viewOne = Container(
	width: aqua.Dimensions.width,
	height: aqua.Dimensions.height
	color: Colors.blue
);
Widget viewTwo = Container(
	width: aqua.Dimensions.width,
	height: aqua.Dimensions.height
	color: Colors.red
);

// to navigate to the next view without erasing the previous view from state
aqua.CustomNavigator(
	context: context,
	buildScreen: () = > viewOne
).navigateToPage();

// to navigate to the next view and erase the previous view from state
aqua.CustomNavigator(
	context: context,
	replaceSingle: true,
	buildScreen: () = > viewOne
).navigateToPage();

// to navigate to the next view and erase ALL the previous views from state
aqua.CustomNavigator(
	context: context,
	replaceAll: true,
	buildScreen: () = > viewOne
).navigateToPage();

// to navigate to the next view using a named route
aqua.CustomNavigator(
	context: context,
	namedRoute: '/home',
	buildScreen: () = > viewOne
).navigateToPage();
```

To display loading icon
```dart

// render this widget as you see fit
Widget loadingIcon = aqua.LoadingIcon();

// to specify a loading type: check the different loading icons at this location
// https://github.com/jogboms/flutter_spinkit

import 'package:flutter_spinkit/flutter_spinkit.dart' as spinkitt;

Widget loadingIcon = aqua.LoadingIcon(
	spinkitWidget: spinkitt.SpinKitWave(
		color: Colors.blue,
		size: 40.0,
	),
);
```

To request focus from another widget
```dart
@override
Widget build(BuildContext context){
	
	// some code
	// then
	Widget withFocus = aqua.requestFocus(child, context: context);

	// make sure to return a widget
}
```

To add commas to numbers
```dart
String number = aqua.pretifyNumber('1000000');
print('number: $number');
```

To clip images into a circular widget
```dart
@override
Widget build(BuildContext context){
	// some code
	// then
	Widget clippedImage = aqua.ClippedCircle(
		child: child // some widget, could be an image, wrapped in a container,
		color: Colors.blue // border of the circle
	);

	// make sure to return a widget
}
```

Custom Text Form Widget
```dart

class Play extends StatefulWidget {

	@override
	PlayState createState() => PlayState();

}

class PlayState extends State<Play>{

	FocusNode focusNode;
	TextEditingController textEditingController;

	@override
	void initState(){
		super.initState();

		focusNode = FocusNode();
		textEditingController = TextEditingController();
	}

	@override
	void dispose(){
		focusNode?.dispose();
		textEditingController?.dispose();

		super.dispose();
	}

	@override
	Widget build(BuildContext context){
		aqua.Dimensions().init(context);

		// more on this later ... 
		// check source code :)

		return SizedBox(
			width: aqua.Dimensions.width,
			height: 100.0,
			child: aqua.TextFormFieldCustom(
				isOutlineBorder: true, // or false
				focusNode: focusNode
				controller: textEditingController,
			)
		);
	}

}
```

**`DESKTOP ONLY`** Desktop Navigator, a bit of boilerplate code is needed for this to work ... 
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aqua/aqua.dart' as aqua;

class Shell extends StatefulWidget {

	@override
	ShellState createState() => ShellState();
}

class ShellState extends State<Shell>{

	Widget selectedWidget;
	aqua.NavigationStreamer mainNavStreamer;
	StreamSubscription mainNavStreamSubscription;

	@override
	void initState(){
		super.initState();
		mainNavStreamer = aqua.NavigationStreamer();

		mainNavStreamSubscription = mainNavStreamer.listen((data){
			aqua.pretifyOutput('[SHELL] data from nav stream: $data');

			selectedWidget = data['window'];
			setState((){});
		});
	}

	@override
	void dispose(){
		mainNavStreamSubscription.cancel();
		mainNavStreamer.close();
		super.dispose();
	}

	Widget _buildShell(BuildContext context){
		aqua.Dimensions().init(context);
		double navWidth = aqua.Dimensions.width * 0.15;
		double contentWindowWidth = aqua.Dimensions.width - navWidth;

		Map<String, Map<String, dynamic>> generatedRoutes = _buildGeneratedRoutes(
			contentWindowWidth,
			aqua.Dimensions.height
		);

		Widget firstWidget = Container(
			width: windowWidth,
			height: windowHeight,
			color: Colors.blue
		);

		return Scaffold(
			appBar: null,
			body: SingleChildScrollView(
				child: Container(
					child: Row(

						children: [

							aqua.Navigation(
								width: navWidth,
								height: aqua.Dimensions.height,
								header: Container(
									width: navWidth,
									height: 100.0,
									color: Colors.red
								),
								routes: generatedRoutes,
								bgColors: <Color>[
									Colors.blue
									Colors.blueAccent
								],
								hoverColor: Colors.brown.withOpacity(0.5),
								selectedColor: Colors.white.withOpacity(0.5),
								navStreamer: mainNavStreamer,
							),

							Container(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.start,
									children: [
										selectedWidget == null ? aqua.requestFocus(
											firstWidget,
											context: context
										) : aqua.requestFocus(
											selectedWidget,
											context: context
										)
									],
								),
							)
						]
					)
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) => _buildShell(context);

	Map<String, Map<String, dynamic>> _buildGeneratedRoutes(double windowWidth, double windowHeight){

		Function _buildIconHelper = (IconData iconData){
			return Icon(iconData, color: Colors.black, size: 15.0,);
		};

		return {
			'Home': {
				'window': Container(
					width: windowWidth,
					height: windowHeight,
					color: Colors.blue
				),
				'icon': _buildIconHelper(Icons.home)
			},
			'Search': {
				'window': Container(
					width: windowWidth,
					height: windowHeight,
				),
				'icon': _buildIconHelper(Icons.search)
			}
		};
	}
}
```