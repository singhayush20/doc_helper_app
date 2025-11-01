import 'package:doc_helper_app/core/value_objects/i_value_object.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/text_form_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ds_input_decoration_theme.dart';

part 'base_text_form_field.dart';

class PrimaryTextFormField extends BaseTextFormField {
  const PrimaryTextFormField({
    required super.value,
    super.autoValidateMode,
    super.formFieldValidator,
    super.markIncorrect,
    super.errorText,
    super.lengthLimit,
    super.allowedRegex,
    super.forceUppercase,
    super.prefixIcon,
    super.suffixIcon,
    super.textInputAction,
    super.obscureText,
    super.onTap,
    super.onChanged,
    super.onFieldSubmitted,
    super.onTapOutside,
    super.enabled,
    super.readOnly,
    super.textInputType,
    super.textInputFormatter,
    super.controller,
    super.hintText,
    super.helperText,
    super.labelText,
    super.key,
    super.prefixIconWidget,
    super.suffixIconWidget,
    super.focusNode,
    super.autoFillHints,
    super.autoFocus,
    super.enableCopyPaste,
    super.isMultilineRequired,
    super.maxLines,
    super.prefixWidget,
    super.suffixWidget,
  });
}

class NameTextFormField extends PrimaryTextFormField {
  const NameTextFormField({
    required super.value,
    super.key,
    super.onChanged,
    super.onTap,
    super.labelText,
    super.hintText,
    super.errorText,
    super.controller,
    super.focusNode,
    super.onTapOutside,
    super.prefixIcon,
  }) : super(
         textInputAction: TextInputAction.done,
         textInputType: TextInputType.name,
         forceUppercase: false,
         autoFillHints: const [AutofillHints.name],
       );
}

class EmailTextFormField extends PrimaryTextFormField {
  const EmailTextFormField({
    required super.value,
    super.key,
    super.onChanged,
    super.onTap,
    super.labelText,
    super.hintText,
    super.errorText,
    super.controller,
    super.focusNode,
    super.onTapOutside,
    super.prefixIcon,
    super.readOnly,
  }) : super(
         textInputAction: TextInputAction.done,
         textInputType: TextInputType.emailAddress,
         forceUppercase: false,
         autoFillHints: const [AutofillHints.email],
       );
}

class PasswordTextFormField extends PrimaryTextFormField {
  PasswordTextFormField({
    required super.value,
    super.key,
    super.onChanged,
    super.onTap,
    super.labelText,
    super.hintText,
    super.errorText,
    super.controller,
    super.focusNode,
    super.onTapOutside,
    super.obscureText,
    super.prefixIcon,
    super.suffixIconWidget,
    super.formFieldValidator,
  }) : super(
         textInputAction: TextInputAction.done,
         textInputType: TextInputType.visiblePassword,
         forceUppercase: false,
         textInputFormatter: [
           FilteringTextInputFormatter.allow(
             RegExp(r'[a-zA-Z0-9\u0020-\u007E\u0024-\u00A9]'),
             replacementString: value?.input ?? '',
           ),
         ],
         autoFillHints: const [AutofillHints.password],
       );
}
