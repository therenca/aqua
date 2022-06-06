import 'dart:io';
import 'dart:async';
import 'package:colorize/colorize.dart';
import 'log.dart';

Future<void> pretifyOutput(String info,
	{
		Color color=Color.green, 
		Color? bgColor,
		String? path,
		bool clear=false,
		String? endLine,
	}) async {

	Colorize toPretify = Colorize(info);

	switch(color){
		case Color.white: {
			toPretify.white();
			break;
		}

		case Color.red: {
			toPretify.red();
			break;
		}

		case Color.yellow: {
			toPretify.yellow();
			break;
		}

		case Color.magenta: {
			toPretify.magenta();
			break;
		}

		case Color.cyann: {
			toPretify.cyan();
			break;
		}

		case Color.blue: {
			toPretify.blue();
			break;
		}

		case Color.green: {
			toPretify.green();
			break;
		}

		default: {
			toPretify.green();
			break;
		}
	}

	if(bgColor != null){
		switch(bgColor){
			case Color.white: {
				toPretify.bgWhite();
				break;
			}

			case Color.red: {
				toPretify.bgRed();
				break;
			}

			case Color.yellow: {
				toPretify.bgYellow();
				break;
			}

			case Color.magenta: {
				toPretify.bgMagenta();
				break;
			}

			case Color.cyann: {
				toPretify.bgCyan();
				break;
			}

			case Color.blue: {
				toPretify.bgBlue();
				break;
			}

			case Color.green: {
				toPretify.bgGreen();
				break;
			}
		}
	}

	var end = endLine ?? '\n';
	stdout.write('$toPretify$end');
	// print('$toPretify$end');

	if(path != null){
		await log(info, path, clear: clear);
	}
}

enum Color {
	green,
	white,
	red,
	yellow,
	magenta,
	cyann,
	blue
}