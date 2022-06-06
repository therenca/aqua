import 'dart:async';
import 'dart:isolate';

import 'output.dart';

Future<SpawnedIsolate> initIsolate(
	String name,
	Function(List<Object?>) callback,
	{
		Function? onListenCallback,
		List<dynamic>? callbackArgs,
		bool verbose=false
	}) async {

	Isolate isolate;
	var isolateName = '[isolate][$name]';
	var completer = Completer<SpawnedIsolate>();
	var receivePort = ReceivePort();
	var isolateParts = <String, dynamic>{};

	isolate = await Isolate.spawn(callback, [isolateName, receivePort.sendPort, callbackArgs]);
	isolateParts['isolate'] = isolate;
	isolateParts['receiver'] = receivePort;
	if(verbose){
		pretifyOutput('$isolateName ----- started ---- ', color: Color.cyann);
	}

	receivePort.listen((data) async {


		if(data is SendPort){
			isolateParts['sendPort'] = data;
			completer.complete(SpawnedIsolate(
				isolate: isolate,
				sendPort: data,
				receivePort: receivePort
			));
		} else if(data == 'done'){
			receivePort.close();
			if(verbose){
				pretifyOutput('$isolateName ------ ended -----', color: Color.red);
			}
		} else {
			if(verbose){
				pretifyOutput('$isolateName: $data');
			}
			
			if(onListenCallback != null){
				await onListenCallback(receivePort, data);
			}
		}
	});

	return completer.future;
}

// please note
// so that you complete the future return value from the initIsolate async function, you will have to send SendPort value from the child back to the parent at this location. So that "completer.complete(isolateParts)" completes and returns a value. Otherwise it will hang or return a future/null which breaks code without throwing an exception

class SpawnedIsolate {
	Isolate isolate;
	ReceivePort receivePort;
	SendPort sendPort;

	SpawnedIsolate({
		required this.isolate,
		required this.receivePort,
		required this.sendPort
	});
}