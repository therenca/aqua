class Validators {
	static bool isEmail(String email) => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
	static bool isNumber(String number) => RegExp(r'^[0-9]+$').hasMatch(number);
}
