extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    // Minimum 8 characters, at least one letter and one number, special characters allowed
    final passwordRegExp =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp = RegExp(r"^[A-Za-z]{2,}$"); // Only letters, min 2 chars
    return nameRegExp.hasMatch(this);
  }
}

class Validator {
  Validator._();

  static String? validateName(String? value) {
    // Remove leading and trailing white spaces

    if (value!.length <= 2) {
      return 'Please enter at least 3 characters';
    }

    return null; // Return null if the full name is valid
  }

  static String? validatePhoneNumber(String? value) {
    // Regular expression pattern for phone numbers (assumes 10 digits)
    final RegExp regex = RegExp(r'^[0-9]{11}$');

    if (!regex.hasMatch(value!)) {
      return 'Please enter a valid 11-digit phone number';
    }

    return null; // Return null if the phone number is valid
  }

  static String? validateEmpty(String? value) {
    // Remove leading and trailing white spaces

    if (value!.isEmpty) {
      return 'Please enter at value';
    }

    return null; // Return null if the full name is valid
  }
}
