part of 'ds_text_button.dart';

base class _BaseTextButton extends StatelessWidget {
  const _BaseTextButton({
    super.key,
    required this.data,
    required this.buttonStyleType,
    this.onTap,
    this.leadingIcon,
    this.trailingIcon,
    this.foregroundColor = DsColors.textPrimary,
    this.disabledForegroundColor = DsColors.textDisabled,
    this.underline,
  });

  final String data;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color foregroundColor;
  final Color disabledForegroundColor;
  final DsTextButtonStyleType buttonStyleType;
  final bool? underline;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle;

    return TextButton(
      style: buttonStyle,
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: DsSpacing.horizontalSpace2,
        children: [
          if (leadingIcon != null) Icon(leadingIcon, size: DsSizing.size16),
          Flexible(
            child: DsText.bodySmall(
              data: data,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              underline: underline,
            ),
          ),
          if (trailingIcon != null) Icon(trailingIcon, size: DsSizing.size16),
        ],
      ),
    );
  }

  ButtonStyle get _getButtonStyle => switch (buttonStyleType) {
    DsTextButtonStyleType.primary =>
      DsTextButtonStyle.primaryTextButtonStyle.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledForegroundColor;
          }
          return foregroundColor;
        }),
      ),
    DsTextButtonStyleType.secondary =>
      DsTextButtonStyle.secondaryTextButtonStyle.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return disabledForegroundColor;
          }
          return foregroundColor;
        }),
      ),
  };
}
