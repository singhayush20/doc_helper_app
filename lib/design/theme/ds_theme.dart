import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/molecules/pin_field/ds_pin_theme_extension.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/text_form_field_style.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text_style.dart';
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
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: DsColors.surface,
    surfaceTintColor: DsColors.transparent,
    indicatorColor: DsColors.backgroundSubtle,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return DsTextStyle.caption.copyWith(
          color: DsColors.primary,
          fontWeight: FontWeight.w600,
        );
      }
      return DsTextStyle.caption.copyWith(
        color: DsColors.textSecondary,
        fontWeight: FontWeight.w400,
      );
    }),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(
          color: DsColors.iconPrimary,
          size: DsSizing.size24,
        );
      }
      return IconThemeData(
        color: DsColors.iconSecondary,
        size: DsSizing.size24,
      );
    }),
    elevation: 8,
    shadowColor: DsColors.overlay,
    height: 80.h,
  ),
  inputDecorationTheme: DsTextFormFieldStyle.primary,
  extensions: <ThemeExtension<dynamic>>[
    DsPinThemeExtension(pinTheme: dsPinTheme),
  ],
);
