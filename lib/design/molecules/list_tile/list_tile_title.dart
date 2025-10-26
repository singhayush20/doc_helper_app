import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:flutter/material.dart';

sealed class ListTileTitle extends StatelessWidget {
  const ListTileTitle({super.key, this.data, this.color});

  final String? data;
  final Color? color;
}

class ListTileTitleLarge extends ListTileTitle {
  const ListTileTitleLarge({
    super.key,
    required String super.data,
    super.color,
  });

  @override
  Widget build(BuildContext context) =>
      DsText.titleLarge(data: data ?? '', color: color);
}

class ListTileTitleMedium extends ListTileTitle {
  const ListTileTitleMedium({
    super.key,
    required String super.data,
    super.color,
  });

  @override
  Widget build(BuildContext context) =>
      DsText.titleMedium(data: data ?? '', color: color);
}

