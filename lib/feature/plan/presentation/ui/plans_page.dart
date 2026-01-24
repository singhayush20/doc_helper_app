import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_widget/base_widget_utils.dart';
import 'package:doc_helper_app/core/common/constants/app_constants.dart';
import 'package:doc_helper_app/core/router/route_mapper.dart';
import 'package:doc_helper_app/design/design.dart';
import 'package:doc_helper_app/di/injection.dart';
import 'package:doc_helper_app/feature/billing/domain/entities/billing_entity.dart';
import 'package:doc_helper_app/feature/plan/presentation/bloc/plans_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

part 'plans_form.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<PlansBloc>(
    create: (_) => getIt<PlansBloc>()..started(),
    child: BlocConsumer<PlansBloc, PlansState>(
      builder: (context, state) => PopScope(
        canPop: !state.store.loading,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) =>
              didPop ? null : _onBackPressed(context: context, state: state),
          child: Scaffold(
            appBar: PrimaryAppBar(
              titleText: 'Plans',
              onBackPressed: () =>
                  _onBackPressed(context: context, state: state),
            ),
            body: const SafeArea(child: _PlansForm()),
          ),
        ),
      ),
      listener: _handleState,
    ),
  );

  void _handleState(BuildContext context, PlansState state) {
    if (state.store.loading) {
      context.loaderOverlay.show();
    } else {
      context.loaderOverlay.hide();
    }
    return switch (state) {
      OnBuyTap(:final selectedProduct) => _handleProduct(
        selectedProduct: selectedProduct,
        context: context,
      ),
      OnPlanCancel _ => GoRouter.of(
        context,
      ).pop({AppConstants.refreshRequired: true}),
      OnDataRefreshed _ => getBloc<PlansBloc>(context).started(),
      OnException(:final exception) => handleException(exception, context),
      _ => null,
    };
  }

  void _handleProduct({
    required BillingProductInfo selectedProduct,
    required BuildContext context,
  }) async {
    final args = await GoRouter.of(
      context,
    ).pushNamed<Map<String, dynamic>>(Routes.payment, extra: selectedProduct);

    if (context.mounted && (args?[AppConstants.refreshRequired] ?? false)) {
      getBloc<PlansBloc>(context).onRefreshSubscriptionData();
    }
  }

  void _onBackPressed({
    required BuildContext context,
    required PlansState state,
  }) {
    if (state.store.refreshOnBackRequired) {
      GoRouter.of(context).pop({AppConstants.refreshRequired: true});
    } else {
      GoRouter.of(context).pop();
    }
  }
}
