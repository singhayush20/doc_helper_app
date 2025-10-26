import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DsTextStyleType {
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyBoldSmall,
  bodySmall,
  caption,
}

class DsTextStyle {
  static const String _fontFamily = 'Roboto';

  static final TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 28.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 24.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 22.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 18.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle bodyBoldSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 16.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.spMin,
    color: DsColors.textPrimary,
  );
}
