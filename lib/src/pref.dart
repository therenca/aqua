import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {

	static dynamic get(String key) async {
		SharedPreferences pref = await SharedPreferences.getInstance();
		dynamic value = await pref.get(key);
		if(value != null){
			return jsonDecode(value);
		} else {
			return value;
		}
	}

	static dynamic set(String key, dynamic value) async {
		String _value = jsonEncode(value);
		SharedPreferences pref = await SharedPreferences.getInstance();
		return await pref.setString(key, _value);
	}

}