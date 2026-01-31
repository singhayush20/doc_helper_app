import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/utils/date_time_utils.dart';
import 'package:doc_helper_app/core/global_store/global_state_impl.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_subtitle.dart';
import 'package:doc_helper_app/design/molecules/list_tile/list_tile_title.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/features_page/presentation/bloc/product_features_bloc.dart';
import 'package:doc_helper_app/feature/user_activity/domain/entities/user_activity_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'features_form.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ProductFeaturesBloc>(
    create: (_) => getIt<ProductFeaturesBloc>()..started(),
    child: LoaderOverlay(
      child: Scaffold(
        appBar: const PrimaryAppBar(
          titleText:'Home',
          backButtonRequired: false,
        ),
        body: BlocListener<ProductFeaturesBloc, ProductFeaturesState>(
          listener: _handleState,
          child: const _FeaturesForm(),
        ),
      ),
    ),
  );

  void _handleState(BuildContext context, ProductFeaturesState state) =>
      switch (state) {
        OnException(:final exception) => handleException(exception, context),
        _ => {},
      };
}
