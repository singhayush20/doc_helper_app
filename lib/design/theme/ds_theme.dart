import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundations/ds_colors.dart';

final appTheme = ThemeData(
  scaffoldBackgroundColor: DsColors.backgroundPrimary,
  appBarTheme: const AppBarTheme(
    backgroundColor: DsColors.backgroundPrimary,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
);
