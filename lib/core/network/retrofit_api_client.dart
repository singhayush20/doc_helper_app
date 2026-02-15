import 'package:dio/dio.dart';
import 'package:doc_helper_app/feature/auth/data/models/auth_dto.dart';
import 'package:doc_helper_app/feature/billing/data/models/billing_dto.dart';
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

  @GET('/api/v1/usage/quota')
  Future<HttpResponse> getUsageInfo();

  @GET('/api/v1/billing/products/active')
  Future<HttpResponse> getActiveBillingProducts();

  @GET('/api/v1/billing/products/{productId}/prices/active')
  Future<HttpResponse> getActiveBillingPricesForProduct(
    @Path('productId') int productId,
  );

  @POST('/api/v1/billing/checkout')
  Future<HttpResponse> checkout(@Query('priceCode') String priceCode);

  @GET('/api/v1/billing/subscription/current')
  Future<HttpResponse> getCurrentSubscriptionDetails();

  @POST('/api/v1/billing/subscription/cancel')
  Future<HttpResponse> cancelSubscription();

  @PUT('/api/v1/billing/subscription/cancel-checkout')
  Future<HttpResponse> cancelCheckout(
    @Body() CancelCheckoutDto cancelCheckoutDto,
  );

  @GET('/api/v1/user-activities/recent')
  Future<HttpResponse> getRecentUserActivityInfo();

  @GET('/api/v1/features/ui-components')
  Future<HttpResponse> getUiComponents(
    @Query('screen') String screen,
    @Query('componentType') String componentType,
  );

  @POST('/api/v1/document/upload')
  @MultiPart()
  Future<HttpResponse> uploadDocument(@Part() MultipartFile file);

  @POST('/api/v1/summarizer/documents/{documentId}')
  Future<HttpResponse> summarizeDocument(@Path('documentId') int documentId);

  @GET('/api/v1/summarizer/documents/{documentId}')
  Future<HttpResponse> getDocumentSummaries(@Path('documentId') int documentId);
}
