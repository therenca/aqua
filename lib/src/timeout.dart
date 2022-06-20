import 'delay.dart';
import 'output.dart';

class Timeout {
	static Future<dynamic> until(int retries, Future future, {int? milliseconds, bool verbose=true}) async {
		int count = 0;
		dynamic value = await future;
		while(count < retries && value == null){
			if(verbose){
				pretifyOutput('[${count+1}/$retries] $value', color: AqColor.cyann);
			}
			value = await future;
			if(value == null){
				await delay(milliseconds ?? 3000);
				count++;
			}
		}

		if(verbose){
				pretifyOutput('[${count+1}/$retries][DONE]$value');
			}
		return value;
	}
}