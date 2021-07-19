import 'dart:async';
import 'output.dart';

Future<dynamic> tryCatch(dynamic callback, 
	{List<dynamic> args, bool verbose=false, dynamic onError}) async {
	Completer completer = Completer<dynamic>();

	var results;
	try {
		if(callback is Future){
			results = await callback;
		}

		if(callback is Function){
			if(args != null){
				results = callback(args);
			} else {
				results = callback();
			}
		}
	} catch(e){
		if(verbose){
			pretifyOutput('[TRY CATCH] ${e.toString()}', color: 'red');
		}

		if(onError != null){
			if(onError is Future){
				await onError;
			}

			if(onError is Function){
				onError();
			}
			
			onError();
		}
	}

	completer.complete(results);
	return completer.future;
}