import 'package:doc_helper_app/design/atoms/buttons/ds_button_style.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

part 'base_button.dart';

sealed class DsButton extends BaseButton {
  const DsButton.primary({
    super.key,
    required super.data,
    super.backgroundColor,
    super.disabledColor,
    super.foregroundColor,
  }) : super(buttonStyleType: DsButtonStyleType.primary);

  const DsButton.secondary({
    super.key,
    required super.data,
    super.borderColor,
    super.disabledBorderColor,
    super.foregroundColor,
  }) : super(buttonStyleType: DsButtonStyleType.secondary);
}
