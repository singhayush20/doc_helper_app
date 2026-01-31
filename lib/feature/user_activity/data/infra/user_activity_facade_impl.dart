import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/feature/user_activity/data/models/dto_to_entity_mapper.dart';
import 'package:doc_helper_app/feature/user_activity/data/models/user_activity_dto.dart';
import 'package:doc_helper_app/feature/user_activity/domain/entities/user_activity_model.dart';
import 'package:doc_helper_app/feature/user_activity/domain/interface/i_user_activity_facade.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IUserActivityFacade)
class UserActivityFacadeImpl implements IUserActivityFacade {
  UserActivityFacadeImpl(this._apiClient, this._apiCallHandler);

  final RetrofitApiClient _apiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, UserActivityInfo>>
  getUserActivityInfo() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _apiClient.getRecentUserActivityInfo,
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = UserActivityInfoDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return right(dto.toDomain());
    });
  }
}
