/// {@category Util}
/// Helper methods.
class Helper {
  /// Check if a number is an integer.
  static bool isInteger(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }
}
