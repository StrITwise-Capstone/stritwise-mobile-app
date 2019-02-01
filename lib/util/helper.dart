class Helper {
  static bool isInteger(String s) {
    if(s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}