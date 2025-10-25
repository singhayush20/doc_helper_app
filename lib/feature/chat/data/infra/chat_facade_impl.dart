import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/chat/data/models/chat_dto.dart';
import 'package:doc_helper_app/feature/chat/data/models/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';
import 'package:doc_helper_app/feature/chat/domain/interface/i_chat_facade.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IChatFacade, env: injectionEnv)
class ChatFacadeImpl implements IChatFacade {
  ChatFacadeImpl(this._retrofitApiClient, this._apiCallHandler);

  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;

  @override
  Future<Either<ServerException, ChatMessage>> getAnswerForDocQuestion({
    required int documentId,
    required String question,
    required bool webSearch,
  }) async {
    final chatRequest = ChatRequestDto(
      documentId: documentId,
      question: question,
    );
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getAnswerForDocQuestion,
      [webSearch, chatRequest],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = ChatMessageDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }

  @override
  Future<Either<ServerException, ChatHistory>> getChatHistory({
    required int documentId,
    required int page,
  }) async {
    final responseOrError = await _apiCallHandler.handleApi(
      _retrofitApiClient.getChatHistory,
      [documentId, page],
    );

    return responseOrError.fold((error) => left(error), (response) {
      final dto = ChatHistoryDto.fromJson(response.data);
      return right(dto.toDomain());
    });
  }
}
