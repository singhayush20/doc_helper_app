part of 'ds_text_form_field.dart';

abstract class BaseTextFormField extends StatelessWidget {
  const BaseTextFormField({
    required IValueObject? value,
    super.key,
    TextEditingController? controller,
    VoidCallback? onTap,
    ValueChanged<String>? onChanged,
    VoidCallback? onFieldSubmitted,
    TapRegionCallback? onTapOutside,
    int? lengthLimit,
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefixIconWidget,
    Widget? suffixIconWidget,
    Widget? prefixWidget,
    Widget? suffixWidget,
    TextInputType? textInputType,
    TextInputAction? textInputAction,
    bool? obscureText,
    bool? forceUppercase,
    bool? enableCopyPaste,
    String? allowedRegex,
    List<TextInputFormatter>? textInputFormatter,
    bool? enabled = true,
    bool readOnly = false,
    FormFieldValidator<IValueObject>? formFieldValidator,
    bool? markIncorrect,
    AutovalidateMode? autoValidateMode,
    bool? autoFocus,
    FocusNode? focusNode,
    Iterable<String>? autoFillHints,
    int? maxLines = 3,
    bool isMultilineRequired = false,
  }) : _value = value,
       _controller = controller,
       _onTap = onTap,
       _onChanged = onChanged,
       _onFieldSubmitted = onFieldSubmitted,
       _onTapOutside = onTapOutside,
       _lengthLimit = lengthLimit,
       _labelText = labelText,
       _hintText = hintText,
       _helperText = helperText,
       _errorText = errorText,
       _prefixIcon = prefixIcon,
       _suffixIcon = suffixIcon,
       _prefixIconWidget = prefixIconWidget,
       _suffixIconWidget = suffixIconWidget,
       _prefixWidget = prefixWidget,
       _suffixWidget = suffixWidget,
       _textInputType = textInputType,
       _textInputAction = textInputAction,
       _obscureText = obscureText,
       _forceUppercase = forceUppercase,
       _enableCopyPaste = enableCopyPaste,
       _allowedRegex = allowedRegex,
       _textInputFormatter = textInputFormatter,
       _enabled = enabled,
       _readOnly = readOnly,
       _formFieldValidator = formFieldValidator,
       _markIncorrect = markIncorrect,
       _autoValidateMode = autoValidateMode,
       _autoFocus = autoFocus,
       _focusNode = focusNode,
       _autoFillHints = autoFillHints,
       _maxLines = isMultilineRequired ? maxLines : 1,
       _isMultilineRequired = isMultilineRequired;

  final IValueObject? _value;
  final TextEditingController? _controller;
  final VoidCallback? _onTap;
  final ValueChanged<String>? _onChanged;
  final VoidCallback? _onFieldSubmitted;
  final TapRegionCallback? _onTapOutside;
  final int? _lengthLimit;
  final String? _labelText;
  final String? _hintText;
  final String? _helperText;
  final String? _errorText;
  final IconData? _prefixIcon;
  final IconData? _suffixIcon;
  final Widget? _prefixIconWidget;
  final Widget? _suffixIconWidget;
  final Widget? _prefixWidget;
  final Widget? _suffixWidget;
  final TextInputType? _textInputType;
  final TextInputAction? _textInputAction;
  final bool? _obscureText;
  final bool? _forceUppercase;
  final bool? _enableCopyPaste;
  final String? _allowedRegex;
  final List<TextInputFormatter>? _textInputFormatter;
  final bool? _enabled;
  final bool _readOnly;
  final FormFieldValidator<IValueObject>? _formFieldValidator;
  final bool? _markIncorrect;
  final AutovalidateMode? _autoValidateMode;
  final bool? _autoFocus;
  final FocusNode? _focusNode;
  final Iterable<String>? _autoFillHints;
  final int? _maxLines;
  final bool? _isMultilineRequired;

  @override
  Widget build(BuildContext context) {
    final decoration = _dsInputDecorationTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: DsSpacing.verticalSpace4,
      children: [
        if (_labelText?.isNotEmpty ?? false) ...[
          Text(
            _labelText ?? '',
            style: decoration.labelStyle,
            textAlign: TextAlign.start,
          ),
        ],
        TextFormField(
          initialValue: _controller == null ? _value?.input : null,
          controller: _controller,
          onTap: _onTap,
          onChanged: _onChanged,
          onFieldSubmitted: (value) {
            if (_onFieldSubmitted != null) {
              return _onFieldSubmitted.call();
            }
            _getOnFieldSubmittedAction(context);
          },
          onTapOutside: _onTapOutside,
          enabled: _enabled,
          readOnly: _readOnly,
          keyboardType: _textInputType ?? TextInputType.text,
          autovalidateMode:
              _autoValidateMode ?? AutovalidateMode.onUserInteraction,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: _textInputAction ?? TextInputAction.next,
          obscureText: _obscureText ?? false,
          enableInteractiveSelection: _enableCopyPaste ?? true,
          autofocus: _autoFocus ?? false,
          focusNode: _focusNode,
          autofillHints: _autoFillHints,
          style: decoration.inputTextStyle,
          decoration: _getInputDecoration(),
          inputFormatters: _getTextInputFormatters(),
          cursorColor: DsColors.textFormFieldCursorColor,
          cursorErrorColor: DsColors.textFormFieldCursorColor,
          maxLines: _maxLines,
        ),
      ],
    );
  }

  InputDecoration _getInputDecoration() {
    final errorText = _getErrorText();

    return InputDecoration(
      hintText: _hintText,
      helperText: _helperText,
      errorText: errorText,
      filled: _dsInputDecorationTheme.filled,
      fillColor: _dsInputDecorationTheme.fillColor,
      focusColor: _dsInputDecorationTheme.focusColor,
      hoverColor: _dsInputDecorationTheme.hoverColor,
      focusedBorder: !_readOnly ? _dsInputDecorationTheme.focusedBorder : null,
      border: _dsInputDecorationTheme.border,
      prefix: _prefixIcon == null && _prefixIconWidget == null
          ? null
          : _prefixWidget,
      suffix:
          errorText == null && _suffixIcon == null && _suffixIconWidget == null
          ? null
          : _suffixWidget,
      prefixIcon: _prefixIcon != null
          ? _PrefixIcon(icon: _prefixIcon)
          : _prefixIconWidget,
      suffixIcon: errorText != null
          ? const _SuffixIcon(icon: Icons.warning)
          : _suffixIcon != null
          ? _SuffixIcon(icon: _suffixIcon)
          : _suffixIconWidget,
      alignLabelWithHint: _isMultilineRequired,
    );
  }

  List<TextInputFormatter> _getTextInputFormatters() => [
    ...?_textInputFormatter,
    LengthLimitingTextInputFormatter(_lengthLimit ?? 120),
    FilteringTextInputFormatter.allow(
      RegExp(_allowedRegex ?? r'[a-zA-Z0-9\u0020-\u007E\u0024-\u00A9]'),
    ),
    if (_forceUppercase ?? false) const UpperCaseTextFormatter(),
  ];

  String? _getErrorText() {
    if (_markIncorrect ?? false) {
      return _errorText;
    }

    if (_value == null) {
      return null;
    }

    if (_formFieldValidator != null) {
      return _formFieldValidator(_value);
    }

    if (_autoValidateMode == AutovalidateMode.always) {
      if (_value.isValid() || _value.input.isEmpty) {
        return null;
      }
      return _errorText;
    }

    if (_value.isValid() || _value.input.isEmpty) {
      return null;
    }
    return _errorText;
  }

  FocusScopeNode? _getOnFieldSubmittedAction(BuildContext context) {
    if (_textInputAction == TextInputAction.next) {
      FocusScope.of(context).nextFocus();
      return null;
    }
    return null;
  }

  DsInputDecorationTheme get _dsInputDecorationTheme =>
      DsTextFormFieldStyle.primary;
}

class _PrefixIcon extends StatelessWidget {
  const _PrefixIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: DsSpacing.radialSpace8,
      right: DsSpacing.radialSpace8,
    ),
    child: Icon(icon, size: DsSizing.size24),
  );
}

class _SuffixIcon extends StatelessWidget {
  const _SuffixIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: DsSpacing.radialSpace12,
      right: DsSpacing.radialSpace12,
    ),
    child: Icon(icon, size: DsSizing.size24),
  );
}

class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => TextEditingValue(
    text: newValue.text.toUpperCase(),
    selection: newValue.selection,
  );
}
