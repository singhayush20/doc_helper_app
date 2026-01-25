import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:flutter/material.dart';

import 'ds_menu_action.dart';

class DsMenuItem extends StatelessWidget {
  const DsMenuItem({
    super.key,
    required this.action,
  });

  final DsMenuAction action;

  @override
  Widget build(BuildContext context) => MenuItemButton(
      leadingIcon: action.icon != null
          ? Icon(
        action.icon,
        color: action.isDestructive
            ? DsColors.error
            : DsColors.textPrimary,
      )
          : null,
      onPressed: action.onPressed,
      child: Text(
        action.label,
        style: TextStyle(
          color: action.isDestructive
              ? DsColors.error
              : DsColors.textPrimary,
        ),
      ),
    );
}
