import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
	static Future<dynamic> get(String key) async {
		SharedPreferences pref = await SharedPreferences.getInstance();
		dynamic value =  pref.get(key);
		if(value != null){
			return jsonDecode(value);
		} else {
			return value;
		}
	}

	static Future<dynamic> set(String key, dynamic value) async {
		String?_value = jsonEncode(value);
		SharedPreferences pref = await SharedPreferences.getInstance();
		return await pref.setString(key, _value);
	}

	static Future<bool> remove(String key) async {
		SharedPreferences pref = await SharedPreferences.getInstance();
		return await pref.remove(key);
	}
}