import 'package:colorize/colorize.dart';

void formatError(String info, {String error=''}){

	Colorize errorInfo = Colorize('$info: $error');
	errorInfo.red();
	// errorInfo.bgWhite();
	errorInfo.blink();
	// errorInfo.apply();

	print(errorInfo);

}

void pretifyOutput(String info, {String color=''}){

	Colorize toPretify = Colorize(info);

	switch(color){

		case 'white': {
			toPretify.white();
		}
		break;

		case 'red': {
			toPretify.red();
		}
		break;

		case 'yellow': {
			toPretify.yellow();
		}
		break;

		default: {
			toPretify.green();
		}
		break;
	}

	print(toPretify);

}