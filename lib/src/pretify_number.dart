String pretifyNumber(String number) {
  var numberF = number.replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

  return numberF;
}
