import 'package:doc_helper_app/core/value_objects/i_value_object.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/text_form_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ds_input_decoration_theme.dart';

part 'base_text_form_field.dart';

class PrimaryTextFormField extends BaseTextFormField {
  const PrimaryTextFormField({
    super.value,
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

class EmailTextFormField extends PrimaryTextFormField {
  EmailTextFormField({
    super.value,
    super.key,
    super.onChanged,
    super.onTap,
    super.hintText,
    super.errorText,
    super.controller,
    super.focusNode,
    super.onTapOutside,
  }) : super(
         textInputAction: TextInputAction.done,
         textInputType: TextInputType.emailAddress,
         forceUppercase: false,
         textInputFormatter: [
           FilteringTextInputFormatter.allow(
             RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
             replacementString: value?.input ?? '',
           ),
         ],
         autoFillHints: const [AutofillHints.email],
       );
}
