import 'dart:async';

import 'package:doc_helper_app/core/common/base_bloc/base_bloc.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_event.dart';
import 'package:doc_helper_app/core/common/base_bloc/base_state.dart';
import 'package:doc_helper_app/core/common/utils/app_utils.dart';
import 'package:doc_helper_app/core/global_store/global_state_impl.dart';
import 'package:doc_helper_app/core/global_store/global_store.dart';
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
      ) {
    _globalStoreSubscription = globalState.globalStoreStream.listen(
      _globalStoreUpdated,
    );
  }

  StreamSubscription<GlobalStore>? _globalStoreSubscription;

  @override
  void handleEvents() {
    on<_Started>(_started);
    on<_OnGlobalStoreUpdated>(_onGlobalStoreUpdated);
  }

  void _started(_, Emitter<ProductFeaturesState> emit) {
    invalidateLoader(emit, loading: false);
  }

  void _onGlobalStoreUpdated(_, Emitter<ProductFeaturesState> emit) {

  }

  @override
  void started({Map<String, dynamic>? args}) {
    add(const ProductFeaturesEvent.started());
  }


  @override
  Future<void> close() async {
    await _globalStoreSubscription?.cancel();
    super.close();
  }

  void _globalStoreUpdated(GlobalStore updatedStore) {
    add(
      ProductFeaturesEvent.onGlobalStoreUpdated(
        store: updatedStore,
      ),
    );
  }
}
