import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

enum DsButtonStyleType { primary, secondary }

abstract class DsButtonStyle {
  static final _primaryButtonTextStyle = DsTextStyle.bodyLarge;

  static final primaryButtonStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
        side: BorderSide.none,
      ),
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(_primaryButtonTextStyle),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace4,
        vertical: DsSpacing.radialSpace2,
      ),
    ),
    iconSize: WidgetStatePropertyAll<double>(DsSizing.size16),
    iconAlignment: IconAlignment.start,
  );

  static final secondaryButtonStyle = ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll<Color>(
      DsColors.buttonSecondary,
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(_primaryButtonTextStyle),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace4,
        vertical: DsSpacing.radialSpace2,
      ),
    ),
    iconSize: WidgetStatePropertyAll<double>(DsSizing.size16),
    iconAlignment: IconAlignment.start,
  );
}
