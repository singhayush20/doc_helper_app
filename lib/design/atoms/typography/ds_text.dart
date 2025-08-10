import 'package:flutter/material.dart';

import 'ds_text_style.dart';

part 'base_text.dart';

final class DsText extends BaseText {
  const DsText.titleLarge({
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.titleLarge);

  const DsText.titleMedium({
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.titleMedium);

  const DsText.titleSmall({
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.titleSmall);

  const DsText.bodyLarge({
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.bodyLarge);

  const DsText.bodySmall({
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.bodySmall);

  const DsText.caption({
    required super.data,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(dsTextStyleType: DsTextStyleType.caption);
}
