import 'delay.dart';
import 'output.dart';

class Timeout {
	static Future<dynamic> until(int retries, Function callback, {int? milliseconds, bool verbose=true}) async {
		int count = 0;
		dynamic value = await callback();
		while(retries == 0 ||(count < retries && value == null)){
			if(verbose){
				pretifyOutput('[${count+1}/$retries] $value', color: AqColor.cyann);
			}
			value = await callback();
			if(value == null){
				await delay(milliseconds ?? 1000);
				count++;
			} else {
				break;
			}
		}

		if(verbose){
				pretifyOutput('[${count+1}/$retries][DONE]$value');
			}
		return value;
	}
}