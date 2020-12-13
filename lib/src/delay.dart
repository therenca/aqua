import 'dart:async';

void delay(int milliseconds, Function callback){
	Future.delayed(Duration(milliseconds: milliseconds), (){
		callback();
	});
}