import 'dart:async';
import 'package:colorize/colorize.dart';
import 'log.dart';

Future<void> pretifyOutput(String info,
	{
		AqColor color=AqColor.green, 
		AqColor? bgColor,
		String? path,
		bool clear=false,
		String? endLine,
	}) async {

	Colorize toPretify = Colorize(info);

	switch(color){
		case AqColor.white: {
			toPretify.white();
			break;
		}

		case AqColor.red: {
			toPretify.red();
			break;
		}

		case AqColor.yellow: {
			toPretify.yellow();
			break;
		}

		case AqColor.magenta: {
			toPretify.magenta();
			break;
		}

		case AqColor.cyann: {
			toPretify.cyan();
			break;
		}

		case AqColor.blue: {
			toPretify.blue();
			break;
		}

		case AqColor.green: {
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
			case AqColor.white: {
				toPretify.bgWhite();
				break;
			}

			case AqColor.red: {
				toPretify.bgRed();
				break;
			}

			case AqColor.yellow: {
				toPretify.bgYellow();
				break;
			}

			case AqColor.magenta: {
				toPretify.bgMagenta();
				break;
			}

			case AqColor.cyann: {
				toPretify.bgCyan();
				break;
			}

			case AqColor.blue: {
				toPretify.bgBlue();
				break;
			}

			case AqColor.green: {
				toPretify.bgGreen();
				break;
			}
		}
	}

	var end = endLine ?? '\n';
	// stdout.write('$toPretify$end');
	print('$toPretify$end');

	if(path != null){
		await log(info, path, clear: clear);
	}
}

enum AqColor {
	green,
	white,
	red,
	yellow,
	magenta,
	cyann,
	blue
}