import 'package:doc_helper_app/design/molecules/pin_field/ds_pin_theme.dart';
import 'package:flutter/material.dart';

class DsPinThemeExtension extends ThemeExtension<DsPinThemeExtension> {
  const DsPinThemeExtension({required this.pinTheme});

  final DsPinTheme pinTheme;

  @override
  ThemeExtension<DsPinThemeExtension> copyWith({DsPinTheme? pinTheme}) =>
      DsPinThemeExtension(pinTheme: pinTheme ?? this.pinTheme);

  @override
  ThemeExtension<DsPinThemeExtension> lerp(
    ThemeExtension<DsPinThemeExtension>? other,
    double t,
  ) {
    if (other is! DsPinThemeExtension) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
