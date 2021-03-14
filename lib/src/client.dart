import 'dart:io';
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
	bool json;
	Map<String, String> headers;
	String _now;
	final int ok = 200;
	List<int> expectedStatusCodes; // anticipate successful response

	int _statusCode;

	final String header = '[CLIENT]';

	Client(
		this.serverIp,
		this.serverPort,
		this.path,{
			this.query,
			this.json=true,
			this.verbose=false,
			this.isSecured=false,
			this.headers,
			this.expectedStatusCodes
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
							body: jsonEncode(query),
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
						body: jsonEncode(query)
					);
				} catch(e){
					error = e.toString();
				}

				break;
			}
		}

		var isFormData = multipartInfo != null || files != null ? true : false;
		if(verbose){
			if(error != null){
				pretifyOutput('[$_now][HTTP ERROR] $error', color: 'red');
				return;
			} else {
				pretifyOutput('[$_now][SERVER RESPONSE][${response.statusCode}]', endLine: isFormData ? '\n' : ' ');
				if(!isFormData){
					pretifyOutput('${response.body}');
				}
			}
		}

		if(response != null){
			_statusCode = response.statusCode;
			if(expectedStatusCodes.contains(_statusCode)){
				if(json){
					if(!isFormData){
						return jsonDecode(response.body);
					}
				} else {
					if(!isFormData){
						return response.body;
					}
				}
			}
		}
	}

	Future<Uint8List> downloadBinary({String method='POST', String size='small', String path}) async {
		var uri;
		Uint8List binary;
		if(isSecured){
			uri = httpsUri(method);
		} else {
			uri = httpUri(method);
		}

		var client = http.Client();
		var request = http.Request(method, uri);
		http.StreamedResponse response = await client.send(request);

		switch(size){

			case 'small': {
				binary =  await response.stream.toBytes();
				if(path != null){
					var file = File(path);
					await file.writeAsBytes(binary);
				}
				break;
			}

			case 'large': {

				var length = response.contentLength;
				var received = 0;

				var file = File(path);
				var sink = file.openWrite();
				List<int> fullBytes = [];
				await response.stream.map((List<int> bytes){
					received += bytes.length;
					fullBytes += bytes;

					if(verbose){
						pretifyOutput('[DOWNLOAD | $size] $received / $length');
					}

					return bytes;
				}).pipe(sink);

				sink.close();
				binary = Uint8List.fromList(fullBytes);

				break;
			}
		}

		return binary;
	}
}