import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/feature/features_page/data/models/dto_to_entity_mapper.dart';
import 'package:doc_helper_app/feature/features_page/data/models/feature_dto.dart';
import 'package:doc_helper_app/feature/features_page/domain/entity/features.dart';
import 'package:doc_helper_app/feature/features_page/domain/interface/i_feature_facade.dart';
import 'package:doc_helper_app/feature/ui_component/domain/entities/enums.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IProductFeatureFacade)
class ProductFeatureFacadeImpl implements IProductFeatureFacade {
  ProductFeatureFacadeImpl(this._apiClient, this._apiCallHandler);

  final RetrofitApiClient _apiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, ProductFeatureList?>> getUIComponents({
    required UIComponentType componentType,
    required String screen,
  }) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.getUiComponents,
      [screen, componentType.name.toString().toUpperCase()],
    );

    return responseOrError.fold(
      (error) => left(error),
      (response) => right(
        ProductFeatureListDto.fromJson(
          response.data as Map<String, dynamic>,
        ).toDomain(),
      ),
    );
  }
}
