class TypeUtils{
  static int convertStringToInt(String myString) {
    var newInt = int.parse(myString);
    assert(newInt is int);
    return newInt;
  }

  static String convertIntToString(int myInt) {
    return myInt.toString();
  }
}