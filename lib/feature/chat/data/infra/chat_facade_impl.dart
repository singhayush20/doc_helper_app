import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:doc_helper_app/core/common/constants/enums.dart';
import 'package:doc_helper_app/core/exception_handling/server_exception.dart';
import 'package:doc_helper_app/core/network/api_call_handler.dart';
import 'package:doc_helper_app/core/network/retrofit_api_client.dart';
import 'package:doc_helper_app/core/network/sse_handler/i_sse_handler.dart';
import 'package:doc_helper_app/env/env_config.dart';
import 'package:doc_helper_app/feature/chat/data/models/chat_dto.dart';
import 'package:doc_helper_app/feature/chat/data/models/dto_to_model_mapper.dart';
import 'package:doc_helper_app/feature/chat/domain/entities/chat_entities.dart';
import 'package:doc_helper_app/feature/chat/domain/interface/i_chat_facade.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: IChatFacade, env: injectionEnv)
class ChatFacadeImpl implements IChatFacade {
  ChatFacadeImpl(this._retrofitApiClient,
      this._apiCallHandler,
      this._sseHandler,);

  final RetrofitApiClient _retrofitApiClient;
  final ApiCallHandler _apiCallHandler;
  final ISseHandler _sseHandler;
  StreamSubscription? _internalSubscription;

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

  @override
  Stream<Either<ServerException, QuestionAnswerResponse>>
  getAnswerStreamForQuestion({
    required int documentId,
    required String question,
    required bool webSearch,
  }) async* {
    final requestDto = ChatRequestDto(
      documentId: documentId,
      question: question,
    );

    try {
      await _sseHandler.start(
        url: '/api/v1/chatbot/doc-question/stream',
        queryParams: {'webSearch': webSearch},
        body: requestDto.toJson(),
      );
    } catch (e) {
      yield left(
        const ServerException(
          metaData: ExceptionMetaData(
            message: 'Something Went Wrong when reading the answer!',
          ),
          exceptionType: ServerExceptionType.sseError,
        ),
      );
      return;
    }

    final stream = _sseHandler.stream;
    if (stream == null) {
      yield left(
        const ServerException(
          metaData: ExceptionMetaData(message: 'Unable to get the answer!'),
          exceptionType: ServerExceptionType.sseError,
        ),
      );
      return;
    }

    final controller =
    StreamController<Either<ServerException, QuestionAnswerResponse>>();

    _internalSubscription = stream.listen(
          (sseEvent) {
        try {
          final rawResponse = sseEvent.data.trim();

          QuestionAnswerResponseDto dto;
          try {
            final parsed = jsonDecode(rawResponse) as Map<String, dynamic>;
            dto = QuestionAnswerResponseDto.fromJson(parsed);
            controller.add(
              right(
                QuestionAnswerResponse(
                  message: dto.message,
                  event: sseEvent.event,
                ),
              ),
            );
          } catch (e) {
            controller.add(
              left(
                ServerException(
                  exceptionType: ServerExceptionType.sseError,
                  metaData: ExceptionMetaData(message: e.toString()),
                ),
              ),
            );
          }
        } catch (e) {
          controller.add(
            left(
              ServerException(
                exceptionType: ServerExceptionType.sseError,
                metaData: ExceptionMetaData(message: e.toString()),
              ),
            ),
          );
          _sseHandler.stop();
          controller.close();
        }
      },
      onError: (err, st) {
        controller.add(
          left(
            ServerException(
              exceptionType: ServerExceptionType.sseError,
              metaData: ExceptionMetaData(message: err.toString()),
            ),
          ),
        );
        controller.close();
      },
      onDone: () {
        controller.close();
      },
      cancelOnError: true,
    );

    yield* controller.stream;

    await _internalSubscription?.cancel();
    _internalSubscription = null;
  }

  @override
  Future<void> cancelCurrentStream() async {
    try {
      await _internalSubscription?.cancel();
    } finally {
      await _sseHandler.stop();
      _internalSubscription = null;
    }
  }
}
