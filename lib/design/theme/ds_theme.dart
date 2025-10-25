import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/molecules/pin_field/ds_pin_theme_extension.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/text_form_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundations/ds_colors.dart';
import '../molecules/pin_field/ds_pin_theme.dart' show dsPinTheme;

final appTheme = ThemeData(
  scaffoldBackgroundColor: DsColors.backgroundPrimary,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: DsColors.iconPrimary,
      size: DsSizing.size24,
    ),
    backgroundColor: DsColors.backgroundPrimary,
    scrolledUnderElevation: 4,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  inputDecorationTheme: DsTextFormFieldStyle.primary,
  extensions: <ThemeExtension<dynamic>>[
    DsPinThemeExtension(pinTheme: dsPinTheme),
  ],
);
