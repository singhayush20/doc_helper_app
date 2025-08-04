import 'package:dartz/dartz.dart';

abstract class ValueObject<T> {
  const ValueObject();

  Either<String, T> get value;

  bool isValid() => value.isRight();

  T getOrCrash() => value.fold((l) => throw Exception(l), (r) => r);

  @override
  bool operator ==(Object other) =>
      other is ValueObject<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
