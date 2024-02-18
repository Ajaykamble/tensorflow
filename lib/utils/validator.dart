String? emailValidator(email) {
  if (email.isEmpty) {
    return "Please enter the email id";
  }
  String p = "[a-zA-Z0-9.]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+";
  RegExp regExp = RegExp(p);
  if (!regExp.hasMatch(email)) {
    return 'Email Id is not valid';
  }
  return null;
}

String? phoneNoValidator(value) {
  if (value.isEmpty) {
    return "Please enter the Mobile number";
  }
  String p = "^([6-9]{1})([0-9]{9})\$";
  RegExp regExp = RegExp(p);
  if (!regExp.hasMatch(value)) {
    return 'Please enter valid Mobile number';
  }
  return null;
}

String relationValidator(str) {
  if (str == null) {
    return "Select relation";
  }
  return "";
}

String? validator(value) {
  if (value!.isEmpty) {
    return 'Please enter the valid data';
  }
  return null;
}

String? emailOrMobileNumberValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email or phone number';
  }
  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegExp = RegExp(r'^\d{9,15}$');
  if (!(emailRegExp.hasMatch(value) || phoneRegExp.hasMatch(value))) {
    return 'Please enter a valid email or phone number';
  }
  return null;
}

String? dateValidator(value) {
  if (value == null) {
    return "Please select the date";
  }
  return null;
}

String? mobNoValidator(value) {
  if (value == null || value.isEmpty) {
    return "Please enter the Mobile number";
  }
  if (value.length < 9) {
    return "Mobile number should be atleast 9 character";
  }
  if (value.length > 15) {
    return "Moible number should not exceed 15 character";
  }
  return null;
}

String? nameValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your name';
  }
  return null;
}

String? policyNoValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter your Insurance Policy / Card Number';
  }
  return null;
}

String? emIdValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter the Correct Emirates Id';
  }
  return null;
}

String? insuranceProviderValidator(value) {
  if (value!.isEmpty) {
    return 'Please enter Insurance provider name';
  }
  return null;
}

String? passwordvalidator(value) {
  if (value!.isEmpty) {
    return 'Please enter  password';
  }
  return null;
}

String? timeSlotValidator(value) {
  if (value == null) {
    return "Please select the Time Slot";
  }
  return null;
}

String? passwordValidator(value) {
  bool isValidPassword = isPasswordCompliant(value!);
  if (!isValidPassword) {
    return "Please enter the Valid Password";
  }

  return null;
}

bool isPasswordCompliant(String password, [int minLength = 8]) {
  if (password.length < minLength) {
    return false;
  }

  bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  if (hasUppercase) {
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    if (hasDigits) {
      bool hasLowercase = password.contains(RegExp(r'[a-z]'));
      if (hasLowercase) {
        bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
        return hasSpecialCharacters;
      }
    }
  }
  return false;
}
