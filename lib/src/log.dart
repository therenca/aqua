import 'dart:io';
import 'create_file.dart';

Future<void> log(String data, String logFile,
    {bool clear = false, bool time = true}) async {
  await createFile(logFile, clear: clear);

  String output;
  if (time) {
    String now = DateTime.now().toIso8601String();
    output = '[$now] $data\n';
  } else {
    output = '$data\n';
  }

  await File(logFile).writeAsString(output, mode: FileMode.append);
}
