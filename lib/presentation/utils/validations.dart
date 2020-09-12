class Validations {
  static final Validations _singleton = Validations._internal();

  factory Validations() {
    return _singleton;
  }

  Validations._internal();

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regex.hasMatch(value);
  }

  bool validatePassword(String value) {
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }

  bool validatePhone(String value) {
    RegExp regex = RegExp(r"^[0-9]{10}$");
    return regex.hasMatch(value);
  }
}
