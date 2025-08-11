import 'package:flutter/material.dart';

import 'ds_text_style.dart';

part 'base_text.dart';

final class DsText extends BaseText {
  const DsText.titleLarge({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.titleLarge);

  const DsText.titleMedium({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.titleMedium);

  const DsText.titleSmall({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.titleSmall);

  const DsText.bodyLarge({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.bodyLarge);

  const DsText.bodySmall({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.bodySmall);

  const DsText.caption({
    super.key,
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.caption);
}
