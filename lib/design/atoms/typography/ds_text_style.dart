import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DsTextStyleType {
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodySmall,
  caption,
}

class DsTextStyle {
  static const String _fontFamily = 'Roboto';

  static final TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 22.spMin,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 20.spMin,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 18.spMin,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16.spMin,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.spMin,
  );

  static final TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12.spMin,
  );
}
