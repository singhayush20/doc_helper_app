import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/utils/enums.dart';
import 'package:intl/intl.dart';

String formatNumberWithSymbol(
  double? value, {
  NumberFormatSymbol prefix = NumberFormatSymbol.noSymbol,
}) {
  if (value == null) {
    return '';
  }
  String? prefixSymbol;
  if (prefix == NumberFormatSymbol.rupee) {
    prefixSymbol = AppConstants.rupeeSymbol;
  }

  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: prefixSymbol ?? '',
    decimalDigits: (value.abs() == value) ? 0 : 2,
  );

  return formatter.format(value).trim();
}
