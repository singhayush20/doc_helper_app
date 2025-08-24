import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

import 'base_text_button_style.dart';

part 'base_text_button.dart';

final class DsTextButton extends _BaseTextButton {
  const DsTextButton.primary({
    super.key,
    required super.data,
    super.onTap,
    super.leadingIcon,
    super.trailingIcon,
    super.foregroundColor,
    super.disabledForegroundColor,
  }) : super(buttonStyleType: DsTextButtonStyleType.primary);

  const DsTextButton.secondary({
    super.key,
    required super.data,
    super.onTap,
    super.leadingIcon,
    super.trailingIcon,
    super.foregroundColor,
    super.disabledForegroundColor,
  }) : super(buttonStyleType: DsTextButtonStyleType.secondary);
}
