import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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
	Map<String, String> headers;
	String _now;
	final int ok = 200;
	List<int> expectedStatusCodes; // anticipate successful response
	String contentType;

	int _statusCode;
	String _uri;

	final String header = '[CLIENT]';

	Client(
		this.serverIp,
		this.serverPort,
		this.path,{
			this.query,
			this.verbose=false,
			this.isSecured=false,
			this.headers,
			this.expectedStatusCodes,
			this.contentType='application/json',
		}){
		
		if(expectedStatusCodes != null){
			if(!expectedStatusCodes.contains(ok)){
				expectedStatusCodes.add(ok);
			}
		}  else {
			expectedStatusCodes = [ok];
		}
		_now = DateTime.now().toString();
	}

	String get uri => _uri;
	int get statusCode => _statusCode;

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

	Future<dynamic> getResponse({String method='POST', Map<String, String> multipartInfo, Map<String, String> files}) async {
		
		String error;
		// http.Response response;
		var response;

		var uri;
		if(isSecured){
			uri = httpsUri(method);
		} else {
			uri = httpUri(method);
		}
		
		_uri = uri.toString();
		if(verbose){
			pretifyOutput('[$_now][$method] $uri');
		}

		var _headers = {HttpHeaders.contentTypeHeader: contentType};
		if(headers != null){
			_headers.addAll(headers);
		}
		
		switch(method){
			case 'POST': {
				try {
					if(multipartInfo != null || files != null){
						var request = http.MultipartRequest('POST', uri);
						request.fields.addAll(multipartInfo != null ? multipartInfo : <String, String>{});

						if(files != null){
							files.forEach((String fileName, String filePath) async {
								var file = await http.MultipartFile.fromPath(
									fileName,
									filePath
								);
								request.files.add(file);
							});
						}

						response = await request.send();
						
					} else {

						response = await http.post(
							uri,
							headers: _headers,
							body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
						);
					}
				} catch(e){
					error = e.toString();
				}

				break;
			}

			case 'GET': {
				
				try {
					response = await http.get(uri, headers: _headers);
				} catch(e){
					error = e.toString();
				}
				break;
			}

			case 'PUT': {
				try{
					response = await http.put(
						uri,
						headers: _headers,
						body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
					);
				} catch(e){
					error = e.toString();
				}

				break;
			}
		}

		var bodyStr;
		if(response != null){

			if(response is http.StreamedResponse){
				bodyStr = await response.stream.bytesToString();
			} else {
				bodyStr = response.body;
			}

			if(verbose){
				if(error != null){
					pretifyOutput('[$_now][HTTP ERROR] $error', color: 'red');
					return;
				} else {
					await pretifyOutput('[$_now][SERVER RESPONSE][${response.statusCode}] $bodyStr');
				}
			}

			_statusCode = response.statusCode;
			if(expectedStatusCodes.contains(_statusCode)){
				// thoughts
				// we are using contain because the full header could return 
				// e.g 'application/json; charset=utf-8
				if(response.headers['content-type'].contains('application/json')){
					return jsonDecode(bodyStr);
				} else {
					return bodyStr;
				}
			}
		}
	}

	Future<Uint8List> downloadBinary(String filePath, {String method='POST', String size='small', StreamController<double> controller}) async {
		var uri;
		var file;
		Uint8List binary;
		if(isSecured){
			uri = httpsUri(method);
		} else {
			uri = httpUri(method);
		}

		_uri = uri.toString();
		var client = http.Client();
		var request = http.Request(method, uri);
		http.StreamedResponse response = await client.send(request);
		_statusCode = response.statusCode;

		if(filePath.isNotEmpty){
			file = await File(filePath).create();
		}

		switch(size){

			case 'small': {
				binary =  await response.stream.toBytes();
				file != null ? await file.writeAsBytes(binary) : file = null;
				break;
			}

			case 'large': {

				if(filePath.isNotEmpty){

					var received = 0;
					var length = response.contentLength;
					
					var sink = file.openWrite();
					List<int> fullBytes = [];
					await response.stream.map((List<int> bytes){
						received += bytes.length;
						fullBytes += bytes;

						if(verbose){
							pretifyOutput('[DOWNLOAD | $size] $received / $length');
						}

						if(controller != null){
							var downloadProgress = received / length;
							controller.sink.add(downloadProgress);

							if(length == received){
								controller.close();
							}
						}

						return bytes;
					}).pipe(sink);

					sink.close();
					binary = Uint8List.fromList(fullBytes);
				}

				break;
			}
		}

		return binary;
	}
}