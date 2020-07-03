import 'output.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as websocketStatus;

class WebsocketHandler {
	bool _verbose;
	bool isConnected;
	bool isPiped;
	String username;
	Function _callback;
	String channelName;
	String channelToken;
	String websocketUrl;
	IOWebSocketChannel _channel;

	WebsocketHandler({
		this.websocketUrl,
		this.channelName,
		@required this.username,
		this.isPiped=false,
		callback,
		verbose }):
		_callback = callback, _verbose = verbose;

	// setters
	// set websocketUrl(String websocketUrl) => _websocketUrl = websocketUrl;
	// set callback(Function callback) => _callback = callback;
	// set verbose(bool verbose) => _verbose = verbose;
	// set channelName(String channelName) => _channelName = channelName;

	void connect(){
		Map<String, dynamic> _identification = {
			'type': 'identification',
			'message': username,
			'isPiped': isPiped
		};

		try {
			_channel = IOWebSocketChannel.connect(websocketUrl);
			isConnected = true;
		} catch(error){
			isConnected = false;
			formatError('[WEBSOCKET] while connecting to $websocketUrl', error: error.toString());
		}

		if(isConnected){
			send(jsonEncode(_identification));
			listen();			
		}
	}

	void listen(){
		_channel.stream.listen((dynamic data){
			bool isDecoded;
			Map<String, dynamic> decodedData;

			if(_verbose){
				pretifyOutput('[WEBSOCKET | ${channelName.toUpperCase()} | INCOMING] $data');
			}

			try {
				decodedData = jsonDecode(data);
				isDecoded = true;
			} catch(error){
				formatError('[WEBSOCKETS] while decoding data from channel $channelName', error: error.toString());
				isDecoded = false;
			}

			if(isDecoded){
				_recieveWebsocketResponse(decodedData);
			}
		});
	}

	void send(dynamic data){
		try{
			_channel.sink.add(data);
		} catch(error){
			formatError('[WEBSOCKET | ${channelName.toUpperCase()} | $username]', error: error.toString());
		}
	}

	void close(){
		_channel.sink.close();
		isConnected = false;
	}

	void _recieveWebsocketResponse(Map<String, dynamic> data){

		String responseType = data['type'];
		String responseMode = data['mode'];

		// thoughts
		// only structured data from the server can have an automatic 
		// reply from the client, with unstructrued data, a reply has
		// to be initiated manually from the client or triggered by an
		// action from the client side

		switch(responseMode){
			case 'structured':
				switch(responseType){
					case 'identification':
						channelToken = data['token'];
						break;
				}
				break;

			case 'unstructured':
				if(_callback == null){
					pretifyOutput('[WEBSOCKET] No callback added, payload: ${data['payload']}');
				} else {
					_callback(data['payload']);
				}
				break;
		}
	}

	void replaceCallback(Function newCallback){
		this._callback = newCallback;
	}
}