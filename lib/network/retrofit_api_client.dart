import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_api_client.g.dart';

@singleton
@RestApi()
abstract class RetrofitApiClient {
  @factoryMethod
  factory RetrofitApiClient(Dio dio) = _RetrofitApiClient;

  @POST('/api/v1/auth/signup')
  Future<HttpResponse> signUp(@Body() UserSignUpDto userSignUpDto);

  @POST('/api/v1/auth/sign-in')
  Future<HttpResponse> signIn(@Body() UserSignInDto userSignInDto);

  @GET('/api/v1/user')
  Future<HttpResponse> getUser();
}
