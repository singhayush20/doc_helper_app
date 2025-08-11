import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/unexpected_value_error.dart';
import 'package:doc_helper_app/core/typedefs/type_defs.dart';
import 'package:doc_helper_app/core/value_objects/value_failure.dart';
import 'package:flutter/material.dart';

@immutable
abstract class IValueObject<T> {
  const IValueObject(this.initialValue, this.regEx);

  final String? initialValue;
  final String? regEx;

  Either<ValueFailure<T>, T> get value;

  T getOrCrash() =>
      value.fold((failure) => throw UnexpectedValueError(failure), (r) => r);

  /// This will return the valid value, if value is not valid then null
  T? get() => getOrElse(() => null as T);

  T getOrElse(ValueCallback<T> l) =>
      value.fold((failure) => l.call(), (r) => r);

  /// This will return the value irrespective of validity
  String get input => value.fold((l) => l.failedValue, (r) => r.toString());

  bool isValid() => value.isRight();

  bool isNotValid() => value.isLeft();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IValueObject &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ValueObject(value: $value)';
}
