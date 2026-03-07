import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/feature/features_page/domain/entity/features.dart';
import 'package:doc_helper_app/feature/ui_component/domain/entities/enums.dart';

abstract class IProductFeatureFacade {
  Future<Either<ServerException, ProductFeatureList?>> getUIComponents({
    required UIComponentType componentType,
    required String screen,
  });

  Future<Either<ServerException, ProductFeaturesUsageInfo?>>
  getFeaturesUsageInfo();
}
