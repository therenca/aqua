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
		}){
		
		query ??= {};
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

	Uri httpUri (Method method){
		Uri? uri;
		if(query != null && method == Method.GET){	
			Map<String, String> _query = query?.map<String,String>((k,v) => MapEntry(k, v as String)) ?? <String,String>{};
			if(query!.isNotEmpty) uri = Uri.http('$serverIp:$serverPort', path, _query);
			if(query!.isEmpty) uri = Uri.http('$serverIp:$serverPort', path);
		} else {
			uri = Uri.http('$serverIp:$serverPort', path);
		}

		return uri!;
	}

	Uri httpsUri (Method method){
		Uri? uri;
		if(query != null && method == Method.GET){
			Map<String, String> _query = query!.cast<String, String>();
			if(query!.isNotEmpty) uri = Uri.https('$serverIp:$serverPort', path, _query);
			if(query!.isEmpty) uri = Uri.https('$serverIp:$serverPort', path);
		} else {
			uri = Uri.https('$serverIp:$serverPort', path);
		}
		return uri!;
	}


	Future<dynamic> getResponse({Method method=Method.POST, Map<String, String>? multipartInfo, Map<String, String>? files}) async {
		var uri;
		Future? responseFuture;
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
			case Method.POST: {
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

			case Method.GET: {
				responseFuture = http.get(uri, headers: _headers);
				break;
			}

			case Method.PUT: {
				responseFuture = http.put(
					uri,
					headers: _headers,
					body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
				);
				break;
			}

			case Method.DELETE: {
				responseFuture = http.delete(
					uri,
					headers: _headers,
					body: contentType == 'application/x-www-form-urlencoded' ? query : jsonEncode(query),
				);
				break;
			}
		}

		var bodyStr;
		Completer<dynamic> completer = Completer();
		Future<dynamic> _parseResponse(dynamic _res) async {
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
					// we are using contain because the full header could return 
					// e.g 'application/json; charset=utf-8
					if(_res.headers['content-type'].contains('application/json')){
						// return jsonDecode(bodyStr);
						completer.complete(jsonDecode(bodyStr));
					} else {
						completer.complete(bodyStr);
					}
				} else {
					completer.complete(null);
				}
			} else {
				completer.complete(null);
			}
		}
		if(responseFuture != null){
			responseFuture.then((_res) async {
					return await _parseResponse(_res);
				}, onError: (error){
					if(verbose){
						pretifyOutput('error: ${error.toString()}', color: AqColor.red);
					}
					completer.complete(null);
				});
			return completer.future;
		}
	}

	Future<Uint8List?> downloadBinary(String filePath, {Size size=Size.small, StreamController<double>? controller}) async {
		var uri;
		File? file;
		Uint8List? binary;
		Method method = Method.GET;
		if(isSecured){
			uri = httpsUri(method);
		} else {
			uri = httpUri(method);
		}

		_uri = uri.toString();
		if(verbose){
			pretifyOutput('[$_now][$method] $uri');
		}

		// there is a small delay as the client tries to determine the size of the large resource
		// total size of resource is needed to provide the download progress needed for ui rendition
		controller?.sink.add(0);

		var client = http.Client();
		var request = http.Request('get', uri);
		request.headers.addAll({
			HttpHeaders.contentTypeHeader: 'application/octet-stream',
			HttpHeaders.connectionHeader: 'keep-alive'
		});
		http.StreamedResponse streamedResponse = await client.send(request);
		switch(size){
			case Size.small: {
				binary =  await streamedResponse.stream.toBytes();
				client.close();
				break;
			}
			case Size.large: {
				try {
					int startByte = 0;
					int chunkSize = 1024 * 1024;
					int endByte = (startByte + chunkSize) - 1; 
					int contentLength = streamedResponse.contentLength!;
					var builder = BytesBuilder();
					client.close();
					while (true){
						var headers = {
							HttpHeaders.contentTypeHeader: 'application/octet-stream',
							HttpHeaders.rangeHeader: 'bytes=$startByte-$endByte',
							HttpHeaders.connectionHeader: 'keep-alive'
						};
						var response = await http.get(uri, headers: headers);
						var _statusCode = response.statusCode;
						if(_statusCode == 206){
							startByte = endByte + 1;
							endByte = (startByte + chunkSize) - 1;
							builder.add(response.bodyBytes);
							if(verbose) pretifyOutput('[$_uri][progress] $startByte / $contentLength}');
							var progress = startByte/contentLength;
							controller?.sink.add(progress);
						} else if(_statusCode == 416){
							controller?.close();
							break;
						}
					}
					binary = builder.toBytes();
				} catch(e){
					if(verbose) pretifyOutput('[error][progress] ${e.toString()}', color: AqColor.red);
					binary = null;
					controller?.close();
				}
				break;
			}
		}

		if(filePath.isNotEmpty){
			if(binary != null ){
				file = await File(filePath).create();
				await file.writeAsBytes(binary);
			}
		}

		return binary;
	}
}

enum Size {
	large,
	small,
}

enum Method {
  GET,
  POST,
  PUT,
  DELETE
}