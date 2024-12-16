import 'dart:async';
import 'output.dart';

Future<dynamic> tryCatch(dynamic callback,
    {List<dynamic>? args,
    bool verbose = false,
    dynamic onError,
    String? tag}) async {
  Completer completer = Completer<dynamic>();

  var results;
  try {
    if (callback is Future) {
      results = await callback;
    }

    if (callback is Function) {
      if (args != null) {
        results = callback(args);
      } else {
        results = callback();
      }
    }
  } catch (e) {
    results = null;
    if (verbose) {
      pretifyOutput('${tag != null ? [tag] : ''}[TRY CATCH] ${e.toString()}',
          color: AqColor.red);
    }

    if (onError != null) {
      if (onError is Future) {
        await onError;
      }

      if (onError is Function) {
        onError();
      }
    }
  }
  completer.complete(results);
  return completer.future;
}
