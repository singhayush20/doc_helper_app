import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

enum DsButtonStyleType { primary, secondary }

abstract class DsButtonStyle {
  static final _defaultButtonTextStyle = DsTextStyle.bodyLarge;

  static final primaryButtonStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
        side: BorderSide.none,
      ),
    ),
    textStyle: WidgetStatePropertyAll<TextStyle>(_defaultButtonTextStyle),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(
        horizontal: DsSpacing.radialSpace4,
        vertical: DsSpacing.radialSpace2,
      ),
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
        ) {
      if (states.contains(WidgetState.disabled)) {
        return  DsColors.buttonPrimaryDisabled;
      }
      return DsColors.buttonPrimary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
        ) {
      if (states.contains(WidgetState.disabled)) {
        return DsColors.buttonPrimaryTextDisabled;
      }
      return DsColors.textOnDark;
    }),
    iconSize: WidgetStatePropertyAll<double>(DsSizing.size16),
    iconAlignment: IconAlignment.start,
  );

  static final secondaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
        ) {
      if (states.contains(WidgetState.disabled)) {
        return  DsColors.buttonPrimaryDisabled;
      }
      return DsColors.buttonSecondary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
        ) {
      if (states.contains(WidgetState.disabled)) {
        return DsColors.buttonPrimaryTextDisabled;
      }
      return DsColors.buttonSecondaryText;
    }),
    shape: WidgetStateProperty.resolveWith<OutlinedBorder>((
        Set<WidgetState> states,
        ) {
      if (states.contains(WidgetState.disabled)) {
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
          side: const BorderSide(
            color:
            DsColors.buttonSecondaryBorderDisabled,
          ),
        );
      }
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius2),
        side: const BorderSide(
          color: DsColors.buttonSecondaryBorder,
        ),
      );
    }),
    textStyle: WidgetStatePropertyAll<TextStyle>(
      _defaultButtonTextStyle,
    ),
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
