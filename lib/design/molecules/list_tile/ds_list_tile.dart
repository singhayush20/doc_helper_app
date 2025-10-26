import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_subtitle.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:flutter/material.dart';

part 'base_list_tile.dart';

final class DsListTile extends _BaseListTile {
  const DsListTile({
    super.key,
    super.onTap,
    super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.borderRadius,
    super.borderColor,
    super.borderWidth,
    super.backgroundColor,
  });
}
