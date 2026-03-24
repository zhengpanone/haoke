class StringUtil {
  static bool isBlank(String? value) {
    if (value == null || value.isEmpty) return true;
    return false;
  }
}
