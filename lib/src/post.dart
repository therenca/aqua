import 'dart:async';
import 'output.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> postToServer(String url, Map data, Function callback, {bool verbose=false}) async {
	http.Response response;
	bool isSuccessful;
	try{
		response = await http.post(url, body: data);
		isSuccessful = true;
	} catch(error){
		isSuccessful = false;
		formatError('while fetching from post', error: error.toString());
	}

	if(isSuccessful){
		dynamic decodedResponse;
		if(verbose)
			pretifyOutput('POST RESPONSE: ${response.body}', color: 'green');

		try{
			decodedResponse = jsonDecode(response.body);
		} catch(error){
			formatError('while trying to decode response from server: ', error: error.toString());
			return false;
		}

		await callback(decodedResponse);

		return isSuccessful;
		
	} else {
		return false;
	}
}