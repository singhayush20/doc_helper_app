import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/features_page/presentation/bloc/product_features_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'features_form.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ProductFeaturesBloc>(
    create: (_) => getIt<ProductFeaturesBloc>()..started(),
    child: LoaderOverlay(
      child: BlocConsumer<ProductFeaturesBloc, ProductFeaturesState>(
        listener: (context, state) {},
        builder: (context, state) => const Scaffold(
          appBar: PrimaryAppBar(
            titleText: 'More Features',
            backButtonRequired: false,
          ),
          body: _FeaturesForm(),
        ),
      ),
    ),
  );
}
