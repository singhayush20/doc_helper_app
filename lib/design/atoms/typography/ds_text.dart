import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:flutter/material.dart';

import 'ds_text_style.dart';

part 'base_text.dart';

final class DsText extends BaseText {
  const DsText.headlineLarge({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.headlineLarge);

  const DsText.headlineMedium({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.headlineMedium);

  const DsText.headlineSmall({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.headlineSmall);

  const DsText.titleLarge({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.titleLarge);

  const DsText.titleMedium({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.titleMedium);

  const DsText.titleSmall({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.titleSmall);

  const DsText.bodyLarge({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.bodyLarge);

  const DsText.bodyMedium({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.bodyMedium);

  const DsText.bodySmall({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.bodySmall);

  const DsText.labelLarge({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.labelLarge);

  const DsText.labelMedium({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.labelMedium);

  const DsText.labelSmall({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.color,
    super.underline,
  }) : super(dsTextStyleType: DsTextStyleType.labelSmall);
}
