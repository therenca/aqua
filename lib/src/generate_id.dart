import 'dart:math';
import 'dart:convert';

String generateId({int length = 25}) {
  Random _random = Random.secure();
  List<int> values = List<int>.generate(length, (i) => _random.nextInt(256));
  return base64Url.encode(values);
}
