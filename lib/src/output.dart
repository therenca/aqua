import 'dart:io';
import 'dart:async';
import 'package:colorize/colorize.dart';
import 'log.dart';

Future<void> pretifyOutput(String info,
	{
		String color='', 
		String bgColor='',
		String path,
		bool clear=false,
		String endLine,
	}) async {

	Colorize toPretify = Colorize(info);

	switch(color){

		case 'white': {
			toPretify.white();
			break;
		}

		case 'red': {
			toPretify.red();
			break;
		}

		case 'yellow': {
			toPretify.yellow();
			break;
		}

		case 'magenta': {
			toPretify.magenta();
			break;
		}

		case 'cyan': {
			toPretify.cyan();
			break;
		}

		case 'blue': {
			toPretify.blue();
			break;
		}

		default: {
			toPretify.green();
			break;
		}
	}

	if(bgColor.isNotEmpty){

		switch(bgColor){

			case 'white': {
				toPretify.bgWhite();
				break;
			}

			case 'red': {
				toPretify.bgRed();
				break;
			}

			case 'yellow': {
				toPretify.bgYellow();
				break;
			}

			case 'magenta': {
				toPretify.bgMagenta();
				break;
			}

			case 'cyan': {
				toPretify.bgCyan();
				break;
			}

			case 'blue': {
				toPretify.bgBlue();
				break;
			}
		}
	}

	var end = endLine ?? '\n';
	// stdout.write('$toPretify$end');
	print('$toPretify$end');

	if(path != null){
		await log(info, logFile: path, clear: clear);
	}
}