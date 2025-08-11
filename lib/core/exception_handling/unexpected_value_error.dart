import 'package:doc_helper_app/core/value_objects/value_failure.dart';

class UnexpectedValueError extends Error {
  UnexpectedValueError(this.valueFailure);

  final ValueFailure valueFailure;

  @override
  String toString() =>
      Error.safeToString('''Encountered a ValueFailure: $valueFailure''');
}
