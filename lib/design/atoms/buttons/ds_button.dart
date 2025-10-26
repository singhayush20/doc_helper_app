import 'package:doc_helper_app/design/atoms/buttons/ds_button_style.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'base_button.dart';

final class DsButton extends BaseButton {
  const DsButton.primary({
    super.key,
    required super.data,
    super.onTap,
    super.borderColor,
    super.disabledBorderColor,
    super.leadingIcon,
  }) : super(buttonStyleType: DsButtonStyleType.primary);

  const DsButton.secondary({
    super.key,
    required super.data,
    super.borderColor,
    super.disabledBorderColor,
    super.onTap,
    super.leadingIcon,
  }) : super(buttonStyleType: DsButtonStyleType.secondary);
}
