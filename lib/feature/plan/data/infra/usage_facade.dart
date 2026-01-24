import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/plan/data/dto/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/plan/data/dto/usage_info_dto.dart';
import 'package:doc_helper_app/feature/plan/domain/interface/i_usage_facade.dart';
import 'package:doc_helper_app/feature/plan/domain/models/usage_info.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IUsageFacade, env: injectionEnv)
class UsageFacadeImpl implements IUsageFacade {
  UsageFacadeImpl(this._retrofitApiClient, this._apiCallHandler);

  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, UsageInfo?>> getUsageInfo() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getUsageInfo,
      [],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = UsageInfoDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }
}
