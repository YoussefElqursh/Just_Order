class InputValidator {
  static bool isValidName(String name) {
    return name.length >= 3; // Minimum password length
  }

  static bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8; // Minimum password length
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex =
        RegExp(r"^\+?[0-9]{10,15}$"); // Supports international format
    return phoneRegex.hasMatch(phoneNumber);
  }
}
