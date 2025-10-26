import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/material.dart';

enum SnackbarMessageType { error, alert, success }

void showSnackBar({
  required BuildContext context,
  required String message,
  SnackbarMessageType type = SnackbarMessageType.error,
  String? snackBarActionLabel,
  VoidCallback? onPressed,
  Color? backgroundColor,
  EdgeInsets? padding,
  ShapeBorder? shape,
  bool? showCloseIcon,
  Color? textColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor:
          backgroundColor ?? _getDefaultBackgroundColor(messageType: type),
      padding: padding,
      shape: shape,
      showCloseIcon: showCloseIcon ?? true,
      closeIconColor: DsColors.iconOnPrimary,
      content: Row(
        spacing: DsSpacing.horizontalSpace4,
        children: [
          Icon(
            (type == SnackbarMessageType.alert)
                ? Icons.info
                : (type == SnackbarMessageType.success)
                ? Icons.check
                : Icons.warning,
            color: DsColors.iconOnPrimary,
            size: DsSizing.size24,
          ),
          Expanded(
            child: DsText.titleSmall(
              data: message,
              color: textColor ?? DsColors.textOnDark,
            ),
          ),
        ],
      ),
      action: snackBarActionLabel != null && onPressed != null
          ? SnackBarAction(label: snackBarActionLabel, onPressed: onPressed)
          : null,
    ),
  );
}

Color? _getDefaultBackgroundColor({required SnackbarMessageType messageType}) =>
    switch (messageType) {
      SnackbarMessageType.error => DsColors.backgroundWarning,
      SnackbarMessageType.alert => DsColors.backgroundWarning,
      SnackbarMessageType.success => DsColors.backgroundSuccess,
    };
