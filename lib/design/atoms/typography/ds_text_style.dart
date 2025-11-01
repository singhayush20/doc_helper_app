import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DsTextStyleType {
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class DsTextStyle {
  static const String _fontFamily = 'Roboto';

  static final TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 32.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 28.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 24.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 22.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12.spMin,
    color: DsColors.textPrimary,
  );

  static final TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 11.spMin,
    color: DsColors.textPrimary,
  );
}
