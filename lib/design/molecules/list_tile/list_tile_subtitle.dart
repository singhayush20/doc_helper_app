import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:flutter/material.dart';

sealed class ListTileSubtitle extends StatelessWidget {
  const ListTileSubtitle({super.key, this.data, this.color});

  final String? data;
  final Color? color;
}

class ListTileSubtitleLarge extends ListTileSubtitle {
  const ListTileSubtitleLarge({
    super.key,
    required String super.data,
    super.color,
  });

  @override
  Widget build(BuildContext context) =>
      DsText.bodyLarge(data: data ?? '', color: color);
}

class ListTileSubtitleMedium extends ListTileSubtitle {
  const ListTileSubtitleMedium({
    super.key,
    required String super.data,
    super.color,
  });

  @override
  Widget build(BuildContext context) =>
      DsText.bodySmall(data: data ?? '', color: color);
}
