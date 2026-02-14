import 'package:intl/intl.dart';

extension EnumX<T extends Enum> on Iterable<T> {
  T? by(String? name) {
    for (final value in this) {
      if (value.name.replaceAll('_', '').toLowerCase() ==
          name?.replaceAll('_', '').toLowerCase()) {
        return value;
      }
    }
    return null;
  }
}

extension IterableX<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

/// Converts DateTime to DD-MM-YYYY format
extension DateFormatter on DateTime {
  String toDayMonthYear() => DateFormat('dd-MM-yyyy').format(this);
}
