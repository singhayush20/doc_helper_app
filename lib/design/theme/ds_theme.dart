import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/pin_field/ds_pin_theme_extension.dart';
import 'package:doc_helper_app/design/molecules/text_form_field/text_form_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  dividerTheme: DividerThemeData(
    thickness: DsBorderWidth.borderWidth1,
    color: DsColors.divider,
    space: DsBorderWidth.borderWidth1,
  ),
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius4),
    ),
    tileColor: DsColors.backgroundPrimary,
    iconColor: DsColors.iconPrimary,
    textColor: DsColors.textPrimary,
    contentPadding: EdgeInsets.symmetric(
      horizontal: DsSpacing.radialSpace8,
      vertical: DsSpacing.radialSpace4,
    ),
    selectedTileColor: DsColors.backgroundSubtle,
    dense: false,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: DsColors.surface,
    surfaceTintColor: DsColors.transparent,
    indicatorColor: DsColors.backgroundSubtle,
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return DsTextStyle.bodyMedium.copyWith(
          color: DsColors.primary,
          fontWeight: FontWeight.w600,
        );
      }
      return DsTextStyle.bodyMedium.copyWith(
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
    shadowColor: DsColors.navigationBarShadow,
  ),
  inputDecorationTheme: DsTextFormFieldStyle.primary,
  extensions: <ThemeExtension<dynamic>>[
    DsPinThemeExtension(pinTheme: dsPinTheme),
  ],
);
