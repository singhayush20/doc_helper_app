import 'package:doc_helper_app/design/atoms/buttons/ds_button.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:doc_helper_app/design/widgets/ds_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DsDialog extends StatelessWidget {
  const DsDialog({
    super.key,
    required this.primaryButtonText,
    this.imageKey,
    this.icon,
    this.iconColor = DsColors.iconPrimary,
    this.showDefaultIcon = true,
    this.title,
    this.description,
    this.onPrimaryButtonTap,
    this.primaryButtonLeadingIcon,
    this.secondaryButtonText,
    this.onSecondaryButtonTap,
    this.showCloseButton = true,
    this.dismissible = true,
    this.content,
    this.secondaryAction,
  });

  final String? imageKey;
  final IconData? icon;
  final Color iconColor;
  final bool showDefaultIcon;
  final String? title;
  final String? description;
  final String primaryButtonText;
  final IconData? primaryButtonLeadingIcon;
  final VoidCallback? onPrimaryButtonTap;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonTap;
  final bool showCloseButton;
  final bool dismissible;
  final Widget? content;
  final Widget? secondaryAction;

  static Future<T?> showDialog<T>({
    required BuildContext context,
    required String primaryButtonText,
    String? imageKey,
    IconData? icon,
    Color iconColor = DsColors.iconPrimary,
    bool showDefaultIcon = true,
    String? title,
    String? description,
    VoidCallback? onPrimaryButtonTap,
    IconData? primaryButtonLeadingIcon,
    String? secondaryButtonText,
    VoidCallback? onSecondaryButtonTap,
    bool showCloseButton = true,
    bool dismissible = true,
    Widget? content,
    Widget? secondaryAction,
  }) =>
      showGeneralDialog<T>(
        context: context,
        barrierDismissible: dismissible,
        barrierLabel: '',
        pageBuilder: (context, animation, secondaryAnimation) => DsDialog(
          imageKey: imageKey,
          icon: icon,
          iconColor: iconColor,
          showDefaultIcon: showDefaultIcon,
          title: title,
          description: description,
          primaryButtonText: primaryButtonText,
          primaryButtonLeadingIcon: primaryButtonLeadingIcon,
          onPrimaryButtonTap: onPrimaryButtonTap,
          secondaryButtonText: secondaryButtonText,
          onSecondaryButtonTap: onSecondaryButtonTap,
          showCloseButton: showCloseButton,
          dismissible: dismissible,
          content: content,
          secondaryAction: secondaryAction,
        ),
      );

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: dismissible,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
          ),
          backgroundColor: DsColors.backgroundPrimary,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(DsSpacing.radialSpace24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDefaultIcon) ...[
                      Icon(Icons.info_outline_sharp, size: DsSizing.size24),
                      DsSpacing.verticalSpaceSizedBox24,
                    ] else if (icon != null) ...[
                      Icon(icon, size: DsSizing.size24),
                      DsSpacing.verticalSpaceSizedBox24,
                    ] else if (imageKey != null) ...[
                      DsImage(mediaUrl: imageKey!),
                      DsSpacing.verticalSpaceSizedBox24,
                    ],
                    if (title != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DsText.titleLarge(data: title!),
                      ),
                      DsSpacing.verticalSpaceSizedBox8,
                    ],
                    if (description != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DsText.bodyMedium(
                          data: description!,
                          color: DsColors.textTertiary,
                        ),
                      ),
                      DsSpacing.verticalSpaceSizedBox24,
                    ],
                    if (content != null) ...[
                      content!,
                      DsSpacing.verticalSpaceSizedBox24,
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: DsButton.primary(
                        data: primaryButtonText,
                        leadingIcon: primaryButtonLeadingIcon,
                        onTap: () {
                          onPrimaryButtonTap?.call();
                          GoRouter.of(context).pop();
                        },
                      ),
                    ),
                    if (secondaryAction != null) ...[
                      DsSpacing.verticalSpaceSizedBox12,
                      secondaryAction!,
                    ] else if (secondaryButtonText != null &&
                        onSecondaryButtonTap != null) ...[
                      DsSpacing.verticalSpaceSizedBox12,
                      SizedBox(
                        width: double.infinity,
                        child: DsButton.secondary(
                          data: secondaryButtonText!,
                          onTap: () {
                            onSecondaryButtonTap?.call();
                            GoRouter.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showCloseButton)
                Positioned(
                  top: DsSpacing.radialSpace8,
                  right: DsSpacing.radialSpace8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: DsColors.iconSecondary,
                    ),
                    onPressed: () => GoRouter.of(context).pop(),
                  ),
                ),
            ],
          ),
        ),
      );
}
