import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/plan/data/dto/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/plan/data/dto/plan_info_dto.dart';
import 'package:doc_helper_app/feature/plan/domain/interface/i_plan_facade.dart';
import 'package:doc_helper_app/feature/plan/domain/models/plan_info.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IPlanFacade, env: injectionEnv)
class PlanFacadeImpl implements IPlanFacade {
  PlanFacadeImpl(this._retrofitApiClient, this._apiCallHandler);

  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, PlanInfo?>> getUsageInfo() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getUsageInfo,
      [],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = PlanInfoDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }
}
