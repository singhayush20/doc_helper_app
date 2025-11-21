import 'package:dio/dio.dart';
import 'package:doc_helper_app/feature/auth/data/models/auth_dto.dart';
import 'package:doc_helper_app/feature/chat/data/models/chat_dto.dart';
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

  @POST('/api/v1/auth/email/otp')
  Future<HttpResponse> sendEmailVerificationOtp(
    @Body() EmailVerificationDto emailVerificationDto,
  );

  @POST('/api/v1/auth/email/verify-otp')
  Future<HttpResponse> verifyEmailVerificationOtp(
    @Body() EmailVerificationDto emailVerificationDto,
  );

  @POST('/api/v1/auth/password/otp')
  Future<HttpResponse> sendPasswordResetOtp(
    @Body() EmailVerificationDto emailVerificationDto,
  );

  @POST('/api/v1/auth/password/reset')
  Future<HttpResponse> resetPassword(
    @Body() PasswordResetRequestDto passwordResetRequestDto,
  );

  @POST('/api/v1/user-docs/upload')
  @MultiPart()
  Future<HttpResponse> uploadDoc(@Part() MultipartFile file);

  @GET('/api/v1/user-docs/all')
  Future<HttpResponse> getAllDocs(
    @Query('page') int page,
    @Query('size') int size,
    @Query('sortField') String sortField,
    @Query('direction') String direction,
  );

  @DELETE('/api/v1/user-docs/{documentId}')
  Future<HttpResponse> deleteDocument(@Path('documentId') int documentId);

  @POST('/api/v1/chatbot/doc-question')
  Future<HttpResponse> getAnswerForDocQuestion(
    @Query('webSearch') bool webSearch,
    @Body() ChatRequestDto chatRequest,
  );

  @GET('/api/v1/chatbot/chat-history')
  Future<HttpResponse> getChatHistory(
    @Query('documentId') int documentId,
    @Query('page') int page,
  );

  @GET('/api/v1/user/user-info')
  Future<HttpResponse> getUserInfo();

  @GET('/api/v1/user-docs/search')
  Future<HttpResponse> getDocSearchResults(
    @Query('query') String query,
    @Query('page') int page,
    @Query('size') int size,
  );

  @POST('/api/v1/chatbot/doc-question/stream/cancel')
  Future<HttpResponse> cancelChatMessage(
    @Query('generationId') String generationId,
  );
}
