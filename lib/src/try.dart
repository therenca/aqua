import 'dart:async';
import 'output.dart';

Future<T?> tryCatch<T, T1>(Future<T> Function([T1?]) callback,
    {bool verbose = false,
    Future<void> Function()? onError,
    String? tag,
    T1? arg,
    String? path}) async {
  Completer<T> completer = Completer();
  T? results;
  try {
    results = await callback.call(arg);
  } catch (e) {
    if (verbose) {
      pretifyOutput('${tag != null ? [tag] : ''} ${e.toString()}',
          color: AqColor.red, path: path);
    }

    await onError?.call();
  }
  completer.complete(results);
  return completer.future;
}
