import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/design/atoms/text_button/ds_text_button.dart';
import 'package:doc_helper_app/design/atoms/typography/ds_text.dart';
import 'package:doc_helper_app/design/design.dart'
    show DsColors, DsSpacing, PrimaryAppBar;
import 'package:doc_helper_app/design/foundations/ds_border_radius.dart';
import 'package:doc_helper_app/design/foundations/ds_sizing.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/user_docs/presentation/bloc/doc_upload/doc_upload_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'doc_upload_form.dart';

class DocUploadPage extends StatelessWidget {
  const DocUploadPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<DocUploadBloc>(
    create: (_) => getIt<DocUploadBloc>()..started(),
    child: const Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PrimaryAppBar(
        titleText: 'Upload Documents',
        backButtonRequired: true,
      ),
      body: SafeArea(child: _DocUploadForm()),
    ),
  );
}
