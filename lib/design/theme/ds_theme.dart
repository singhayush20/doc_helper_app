import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundations/ds_colors.dart';

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
);
