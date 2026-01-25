part of 'product_features_bloc.dart';

@freezed
sealed class ProductFeaturesEvent extends BaseEvent
    with _$ProductFeaturesEvent {
  const ProductFeaturesEvent._() : super();

  const factory ProductFeaturesEvent.started() = _Started;
}
