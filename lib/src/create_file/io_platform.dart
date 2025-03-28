import 'dart:io';
import 'dart:async';

Future<File?> createFile(filePath, String data, {bool clear = false}) async {
  var isExists = await File(filePath).exists();
  File? file;
  if (isExists == false) {
    file = await File(filePath).create(recursive: true);
  } else {
    if (clear) {
      file = await File(filePath).writeAsString('');
    }
  }
  await file?.writeAsString(data, mode: FileMode.append);
  return file;
}
