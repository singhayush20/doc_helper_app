import 'package:dio/dio.dart';
import 'package:doc_helper_app/feature/user/data/models/user_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_api_client.g.dart';

@singleton
@RestApi()
abstract class RetrofitApiClient {
  @factoryMethod
  factory RetrofitApiClient(Dio dio) = _RetrofitApiClient;

  @POST('/api/v1/auth/signup')
  Future<HttpResponse> signUp(@Body() AppUserDto userDto);

  @GET('/api/v1/user')
  Future<HttpResponse> getUser();
}
