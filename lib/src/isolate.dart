import 'dart:async';
import 'dart:isolate';

import 'output.dart';

Future<Map<String, dynamic>> initIsolate(
	String name,
	Function(List<Object?>) callback,
	{
		Function? onListenCallback,
		List<dynamic>? callbackArgs,
		bool verbose=false
	}) async {

	Isolate isolate;
	var isolateName = 'Isolate $name';
	var completer = Completer<Map<String, dynamic>>();
	var isolateToMainStream = ReceivePort();
	var isolateParts = <String, dynamic>{};

	isolate = await Isolate.spawn(callback, [isolateName, isolateToMainStream.sendPort, callbackArgs]);
	isolateParts['isolate'] = isolate;
	isolateParts['receiver'] = isolateToMainStream;
	// isolateParts['isolateToMainStreamPort'] = isolateToMainStream;

	String header = '[$isolateName]';

	if(verbose){
		pretifyOutput('$header ----- started ---- ', color: 'cyan');
	}

	isolateToMainStream.listen((data) async {


		if(data is SendPort){
			isolateParts['sendPort'] = data;
			completer.complete(isolateParts);
		} else if(data == 'done'){
			isolateToMainStream.close();
			if(verbose){
				pretifyOutput('[$isolateName] ------ ended -----', color: 'red');
			}
		} else {
			if(verbose){
				pretifyOutput('$header: $data');
			}
			
			if(onListenCallback != null){
				await onListenCallback(isolateToMainStream, data);
			}
			// onListenCallback ?? await onListenCallback(data);
		}
	});

	return completer.future;
}

// please note
// so that you complete the future return value from the initIsolate async function, you will have to send SendPort value from the child back to the parent at this location. So that "completer.complete(isolateParts)" completes and returns a value. Otherwise it will hang or return a future/null which breaks code without throwing an exception