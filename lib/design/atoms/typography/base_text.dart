part of 'ds_text.dart';

base class BaseText extends StatelessWidget {
  const BaseText({
    super.key,
    required this.data,
    required this.dsTextStyleType,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.underline,
  });

  final String data;
  final DsTextStyleType dsTextStyleType;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final bool? underline;

  @override
  Widget build(BuildContext context) {
    final style = _mapTextStyle(dsTextStyleType);
    return Text(
      data,
      style: style.copyWith(
        color: color ?? DsColors.textPrimary,
        decoration: (underline ?? false) ? TextDecoration.underline : null,
        decorationStyle: (underline ?? false)
            ? TextDecorationStyle.solid
            : null,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _mapTextStyle(DsTextStyleType textStyle) {
    switch (textStyle) {
      case DsTextStyleType.headlineLarge:
        return DsTextStyle.headlineLarge;
      case DsTextStyleType.headlineMedium:
        return DsTextStyle.headlineMedium;
      case DsTextStyleType.headlineSmall:
        return DsTextStyle.headlineSmall;
      case DsTextStyleType.titleLarge:
        return DsTextStyle.titleLarge;
      case DsTextStyleType.titleMedium:
        return DsTextStyle.titleMedium;
      case DsTextStyleType.titleSmall:
        return DsTextStyle.titleSmall;
      case DsTextStyleType.bodyLarge:
        return DsTextStyle.bodyLarge;
      case DsTextStyleType.bodyMedium:
        return DsTextStyle.bodyMedium;
      case DsTextStyleType.bodySmall:
        return DsTextStyle.bodySmall;
      case DsTextStyleType.labelLarge:
        return DsTextStyle.labelLarge;
      case DsTextStyleType.labelMedium:
        return DsTextStyle.labelMedium;
      case DsTextStyleType.labelSmall:
        return DsTextStyle.labelSmall;
    }
  }
}
