import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/ds_input_decoration_theme.dart';
import 'package:flutter/material.dart';

class DsTextFormFieldStyle {
  const DsTextFormFieldStyle._();

  static final _primaryInputTextStyle = WidgetStateTextStyle.resolveWith((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return DsTextStyle.bodySmall.copyWith(color: DsColors.textDisabled);
    }
    return DsTextStyle.bodySmall;
  });

  static final _primaryHintTextStyle = WidgetStateTextStyle.resolveWith((
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.disabled) ||
        states.contains(WidgetState.hovered)) {
      return DsTextStyle.bodySmall.copyWith(color: DsColors.textDisabled);
    }
    return DsTextStyle.bodySmall.copyWith(color: DsColors.textHint);
  });

  static final primary = DsInputDecorationTheme(
    inputTextStyle: _primaryInputTextStyle,
    hintTextStyle: _primaryHintTextStyle,
  );
}
