class Validators {
  static String validateUsername(String value) {
    if (value.isEmpty) return 'Username is required.';
    if (value.length < 3 || value.length >= 30) return "Username must contain between 3 and 30 characters.";
    final RegExp nameExp = new RegExp(r'^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*$');
    if (!nameExp.hasMatch(value))
      return 'Only these special characters ". - _" are allowed.';
    return null;
  }

  static String validateName(String value, String fieldName) {
    if (value.isEmpty) return '$fieldName is required.';
    final RegExp nameExp = new RegExp(r'^[A-za-zÀ-ú. ]+$');
    if (!nameExp.hasMatch(value))
      return 'Only letters are allowed.';
    return null;
  }

  static String validatePrice(String value, String fieldName) {
    if (value.isEmpty) return '$fieldName is required.';
    // (?<!\S)(?=.)(0|([1-9](\d*|\d{0,2}(,\d{3})*)))?(\.\d*[1-9])?(?!\S)
    final RegExp nameExp = new RegExp(r'^\d{0,8}(\.\d{1,4})?$');
    if (!nameExp.hasMatch(value))
      return 'Currency format is incorrect.';
    return null;
  }

  static String validateRNC(String value) {
    if (value.isEmpty) return 'RNC is required,';
    if (value.length != 9) return 'RNC must contain 9 numbers';
    final RegExp nameExp = new RegExp(r'^[(0-9){9}]*$');
    if (!nameExp.hasMatch(value)) return 'Only numbers are allowed.';
    return null;
  }

  static String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address.';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) return 'Please choose a password.';
    if (value.length < 4 || value.length > 30) return "Password must contain between 4 and 30 characters.";
    return null;
  }

  static String validateRepeatedPassword(String value, String value2) {
    if (value.isEmpty || value2.isEmpty) return 'Please choose a password.';
    if (value.isEmpty) return 'Please rewrite your password.';
    if (value != value2) return "Password doesn't match.";
    return null;
  }
}