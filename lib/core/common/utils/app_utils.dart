import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/router/router.dart';
import 'package:doc_helper_app/design/molecules/bottomsheet/ds_bottom_sheet.dart';
import 'package:doc_helper_app/design/molecules/dialog/ds_dialog.dart';
import 'package:doc_helper_app/feature/ui_component/domain/entities/ui_config_entities.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

const liteFreezed = Freezed(
  toJson: false,
  fromJson: false,
  map: FreezedMapOptions.none,
  when: FreezedWhenOptions.none,
  copyWith: true,
  equal: true,
);

Color? getColorFromCode({required String? colorCode}) {
  if (colorCode?.isEmpty ?? true) {
    return null;
  }
  final buffer = StringBuffer();

  if (colorCode?.length == 6 || colorCode?.length == 7) {
    buffer.write('ff');
  }

  buffer.write(colorCode?.replaceFirst('#', ''));

  try {
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (e) {
    return null;
  }
}

Future<void> handleComponentAction({
  required BuildContext context,
  required ComponentAction? action,
}) {
  if (action == null) {
    return Future.value();
  }
  if (action.routeName?.isNotEmpty ?? false) {
    final routeName = action.routeName ?? '';
    final shell = StatefulNavigationShell.of(context);
    final branchIndex = branchIndexForRoute(routeName);

    if (branchIndex != null) {
      shell.goBranch(
        branchIndex,
        initialLocation: true,
      );
      return Future.value();
    }

    return GoRouter.of(context).pushNamed(routeName);
  } else if (action.bottomSheet != null) {
    return DsBottomSheet.showBottomSheet(
      context: context,
      primaryButtonText: action.bottomSheet?.primaryButton?.text ?? '',
      onPrimaryButtonTap: () => handleComponentAction(
        context: context,
        action: action.bottomSheet?.primaryButton?.onClick,
      ),
      title: action.bottomSheet?.title?.data,
      description: action.bottomSheet?.description?.data,
      showCloseButton: action.bottomSheet?.isClosable ?? true,
      showDefaultIcon: false,
      imageKey: action.bottomSheet?.iconUrl,
      isDismissible: action.bottomSheet?.isClosable ?? true,
      secondaryButtonText: action.bottomSheet?.secondaryButton?.text,
      onSecondaryButtonTap: () => handleComponentAction(
        context: context,
        action: action.bottomSheet?.secondaryButton?.onClick,
      ),
    );
  } else if (action.modal != null) {
    return DsDialog.showDialog(
      context: context,
      primaryButtonText: action.modal?.primaryButton?.text ?? '',
      onPrimaryButtonTap: () => handleComponentAction(
        context: context,
        action: action.modal?.primaryButton?.onClick,
      ),
      title: action.modal?.title?.data,
      description: action.modal?.description?.data,
      showCloseButton: action.modal?.isClosable ?? true,
      showDefaultIcon: false,
      imageKey: action.modal?.iconUrl,
      secondaryButtonText: action.modal?.secondaryButton?.text,
      onSecondaryButtonTap: () => handleComponentAction(
        context: context,
        action: action.modal?.secondaryButton?.onClick,
      ),
    );
  } else {
    return Future.value();
  }
}

FileType getFileType({
  required String? fileName,
}) {
  if (fileName == null || fileName.isEmpty) {
    return FileType.unknown;
  }

  final extension = fileName.split('.').last.toLowerCase();

  return switch (extension) {
    'pdf' => FileType.pdf,
    'doc' || 'docx' => FileType.doc,
    'txt' => FileType.txt,
    _ => FileType.unknown,
  };
}
