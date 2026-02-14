import 'dart:ui';

import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_subtitle.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:flutter/material.dart';

part 'doc_summarizer_form.dart';

class DocSummarizerPage extends StatelessWidget {
  const DocSummarizerPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    appBar: PrimaryAppBar(
      titleText: 'Summarizer',
      backButtonRequired: true,
    ),
    body: SafeArea(
        child: _DocSummarizerForm(),
    ),
  );
}
