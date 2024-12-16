import 'dart:async';
import 'package:aqua/aqua.dart' as aqua;

Future<void> delay(int milliseconds,
    {Function? callback, bool verbose = false}) async {
  await Future.delayed(Duration(milliseconds: milliseconds));
  if (callback != null) {
    await aqua.tryCatch(callback, verbose: verbose);
  }
}
