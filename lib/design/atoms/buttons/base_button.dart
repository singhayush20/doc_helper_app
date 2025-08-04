part of 'ds_button.dart';

base class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.data,
    required this.buttonStyleType,
    this.onClick,
    this.leadingIcon,
    this.backgroundColor = DsColors.buttonPrimaryBackground,
    this.disabledColor = DsColors.buttonPrimaryBackgroundDisabled,
    this.foregroundColor = DsColors.buttonPrimaryText,
    this.disabledForegroundColor = DsColors.buttonPrimaryTextDisabled,
    this.borderColor,
    this.disabledBorderColor,
  });

  final String data;
  final VoidCallback? onClick;
  final IconData? leadingIcon;
  final Color backgroundColor;
  final Color disabledColor;
  final Color foregroundColor;
  final Color disabledForegroundColor;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final DsButtonStyleType buttonStyleType;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle;
    return ElevatedButton(
      style: buttonStyle,
      onPressed: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: DsSpacing.horizontalSpace4,
        children: [if (leadingIcon != null) Icon(leadingIcon), Text(data)],
      ),
    );
  }

  ButtonStyle get _getButtonStyle => switch (buttonStyleType) {
    DsButtonStyleType.primary => DsButtonStyle.primaryButtonStyle.copyWith(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return disabledColor;
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }
        return foregroundColor;
      }),
    ),
    DsButtonStyleType.secondary => DsButtonStyle.secondaryButtonStyle.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }
        return foregroundColor;
      }),
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.disabled)) {
          return RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
            side: BorderSide(
              color: disabledBorderColor ?? DsColors.borderDisabled,
            ),
          );
        }
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
          side: BorderSide(color: borderColor ?? DsColors.borderDefault),
        );
      }),
    ),
  };
}
