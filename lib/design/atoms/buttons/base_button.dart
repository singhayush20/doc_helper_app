part of 'ds_button.dart';

base class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    required this.data,
    required this.buttonStyleType,
    this.onTap,
    this.leadingIcon,
    this.borderColor,
    this.disabledBorderColor,
  });

  final String data;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final DsButtonStyleType buttonStyleType;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle;
    return SizedBox(
      height: 40.h,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: DsSpacing.horizontalSpace4,
          children: [
            if (leadingIcon != null) ...[Icon(leadingIcon)],
            Text(data, maxLines: 1, overflow: TextOverflow.clip),
          ],
        ),
      ),
    );
  }

  ButtonStyle get _getButtonStyle => switch (buttonStyleType) {
    DsButtonStyleType.primary => DsButtonStyle.primaryButtonStyle,
    DsButtonStyleType.secondary => DsButtonStyle.secondaryButtonStyle,
  };
}
