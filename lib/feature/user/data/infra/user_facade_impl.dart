import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/user/data/models/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/user/data/models/user_dto.dart';
import 'package:doc_helper_app/feature/user/domain/entity/user.dart';
import 'package:doc_helper_app/feature/user/domain/interface/i_user_facade.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IUserFacade, env: injectionEnv)
class UserFacadeImpl implements IUserFacade {
  UserFacadeImpl(this._apiCallHandler, this._retrofitApiClient);

  final ApiCallHandler _apiCallHandler;
  final RetrofitApiClient _retrofitApiClient;

  @override
  Future<Either<ServerException, AppUser?>> getUserInfo() async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getUserInfo,
    );

    return responseOrError.fold((exception) => left(exception), (response) {
      final dto = AppUserDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }
}
