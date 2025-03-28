import 'create_file/io_stub.dart'
    if (dart.library.io) 'create_file/io_platform.dart';

Future<void> log(String data, String logFile,
    {bool clear = false, bool time = true}) async {
  String? output;
  if (time) {
    String now = DateTime.now().toIso8601String();
    output = '[$now] $data\n';
  } else {
    output = '$data\n';
  }
  await createFile(logFile, output, clear: clear);
}
