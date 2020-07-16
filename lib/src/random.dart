import 'dart:math';

double getRandomNumber({int min=0, int max=100}){
	Random random = Random();
	return min.toDouble() + random.nextInt(max-min);
}