part of 'ds_text.dart';

base class BaseText extends StatelessWidget {
  const BaseText({
    required this.data,
    required this.dsTextStyleType,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final DsTextStyleType dsTextStyleType;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final style = _mapTextStyle(dsTextStyleType);
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _mapTextStyle(DsTextStyleType textStyle) {
    switch (textStyle) {
      case DsTextStyleType.titleLarge:
        return DsTextStyle.titleLarge;
      case DsTextStyleType.titleMedium:
        return DsTextStyle.titleMedium;
      case DsTextStyleType.titleSmall:
        return DsTextStyle.titleSmall;
      case DsTextStyleType.bodyLarge:
        return DsTextStyle.bodyLarge;
      case DsTextStyleType.bodySmall:
        return DsTextStyle.bodySmall;
      case DsTextStyleType.caption:
        return DsTextStyle.caption;
    }
  }
}
