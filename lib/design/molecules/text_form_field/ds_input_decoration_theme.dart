import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

class DsInputDecorationTheme extends InputDecorationTheme {
  DsInputDecorationTheme({
    super.key,
    required this.inputTextStyle,
    required this.hintTextStyle,
  }) : super(
         isDense: true,
         filled: true,
         fillColor: _defaultBackgroundColor,
         focusColor: _defaultBackgroundColor,
         hoverColor: _defaultBackgroundColor,
         contentPadding: _defaultContentPadding,
         labelStyle: _defaultLabelTextStyle,
         helperStyle: _defaultHelperTextStyle,
         errorStyle: _defaultErrorTextStyle,
         border: _defaultBorder,
         enabledBorder: _defaultBorder,
         disabledBorder: _defaultBorder,
         focusedBorder: _defaultFocusedBorder,
         errorBorder: _defaultErrorBorder,
         focusedErrorBorder: _defaultErrorBorder,
         prefixIconColor: _defaultPrefixIconColor,
         suffixIconColor: _defaultSuffixIconColor,
         iconColor: _defaultPrefixIconColor,
         errorMaxLines: 2,
       );

  final TextStyle hintTextStyle;
  final TextStyle inputTextStyle;

  static final _defaultBackgroundColor = WidgetStateColor.resolveWith((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return DsColors.textFieldBackgroundDisabled;
    }
    return DsColors.textFieldBackground;
  });

  static final _defaultContentPadding = EdgeInsets.all(DsSpacing.radialSpace12);

  static final _defaultLabelTextStyle = DsTextStyle.bodyLarge.copyWith(
    color: DsColors.textFieldLabel,
  );

  static final _defaultHelperTextStyle = DsTextStyle.bodyLarge.copyWith(
    color: DsColors.textFieldHelper,
  );

  static final _defaultErrorTextStyle = WidgetStateTextStyle.resolveWith((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return DsTextStyle.bodyMedium.copyWith(
        color: DsColors.textFieldTextDisabled,
      );
    }
    return DsTextStyle.bodyMedium.copyWith(color: DsColors.textFieldErrorText);
  });

  static final _defaultBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: DsColors.textFieldBorder),
    borderRadius: BorderRadius.all(
      Radius.circular(DsBorderRadius.borderRadius4),
    ),
  );

  static final _defaultFocusedBorder = _defaultBorder.copyWith(
    borderSide: _defaultBorder.borderSide.copyWith(
      color: DsColors.textFieldBorderFocused,
    ),
  );

  static final _defaultErrorBorder = _defaultBorder.copyWith(
    borderSide: _defaultBorder.borderSide.copyWith(
      color: DsColors.textFieldBorderError,
    ),
  );

  static final _defaultPrefixIconColor = WidgetStateColor.resolveWith((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return DsColors.iconDisabled;
    }
    return DsColors.iconPrimary;
  });

  static final _defaultSuffixIconColor = WidgetStateColor.resolveWith((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return DsColors.iconDisabled;
    }

    if (states.contains(WidgetState.error)) {
      return DsColors.iconError;
    }

    return DsColors.iconPrimary;
  });
}
