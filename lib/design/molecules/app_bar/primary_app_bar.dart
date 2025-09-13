import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.titleText,
    this.backgroundColor,
    this.centerTitle = false,
    this.actions,
    this.leading,
    this.backButtonRequired = true,
  });

  final String? titleText;
  final Color? backgroundColor;
  final bool centerTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool backButtonRequired;

  @override
  Widget build(BuildContext context) => AppBar(
    title: titleText != null ? DsText.titleLarge(data: titleText!) : null,
    backgroundColor: backgroundColor,
    centerTitle: centerTitle,
    automaticallyImplyLeading: backButtonRequired,
    leading: !backButtonRequired
        ? leading
        : IconButton(
            onPressed: () {
              if (context.canPop()) {
                GoRouter.of(context).pop();
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
    actions: [...?actions],
  );

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
