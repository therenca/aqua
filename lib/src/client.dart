import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'output.dart';

class Client {

	String serverIp;
	int serverPort;
	String path;
	Map <String, dynamic>query;
	String method;
	bool isSecured;
	bool verbose;
	bool json;
	Map<String, String> headers;
	String _now;
	final int ok = 200;

	final String header = '[CLIENT]';

	Client(
		this.serverIp,
		this.serverPort,
		this.path,{
			this.query,
			this.json=true,
			this.verbose=false,
			this.isSecured=false,
			this.headers
		}){

		_now = DateTime.now().toString();
	}

	Uri httpUri (String method){
		Uri uri;
		if(query != null && method == 'GET'){	
			Map<String, String> _query = query.cast<String, String>();
			uri = Uri.http('$serverIp:$serverPort', path, _query);
		} else {
			uri = Uri.http('$serverIp:$serverPort', path);
		}

		return uri;
	}

	Uri httpsUri (String method){
		Uri uri;
		if(query != null && method == 'GET'){
			Map<String, String> _query = query.cast<String, String>();	
			uri = Uri.https('$serverIp:$serverPort', path, _query);
		} else {
			uri = Uri.https('$serverIp:$serverPort', path);
		}
		return uri;
	}

	Future<dynamic> getResponse({String method='POST'}) async {
		
		String error;
		http.Response response;

		var uri;
		if(isSecured){
			uri = httpsUri(method);
		} else {
			uri = httpUri(method);
		}
		if(verbose){
			pretifyOutput('[$_now][$method] $uri');
		}

		var _headers = {HttpHeaders.contentTypeHeader: 'application/json'};
		if(headers != null){
			_headers.addAll(headers);
		}
		
		switch(method){
			case 'POST': {
				try {
					response = await http.post(
						uri.toString(),
						headers: _headers,
						body: jsonEncode(query),
					);
				} catch(e){
					error = e.toString();
				}

				break;
			}

			case 'GET': {
				
				try {
					response = await http.get(uri.toString(), headers: _headers);
				} catch(e){
					error = e.toString();
				}
				break;
			}

			case 'PUT': {
				try{
					response = await http.put(
						uri.toString(),
						headers: _headers,
						body: jsonEncode(query)
					);
				} catch(e){
					error = e.toString();
				}

				break;
			}

		}

		if(verbose){
			if(error != null){
				pretifyOutput('[$_now][HTTP ERROR] $error', color: 'red');
				return;
			} else {
				pretifyOutput('[$_now][SERVER RESPONSE][${response.statusCode}] ${response.body}');
			}

		}

		if(response!= null && response.statusCode == ok){
			if(json){
				return jsonDecode(response.body);
			} else {
				return response.body;
			}
		} else {
			return {
				'body': response.body,
				'statusCode': response.statusCode
			};
		}
	}
}