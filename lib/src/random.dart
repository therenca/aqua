import 'dart:math';

int getRandomNumber({int min = 0, int max = 100}) {
  Random random = Random();
  return (min.toDouble() + random.nextInt(max - min)).toInt();
}
