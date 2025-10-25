import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

enum DsTextButtonStyleType { primary, secondary }

abstract class DsTextButtonStyle {
  static final _baseTextStyle = DsTextStyle.bodySmall;

  static final primaryTextButtonStyle = ButtonStyle(
    textStyle: WidgetStatePropertyAll<TextStyle>(_baseTextStyle),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace4,
        vertical: DsSpacing.radialSpace2,
      ),
    ),
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return DsColors.buttonPrimaryPressed;
      }
      return null;
    }),
    iconSize: WidgetStatePropertyAll<double>(DsSizing.size16),
    iconAlignment: IconAlignment.start,
  );

  static final secondaryTextButtonStyle = ButtonStyle(
    textStyle: WidgetStatePropertyAll<TextStyle>(_baseTextStyle),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace4,
        vertical: DsSpacing.radialSpace2,
      ),
    ),
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return DsColors.buttonSecondaryPressed;
      }
      return null;
    }),
    iconSize: WidgetStatePropertyAll<double>(DsSizing.size16),
    iconAlignment: IconAlignment.start,
  );
}
