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
	bool verbose;
	bool isSecured;
	Map <String, dynamic>? query;
	Map<String, String>? headers;
	List<int>? expectedStatusCodes; // anticipate successful response
	int? timeout;
	Function? onTimeout;

	String? _now;
	String? _uri;
	int? _statusCode;
	final int ok = 200;
	String contentType;

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
			this.timeout,
			this.onTimeout
		}){
		
		if(expectedStatusCodes != null){
			if(!expectedStatusCodes!.contains(ok)){
				expectedStatusCodes!.add(ok);
			}
		}  else {
			expectedStatusCodes = [ok];
		}
		_now = DateTime.now().toString();
	}

	String? get uri => _uri;
	int? get statusCode => _statusCode;

	Uri httpUri (String method){
		Uri uri;
		if(query != null && method == 'GET'){	
			Map<String, String> _query = query!.cast<String, String>();
			uri = Uri.http('$serverIp:$serverPort', path, _query);
		} else {
			uri = Uri.http('$serverIp:$serverPort', path);
		}

		return uri;
	}

	Uri httpsUri (String method){
		Uri uri;
		if(query != null && method == 'GET'){
			Map<String, String> _query = query!.cast<String, String>();	
			uri = Uri.https('$serverIp:$serverPort', path, _query);
		} else {
			uri = Uri.https('$serverIp:$serverPort', path);
		}
		return uri;
	}


	Future<dynamic> getResponse({String method='POST', Map<String, String>? multipartInfo, Map<String, String>? files}) async {
		
		Future? responseFuture;
		bool isStreamedResponse = false;

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
			_headers.addAll(headers!);
		}
		
		switch(method){
			case 'POST': {
				if(multipartInfo != null || files != null){
					var request = http.MultipartRequest('POST', uri);
					_headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
					request.headers.addAll(_headers);
					request.fields.addAll(multipartInfo != null ? multipartInfo : <String, String>{});
					if(query != null){
						Map<String, String> _query = query!.map((key, value) => MapEntry(key, value.toString()));
						request.fields.addAll(_query);
					}

					if(files != null){
						files.forEach((String fileName, String filePath) async {
							var file = await http.MultipartFile.fromPath(
								fileName,
								filePath
							);
							request.files.add(file);
						});
					}

					isStreamedResponse = true;
					responseFuture = request.send();
				} else {
					responseFuture = http.post(
						uri,
						headers: _headers,
						body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
					);
				}

				break;
			}

			case 'GET': {
				responseFuture = http.get(uri, headers: _headers);
				break;
			}

			case 'PUT': {
				responseFuture = http.put(
					uri,
					headers: _headers,
					body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
				);
				break;
			}

			case 'DELETE': {
				responseFuture = http.delete(
					uri,
					headers: _headers,
					body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
				);
				break;
			}
		}

		FutureOr<http.Response> Function() _onTimeoutResponse = (){
			if(onTimeout != null){
				onTimeout!();
			} else {
				throw TimeoutException('[$_uri]Connection timed out, current timeout is set to $timeout, try increasing the timeout or proof check your internet connection / resource availability. Set a onTimeout callback for such scenarios when creating your aqua.Client object');
			}
			return Future.value(http.Response(
				method,
				HttpStatus.gatewayTimeout
			));
		};

		FutureOr<http.StreamedResponse> Function() _onTimeoutStreamedResponse = (){
			if(onTimeout != null){
				onTimeout!();
			} else {
				throw TimeoutException('[$_uri]Connection timed out, current timeout is set to $timeout, try increasing the timeout or proof check your internet connection / resource availability. Set a onTimeout callback for such scenarios when creating your aqua.Client object');
			}
			Stream<List<int>> stream = Stream.empty();
			return Future.value(http.StreamedResponse(
				stream,
				HttpStatus.gatewayTimeout
			));
		};

		var bodyStr;
		Completer<dynamic> completer = Completer();
		if(responseFuture != null){
			if(timeout != null){
				responseFuture.timeout(Duration(milliseconds: timeout!), onTimeout: isStreamedResponse ? _onTimeoutStreamedResponse : _onTimeoutResponse);
			}
			responseFuture.then((_res) async {
				if(_res != null){
					if(_res is http.StreamedResponse){
						bodyStr = await _res.stream.bytesToString();
					} else {
						bodyStr = _res.body;
					}

					if(verbose){
						await pretifyOutput('[$_now][SERVER RESPONSE][${_res.statusCode}] $bodyStr');
					}

					_statusCode = _res.statusCode;
					if(expectedStatusCodes!.contains(_statusCode)){
						// thoughts
						// we are using contain because the full header could return 
						// e.g 'application/json; charset=utf-8
						if(_res.headers['content-type'].contains('application/json')){
							// return jsonDecode(bodyStr);
							completer.complete(jsonDecode(bodyStr));
						} else {
							completer.complete(bodyStr);
						}
					}
				} else {
					completer.complete(null);
				}
			}, onError: (error){
				if(verbose){
					pretifyOutput('error: ${error.toString()}', color: AqColor.red);
				}
				completer.complete(null);
			});
			return completer.future;
		}
	}

	Future<Uint8List?> downloadBinary(String filePath, {String method='POST', String size='small', StreamController<double>? controller}) async {
		var uri;
		var file;
		Uint8List? binary;
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
							var downloadProgress = received / length!;
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