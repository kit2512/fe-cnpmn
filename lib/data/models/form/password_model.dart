import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  short,
  long,
  noDigit,
  noLowercase,
  noUppercase,
  match,
  noSpecialCharacter
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure({this.confirmPassword}) : super.pure('');

  const Password.dirty(this.confirmPassword, [String value = '']) : super.dirty(value);

  final String? confirmPassword;

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.short;
    } else if (value.length > 30) {
      return PasswordValidationError.long;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationError.noDigit;
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.noLowercase;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.noUppercase;
    } else if (!value.contains(RegExp(r'[!-\/:-@[-`{-~]'))) {
      return PasswordValidationError.noSpecialCharacter;
    } else if (confirmPassword != null && confirmPassword!.isNotEmpty && confirmPassword != value) {
      return PasswordValidationError.match;
    }
    return null;
  }

  static String getError(PasswordValidationError value) {
    switch (value) {
      case PasswordValidationError.empty:
        return 'validators.field_empty';
      case PasswordValidationError.short:
        return 'validators.password_min_8_chars';
      case PasswordValidationError.long:
        return 'validators.password_too_long';
      case PasswordValidationError.noDigit:
        return 'validators.password_no_digits';
      case PasswordValidationError.noLowercase:
        return 'validators.password_no_lowercase';
      case PasswordValidationError.noUppercase:
        return 'validators.password_no_uppercase';
      case PasswordValidationError.match:
        return 'validators.passwords_do_not_match';
      case PasswordValidationError.noSpecialCharacter:
        return 'validators.no_special_character';
    }
  }
}
