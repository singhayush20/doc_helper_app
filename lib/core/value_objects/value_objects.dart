import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/value_objects/i_value_object.dart';
import 'package:doc_helper_app/core/value_objects/validators.dart';
import 'package:doc_helper_app/core/value_objects/value_failure.dart';
import 'package:flutter/material.dart';

@immutable
class EmailAddress extends IValueObject<String> {
  const EmailAddress._(this.value, {String? initialValue, String? regEx})
    : super(initialValue, regEx);

  factory EmailAddress(String input) => EmailAddress._(
    validateEmail(input),
    initialValue: input,
    regEx: r'''^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$''',
  );
  @override
  final Either<ValueFailure<String>, String> value;
}

@immutable
class Password extends IValueObject<String> {
  const Password._(this.value, {String? initialValue})
    : super(initialValue, null);

  factory Password(String input) =>
      Password._(validatePassword(input), initialValue: input);
  @override
  final Either<ValueFailure<String>, String> value;
}

@immutable
class Name extends IValueObject<String> {
  const Name._(this.value, {String? initialValue}) : super(initialValue, null);

  factory Name(String input) =>
      Name._(validateName(input), initialValue: input);
  @override
  final Either<ValueFailure<String>, String> value;
}

@immutable
class Otp extends IValueObject<String> {
  const Otp._(this.value, {String? initialValue}) : super(initialValue, null);

  factory Otp(String input) => Otp._(validateOtp(input), initialValue: input);

  @override
  final Either<ValueFailure<String>, String> value;
}

@immutable
class SearchQuery extends IValueObject<String> {
  const SearchQuery._(this.value, {String? initialValue})
    : super(initialValue, null);

  factory SearchQuery(String input) =>
      SearchQuery._(validateSearchQuery(input), initialValue: input);

  @override
  final Either<ValueFailure<String>, String> value;
}
