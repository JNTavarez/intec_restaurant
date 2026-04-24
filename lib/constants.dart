import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
]);

// The wrapper logic for your TextFormField
String? validateConfirmPassword(String? value, String originalPassword) {
  // First, run the standard checks (length, special chars, etc.)
  final baseError = passwordValidator(value);
  if (baseError != null) return baseError;

  // Then, check if they match
  if (value != originalPassword) {
    return 'Passwords do not match';
  }

  return null;
}

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'email is required'),
  EmailValidator(errorText: 'enter a valid email address')
]);

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'name is required'),
  PatternValidator(r"^[a-zA-Z\s\-\']+$", errorText: 'names must not have numbers or special characters')
]);

