
import 'dart:async';
import 'package:flutter/foundation.dart';

import 'output.dart';

class Streamer {
	bool verbose;
	String name;
	Function add;
	Function onData;

	Stream _stream;
	StreamController<dynamic> _controller;

	dynamic _data;
	
	Streamer({@required this.name, this.add, this.onData, this.verbose=false}){
		_controller = StreamController();
		_stream = _controller.stream.asBroadcastStream();
	}

	dynamic get data => _data;
	Stream get stream => _stream;
	StreamController get controller => _controller;

	void put(dynamic data){
		_data = data;

		if(add != null){
			_controller.sink.add(add());
		} else {
			_controller.sink.add(data);
		}
	}

	void listen(Stream streamOBJ, Function callback) => streamOBJ.listen(
		(data) {
			if(verbose) pretifyOutput('Streamer $name: Data: $data');
			callback(data);
		},
		onError: (error){
			pretifyOutput('Streamer $name threw error: ${error.toString()}', color: 'red');
		},
		cancelOnError: false,
		onDone: (){
			pretifyOutput('Streamer $name is Done');
		}
	);

	void close(){
		_controller.close();
	}
}