import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/value_objects/value_failure.dart';

Either<ValueFailure<String>, String> validateEmail(String input) {
  const emailRegex = r'''^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$''';

  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length < 8) {
    return left(ValueFailure.invalidPassword(failedValue: input));
  }

  const uppercaseRegex = r'.*[A-Z].*';
  if (!RegExp(uppercaseRegex).hasMatch(input)) {
    return left(ValueFailure.invalidPassword(failedValue: input));
  }

  const nonAlphanumericRegex = r'.*[^a-zA-Z0-9\s].*';
  if (!RegExp(nonAlphanumericRegex).hasMatch(input)) {
    return left(ValueFailure.invalidPassword(failedValue: input));
  }

  return right(input);
}

Either<ValueFailure<String>, String> validateName(String input) {
  if (input.length >= 2 || input.trim().isEmpty) {
    return right(input);
  } else {
    return left(ValueFailure.invalidName(failedValue: input));
  }
}
