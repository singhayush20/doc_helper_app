import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'product_features_bloc.freezed.dart';
part 'product_features_event.dart';
part 'product_features_state.dart';

@injectable
class ProductFeaturesBloc
    extends BaseBloc<ProductFeaturesEvent, ProductFeaturesState> {
  ProductFeaturesBloc()
    : super(
        const ProductFeaturesState.initial(store: ProductFeaturesStateStore()),
      );

  @override
  void handleEvents() {
    on<_Started>(_started);
  }

  void _started(_, Emitter<ProductFeaturesState> emit) {}

  @override
  void started({Map<String, dynamic>? args}) {
    add(const ProductFeaturesEvent.started());
  }
}
