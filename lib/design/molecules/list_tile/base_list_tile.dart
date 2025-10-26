part of 'ds_list_tile.dart';

class _BaseListTile extends StatelessWidget {
  const _BaseListTile({
    super.key,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
  });

  final ListTileTitle? title;
  final ListTileSubtitle? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: leading,
    trailing: trailing,
    onTap: onTap,
    title: title,
    subtitle: subtitle,
    tileColor: backgroundColor ?? DsColors.backgroundPrimary,
    shape: RoundedRectangleBorder(
      borderRadius:
          borderRadius ?? BorderRadius.circular(DsBorderRadius.borderRadius4),
      side: (borderColor == null)
          ? BorderSide.none
          : BorderSide(
              color: borderColor ?? DsColors.borderPrimary,
              width: borderWidth ?? DsBorderWidth.borderWidth1,
            ),
    ),
  );
}
