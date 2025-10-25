import 'package:doc_helper_app/core/value_objects/value_objects.dart';
import 'package:doc_helper_app/design/molecules/pin_field/ds_pin_theme.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

part 'base_pin_field.dart';

class DsPinField extends _BasePinField {
  const DsPinField({
    super.otp,
    super.controller,
    super.focusNode,
    super.enabled,
    super.length,
    super.obscureText,
    super.onChanged,
    super.onCompleted,
    super.validator,
    super.key,
  });
}
