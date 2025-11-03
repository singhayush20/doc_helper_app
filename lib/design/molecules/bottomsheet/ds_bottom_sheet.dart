import 'package:doc_helper_app/design/design.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DsBottomSheet extends StatelessWidget {
  const DsBottomSheet({
    super.key,
    required this.primaryButtonText,
    this.imageKey,
    this.icon,
    this.iconColor = DsColors.iconPrimary,
    this.showDefaultIcon = true,
    this.title,
    this.description,
    this.onPrimaryButtonTap,
    this.secondaryButtonText,
    this.onSecondaryButtonTap,
    this.showCloseButton = true,
    this.isDismissible = true,
  });

  final String? imageKey;
  final IconData? icon;
  final Color iconColor;
  final bool showDefaultIcon;
  final String? title;
  final String? description;
  final String primaryButtonText;
  final VoidCallback? onPrimaryButtonTap;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonTap;
  final bool showCloseButton;
  final bool isDismissible;

  static Future<void> showBottomSheet({
    required BuildContext context,
    required String primaryButtonText,
    String? imageKey,
    IconData? icon,
    Color iconColor = DsColors.iconPrimary,
    bool showDefaultIcon = true,
    String? title,
    String? description,
    VoidCallback? onPrimaryButtonTap,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonTap,
    bool showCloseButton = true,
    bool isDismissible = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    backgroundColor: DsColors.transparent,
    builder: (context) => DsBottomSheet(
      imageKey: imageKey,
      iconColor: iconColor,
      icon: icon,
      showDefaultIcon: showDefaultIcon,
      title: title,
      description: description,
      primaryButtonText: primaryButtonText,
      onPrimaryButtonTap: onPrimaryButtonTap,
      secondaryButtonText: secondaryButtonText,
      onSecondaryButtonTap: onSecondaryButtonTap,
      showCloseButton: showCloseButton,
      isDismissible: isDismissible,
    ),
  );

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: isDismissible,
    child: Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: DsSpacing.radialSpace16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: DsColors.backgroundPrimary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(DsBorderRadius.borderRadius16),
                topRight: Radius.circular(DsBorderRadius.borderRadius16),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(DsSpacing.radialSpace24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showDefaultIcon) ...[
                    Icon(
                      Icons.info_outline_sharp,
                      size: DsSizing.size24,
                      color: DsColors.iconPrimary,
                    ),
                  ] else if (icon != null) ...[
                    Icon(icon, size: DsSizing.size24),
                  ] else if (imageKey != null) ...[
                    DsImage(mediaUrl: imageKey ?? ''),
                    DsSpacing.verticalSpaceSizedBox24,
                  ],
                  if (title != null) ...[
                    DsText.titleLarge(data: title!),
                    DsSpacing.verticalSpaceSizedBox8,
                  ],
                  if (description != null) ...[
                    DsText.bodyMedium(
                      data: description!,
                      textAlign: TextAlign.center,
                    ),
                    DsSpacing.verticalSpaceSizedBox24,
                  ],
                  DsButton.primary(
                    data: primaryButtonText,
                    onTap: () {
                      onPrimaryButtonTap?.call();
                      GoRouter.of(context).pop();
                    },
                  ),
                  if (secondaryButtonText != null &&
                      onSecondaryButtonTap != null) ...[
                    DsSpacing.verticalSpaceSizedBox12,
                    DsButton.secondary(
                      data: secondaryButtonText!,
                      onTap: () {
                        onSecondaryButtonTap?.call();
                        GoRouter.of(context).pop();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (showCloseButton)
          Positioned(
            top: 0,
            right: DsSpacing.radialSpace8,
            child: GestureDetector(
              onTap: () => GoRouter.of(context).pop(),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: DsColors.backgroundPrimary,
                ),
                padding: EdgeInsets.all(DsSpacing.radialSpace4),
                child: const Icon(Icons.close, color: DsColors.iconPrimary),
              ),
            ),
          ),
      ],
    ),
  );
}
