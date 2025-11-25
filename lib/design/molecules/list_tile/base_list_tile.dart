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
  Widget build(BuildContext context) {
    final theme = Theme.of(context).listTileTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ??
            (theme.shape as RoundedRectangleBorder?)?.borderRadius ??
            BorderRadius.circular(DsBorderRadius.borderRadius4),
        side: (borderColor == null)
            ? BorderSide.none
            : BorderSide(
                color: borderColor ?? DsColors.borderPrimary,
                width: borderWidth ?? DsBorderWidth.borderWidth1,
              ),
      ),
      child: ListTile(
        tileColor:
            backgroundColor ?? theme.tileColor ?? DsColors.backgroundPrimary,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
        title: title,
        subtitle: subtitle,
      ),
    );
  }
}
