import 'dart:async';
import 'package:aqua/aqua.dart' as aqua;

void delay(int milliseconds, Function callback){
	Future.delayed(Duration(milliseconds: milliseconds), () async {
		// callback();
		await aqua.tryCatch(callback, verbose: false);
	});
}