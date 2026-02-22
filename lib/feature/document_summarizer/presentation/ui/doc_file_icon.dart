import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_colors.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/design/foundations/ds_spacing.dart';
import 'package:flutter/material.dart';

class FileIcon extends StatelessWidget {
  const FileIcon({super.key, required this.fileType});

  final FileType fileType;

  @override
  Widget build(BuildContext context) {
    final (bgColor, iconColor, icon) = switch (fileType) {
      FileType.pdf => (
        DsColors.documentPdfBackgroundColor,
        DsColors.documentPdfIconColor,
        Icons.picture_as_pdf_rounded,
      ),
      FileType.doc => (
        DsColors.documentDocxBackgroundColor,
        DsColors.documentDocxIconColor,
        Icons.description_rounded,
      ),
      _ => (DsColors.backgroundSubtle, DsColors.primary, Icons.article_rounded),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
      ),
      child: Padding(
        padding: EdgeInsets.all(DsSpacing.radialSpace12),
        child: Icon(icon, color: iconColor, size: DsSizing.size24),
      ),
    );
  }
}
