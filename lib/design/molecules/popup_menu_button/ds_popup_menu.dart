import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

import 'ds_menu_action.dart';

class DsPopupMenu extends StatelessWidget {
  const DsPopupMenu({
    super.key,
    required this.actions,
    this.icon = Icons.more_vert_outlined,
    this.iconSize,
  });

  final List<DsMenuAction> actions;
  final IconData icon;
  final double? iconSize;

  @override
  Widget build(BuildContext context) => PopupMenuButton<DsMenuAction>(
      icon: Icon(icon),
      iconSize: iconSize,
      position: PopupMenuPosition.under,
      onSelected: (action) => action.onPressed(),
      itemBuilder: (context) => actions.map((action) {
          final Color foregroundColor = action.isDestructive
              ? DsColors.error
              : DsColors.textPrimary;

          return PopupMenuItem<DsMenuAction>(
            value: action,
            child: Row(
              spacing: DsSpacing.horizontalSpace8,
              children: [
                if (action.icon != null) ...[
                  Icon(
                    action.icon,
                    size: DsSizing.size20,
                    color: foregroundColor,
                  ),
                ],
                DsText.bodyMedium(
                  data: action.label,
                  color: foregroundColor,
                ),
              ],
            ),
          );
        }).toList(),
    );
}
