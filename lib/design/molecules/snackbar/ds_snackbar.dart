import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  String? snackBarActionLabel,
  void Function()? onPressed,
  Color? backgroundColor,
  EdgeInsets? padding,
  ShapeBorder? shape,
  bool? showCloseIcon,
  Color? textColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? DsColors.backgroundWarning,
      padding: padding,
      shape: shape,
      showCloseIcon: showCloseIcon ?? true,
      content: DsText.titleSmall(
        data: message,
        color: textColor ?? DsColors.textOnDark,
      ),
      action: snackBarActionLabel != null && onPressed != null
          ? SnackBarAction(label: snackBarActionLabel, onPressed: onPressed)
          : null,
    ),
  );
}
